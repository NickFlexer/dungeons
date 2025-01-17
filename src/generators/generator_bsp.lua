local class = require "middleclass"
local Grid = require "grid"

local Node = require "generators.structures.node"
local Tree = require "generators.structures.tree"

local Room = require "generators.room"
local Filler = require "generators.filler"


local GeneratorBSP = class("GeneratorBSP")

function GeneratorBSP:initialize()
    self.map = nil

    self.w_ratio = 0.45
    self.h_ratio = 0.45

    self.filler = Filler()
end

function GeneratorBSP:generate(x, y)
    self.map = Grid(x, y, ".")

    local size_x, size_y = self.map:get_size()
    local root = Node(Room(
        {
            top = 1,
            left = 1,
            width = size_x,
            height = size_y
        }
    ))

    local tree = Tree(root)

    self:_split(root, 4)
    self:_fill_map(tree)
    local result = self:_set_doors(tree)

    if not result then
        return
    end

    local rooms = self:_randomise_rooms(tree)
    self.filler:fill_rooms(rooms, self.map)

    return self.map
end

function GeneratorBSP:_split(node, iter)
    if iter > 0 then
        local result = self:_random_split(node)
        node:set_left(self:_split(result[1], iter - 1))
        node:set_right(self:_split(result[2], iter - 1))
    end

    return node
end

function GeneratorBSP:_random_split(node)
    local left, right

    local x, y = node:get_data():get_pos()
    local w, h = node:get_data():get_size()

    if math.random(1, 2) == 1 then
        -- vertical
        left = Node(Room(
            {
                top = x,
                left = y,
                width = self:_rnd(1, w),
                height = h
            }
        ))

        right = Node(Room(
            {
                top = x + left:get_data():get_w() - 1,
                left = y,
                width = w - left:get_data():get_w() + 1,
                height = h
            }
        ))

        local left_ratio = left:get_data():get_w() / left:get_data():get_h()
        local right_ratio = right:get_data():get_w() / right:get_data():get_h()

        if left_ratio < self.w_ratio or right_ratio < self.w_ratio then
            return self:_random_split(node)
        end
    else
        -- horizontal
        left = Node(Room(
            {
                top = x,
                left = y,
                width = w,
                height = self:_rnd(1, h)
            }
        ))

        right = Node(Room(
            {
                top = x,
                left = y + left:get_data():get_h() - 1,
                width = w,
                height = h - left:get_data():get_h() + 1
            }
        ))

        local left_ratio = left:get_data():get_h() / left:get_data():get_w()
        local right_ratio = right:get_data():get_h() / right:get_data():get_w()

        if left_ratio < self.h_ratio or right_ratio < self.h_ratio then
            return self:_random_split(node)
        end
    end

    return {
        left, right
    }
end

function GeneratorBSP:_fill_map(tree)
    for _, node in tree:iterate() do
        local top, left = node:get_data():get_pos()
        local size_x, size_y = node:get_data():get_size()

        for i = top, top + size_x - 1 do
            self.map:set_cell(i, left, "#")
            self.map:set_cell(i, left + size_y - 1 , "#")
        end

        for j = left, left + size_y - 1 do
            self.map:set_cell(top, j, "#")
            self.map:set_cell(top + size_x - 1, j, "#")
        end
    end
end

function GeneratorBSP:_rnd(min, max)
    return math.floor(math.random() * (max - min + 1) + 1)
end

function GeneratorBSP:_set_doors(tree)
    local iterations = tree:get_iterations()

    for i = #iterations, 1, -1 do
        local rooms = iterations[i]

        for _, cur_room in ipairs(rooms) do
            local brother = cur_room:get_brother()

            if brother then
                local wall = self:_find_common_wall(cur_room:get_data(), brother:get_data())

                if wall then
                    local points = wall:get_points()
                    local get_door = false

                    for _, point in ipairs(points) do
                        if self.map:get_cell(point.x, point.y) == "+" then
                            get_door = true
                        end
                    end

                    if not get_door then
                        local iter = 0
                        local find = false

                        while not find do
                            local rnd_cell = points[math.random(2, #points - 1)]

                            if self:_check_door_place(rnd_cell.x, rnd_cell.y) then
                                self.map:set_cell(rnd_cell.x, rnd_cell.y, "+")
                                find = true
                            end

                            iter = iter + 1

                            if iter > 30 then
                                return false
                            end
                        end
                    end
                end
            end
        end
    end

    return true
end

function GeneratorBSP:_find_common_wall(room1, room2)
    local walls1 = room1:get_walls()
    local walls2 = room2:get_walls()

    for _, wall1 in ipairs(walls1) do
        for _, wall12 in ipairs(walls2) do
            if wall1 == wall12 then
                return wall1
            end
        end
    end
end

function GeneratorBSP:_check_door_place(x, y)
    local dx = {-1, 0, 0, 1}
    local dy = {0, -1, 1, 0}

    local wall_count = 0

    for i = 1, 4 do
        if self.map:get_cell(x + dx[i], y + dy[i]) == "#" then
            wall_count = wall_count + 1
        end
    end

    return wall_count == 2
end

function GeneratorBSP:_randomise_rooms(tree)
    local leafs = tree:get_leafs()

    local result = {}

    while #leafs > 0 do
        local rnd = math.random(1, #leafs)
        local node = table.remove(leafs, rnd)

        table.insert(result, node:get_data())
    end

    return result
end

return GeneratorBSP
