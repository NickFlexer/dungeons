local class = require "middleclass"

local Wall = require "generators.wall"


local Room = class("Room")

function Room:initialize(data)
    self.x = data.top
    self.y = data.left
    self.width = data.width
    self.height = data.height

    self.walls = {
        Wall(self.x, self.y, self.x + self.width - 1, self.y),
        Wall(self.x + self.width - 1, self.y, self.x + self.width - 1, self.y + self.height - 1),
        Wall(self.x, self.y, self.x, self.y + self.height - 1),
        Wall(self.x, self.y + self.height - 1, self.x + self.width - 1, self.y + self.height - 1)
    }
end

function Room:get_pos()
    return self.x, self.y
end

function Room:get_x()
    return self.x
end

function Room:get_y()
    return self.y
end

function Room:get_size()
    return self.width, self.height
end

function Room:get_w()
    return self.width
end

function Room:get_h()
    return self.height
end

function Room:get_walls()
    return self.walls
end

function Room:get_indoor()
    local result = {}

    for i = self.x + 1, self.x + self.width - 2 do
        for j = self.y + 1, self.y + self.height - 2 do
            table.insert(result, {x = i, y = j})
        end
    end

    return result
end

return Room
