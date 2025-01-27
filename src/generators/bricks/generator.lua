local class = require "middleclass"
local Grid = require "grid"

local Prefab = require "generators.bricks.prefab"


local Generator = class("Generator")

function Generator:initialize()
    self.map = nil
    self.prefabs = {}
    self.interest = {}
    self.required_positions = {}
end

function Generator:generate(map_data)
    local map_size = map_data.size
    self.map = Grid(map_size.x, map_size.y, "?")

    self:_load_prefabs(map_data.prefabs)

    local attempts = 1

    while true do
        local cur_prefab = self.prefabs[math.random(1, #self.prefabs)]
        local positions = self:_find_positions_for_room(cur_prefab)

        if #positions > 0 then
            local best_pos = self:_find_best_position(positions)
            self:_add_to_map(best_pos, cur_prefab)
        else
            attempts = attempts + 1

            if attempts > 20 then
                break
            end
        end
    end

    self:_add_more_connections()
    self:_remove_voids()
    self:_cleanup_connectors()

    self:_find_interest_points()
    self:_fill_interest_points(map_data.content)

    local start_x, start_y = self.required_positions[1].x, self.required_positions[1].y
    local result =  self:_check_map(start_x, start_y)

    if result then
        return self.map
    end
end

function Generator:_load_prefabs(prefabs)
    for _, prefab in ipairs(prefabs) do
        local p1 = Prefab(prefab)
        local p2 = p1:rotate()
        local p3 = p1:mirror_horizontal()
        local p4 = p1:mirror_vertical()
        local p5 = p2:mirror_vertical()
        local p6 = p3:mirror_vertical()
        local p7 = p2:mirror_horizontal()
        local p8 = p5:mirror_horizontal()

        table.insert(self.prefabs, p1)
        table.insert(self.prefabs, p2)
        table.insert(self.prefabs, p3)
        table.insert(self.prefabs, p4)
        table.insert(self.prefabs, p5)
        table.insert(self.prefabs, p6)
        table.insert(self.prefabs, p7)
        table.insert(self.prefabs, p8)
    end
end

function Generator:_find_positions_for_room(prefab)
    local room = prefab:get()
    local positions = {}

    for start_x, start_y, _ in self.map:iterate() do
        local result = true
        local score = 1

        for x, y, room_cell in room:iterate() do
            local dx, dy = start_x + x - 1, start_y + y - 1

            if self.map:is_valid(dx, dy) then
                local map_cell = self.map:get_cell(dx, dy)

                if room_cell == map_cell and map_cell == "." then
                    result = false
                    break
                end

                if room_cell == "#" and map_cell == "." then
                    result = false
                    break
                end

                if room_cell == "X" and map_cell == "#" then
                    result = false
                    break
                end

                if room_cell == "D" and map_cell == "#" then
                    result = false
                    break
                end

                if map_cell == "X" and room_cell == "X" then
                    score = score + 2
                end

                if map_cell == "D" and room_cell == "D" then
                    score = score + 2
                end

                if (map_cell == "X" and room_cell == "D") or (map_cell == "D" and room_cell == "X") then
                    score = score + 1
                end
            else
                result = false
                break
            end
        end

        if result then
            score = score + 1

            if not positions[score] then
                positions[score] = {}
            end

            table.insert(positions[score], {x = start_x, y = start_y})
        end
    end

    return positions
end

function Generator:_add_to_map(position, prefab)
    local room = prefab:get()

    for x, y, cell in room:iterate() do
        local dx, dy = position.x + x - 1, position.y + y - 1

        if cell == "X" and self.map:get_cell(dx, dy) == "X" then
            cell = "."
        end

        if cell == "D" and self.map:get_cell(dx, dy) == "D" then
            cell = "+"
        end

        if cell == "X" and self.map:get_cell(dx, dy) == "D" then
            cell = "+"
        end

        if cell == "D" and self.map:get_cell(dx, dy) == "X" then
            cell = "+"
        end

        if cell ~= "?" then
            self.map:set_cell(dx, dy, cell)
        end
    end
end

function Generator:_find_best_position(positions)
    local pos = {}

    for index, _ in pairs(positions) do
        table.insert(pos, index)
    end

    local rooms = positions[math.max(unpack(pos))]

    return rooms[math.random(1, #rooms)]
end

function Generator:_add_more_connections()
    local check_horizontal = function (x, y, cell)
        if self.map:is_valid(x - 1, y) and self.map:is_valid(x + 1, y) then
            local a = self.map:get_cell(x - 1, y)
            local b = self.map:get_cell(x + 1, y)

            if (a == cell and b == ".") or (a == "." and b == cell) then
                return true
            end

            return false
        else
            return false
        end
    end

    local check_vertical = function (x, y, cell)
        if self.map:is_valid(x, y - 1) and self.map:is_valid(x, y + 1) then
            local a = self.map:get_cell(x, y - 1)
            local b = self.map:get_cell(x, y + 1)

            if (a == cell and b == ".") or (a == "." and b == cell) then
                return true
            end

            return false
        else
            return false
        end
    end

    for x, y, cell in self.map:iterate() do
        if cell == "#" then
            if check_horizontal(x, y, "D") or check_vertical(x, y, "D") then
                self.map:set_cell(x, y, ".")
            end

            if check_horizontal(x, y, "X") or check_vertical(x, y, "X") then
                self.map:set_cell(x, y, ".")
            end
        end
    end
end

function Generator:_cleanup_connectors()
    local get_count = function (x, y, cell)
        local shift = {
            {-1, 0},
            {1, 0},
            {0, -1},
            {0, 1}
        }

        local result = 0

        for _, value in ipairs(shift) do
            if self.map:is_valid(x + value[1], y + value[2]) then
                if self.map:get_cell(x + value[1], y + value[2]) == cell then
                    result = result + 1
                end
            end
        end

        return result
    end

    for x, y, cell in self.map:iterate() do
        if cell == "D" or cell == "X" then
            if get_count(x, y, ".") >= 2 then
                self.map:set_cell(x, y, ".")
            elseif get_count(x, y, "#") >= 2 then
                self.map:set_cell(x, y, "#")
            end
        end
    end
end

function Generator:_remove_voids()
    for x, y, cell in self.map:iterate() do
        if cell == "?" then
            self.map:set_cell(x, y, "#")
        end
    end
end

function Generator:_find_interest_points()
    for x, y, cell in self.map:iterate() do
        if type(tonumber(cell)) == "number" then
            table.insert(self.interest, {x = x, y = y})
        end
    end
end

function Generator:_fill_interest_points(content)
    local unic_data = {}

    for _, value in ipairs(content.unic) do
        table.insert(unic_data, value)
    end

    while #self.interest > 0 do
        local point = table.remove(self.interest, math.random(1, #self.interest))

        if #unic_data > 0 then
            local data = table.remove(unic_data, #unic_data)
            self.map:set_cell(point.x, point.y, data.tile)

            table.insert(self.required_positions, {x = point.x, y = point.y, visited = false})

            if data.neighbours then
                for _, neighbor in ipairs(data.neighbours) do
                    local pos = {}

                    for dx, dy, cell in self.map:iterate_neighbor(point.x, point.y) do
                        if cell == "." then
                            table.insert(pos, {x = point.x + dx, y = point.y + dy})
                        end
                    end

                    local rnd_pos = pos[math.random(1, #pos)]
                    self.map:set_cell(rnd_pos.x, rnd_pos.y, neighbor)
                end
            end
        else
            local data = content.regular[math.random(1, #content.regular)]

            if math.random(1, 100) <= data.chance then
                self.map:set_cell(point.x, point.y, data.tile)
            else
                self.map:set_cell(point.x, point.y, ".")
            end
        end
    end
end

function Generator:_check_map(start_x, start_y)
    local visit_required = function (x, y)
        for _, value in ipairs(self.required_positions) do
            if x == value.x and y == value.y then
                if not value.visited then
                    value.visited = true
                end
            end
        end
    end

    local check_all_required = function ()
        for _, value in ipairs(self.required_positions) do
            if not value.visited then
                return false
            end
        end

        return true
    end

    local size_x, size_y = self.map:get_size()
    local new_map = Grid(size_x, size_y, 0)

    local shift = {
        {-1, 0},
        {1, 0},
        {0, -1},
        {0, 1}
    }

    local no_solution
    local index = 1
    new_map:set_cell(start_x, start_y, index)
    visit_required(start_x, start_y)

    local can_go = function (x, y)
        if self.map:is_valid(x, y) then
            if self.map:get_cell(x, y) ~= "#" then
                return true
            end

            return false
        end

        return false
    end

    repeat
        no_solution = true

        for x, y, cell in new_map:iterate() do
            if cell ==  index then
                for _, value in ipairs(shift) do
                    local dx, dy = x + value[1], y + value[2]

                    if can_go(dx, dy) and new_map:get_cell(dx, dy) == 0 then
                        no_solution = false
                        new_map:set_cell(dx, dy, index + 1)
                        visit_required(dx, dy)
                    end
                end
            end
        end
        index = index + 1
    until no_solution

    for x, y, cell in self.map:iterate() do
        if cell ~= "#" and new_map:get_cell(x, y) == 0 then
            self.map:set_cell(x, y, "#")
        end
    end

    return check_all_required()
end

return Generator
