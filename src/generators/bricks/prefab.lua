local class = require "middleclass"
local Grid = require "grid"


local Prefab = class("Prefab")

function Prefab:initialize(map_str)
    self.map = nil

    if map_str then
        self:_read_str(map_str)
    end
end

function Prefab:get_size()
    return self.map_size_x, self.map_size_y
end

function Prefab:get()
    return self.map
end

function Prefab:set(new_map)
    self.map = new_map
end

function Prefab:_read_str(map_str)
    self.map_size_x = #string.match(map_str, "[^\n]+")
    _, self.map_size_y = string.gsub(map_str, "\n", "")

    self.map = Grid(self.map_size_x, self.map_size_y)

    local x, y = 1, 1

    for row in map_str:gmatch("[^\n]+") do
        x = 1

        for tile in row:gmatch(".") do
            self.map:set_cell(x, y, tile)

            x = x + 1
        end

        y = y + 1
    end
end

function Prefab:draw()
    local size_x, size_y = self.map:get_size()

    for x, y, cell in self.map:iterate() do
        io.write(cell)

        if x == size_x then
            io.write("\n")
        end
    end
end

function Prefab:rotate()
    local other = Prefab()

    local size_x, size_y = self.map:get_size()
    local new_map = Grid(size_y, size_x)

    for x, y, cell in self.map:iterate() do
        new_map:set_cell(y, x, cell)
    end

    other:set(new_map)

    return other
end

function Prefab:mirror_horizontal()
    local other = Prefab()

    local size_x, size_y = self.map:get_size()
    local new_map = Grid(size_x, size_y)

    for x, y, cell in self.map:iterate() do
        local new_x = size_x - x + 1
        new_map:set_cell(new_x, y, cell)
    end

    other:set(new_map)

    return other
end

function Prefab:mirror_vertical()
    local other = Prefab()

    local size_x, size_y = self.map:get_size()
    local new_map = Grid(size_x, size_y)

    for x, y, cell in self.map:iterate() do
        local new_y = size_y - y + 1
        new_map:set_cell(x, new_y, cell)
    end

    other:set(new_map)

    return other
end

return Prefab
