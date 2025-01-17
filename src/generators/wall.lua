local class = require "middleclass"


local Wall = class("Wall")

function Wall:initialize(x1, y1, x2, y2)
    self.x1 = x1
    self.y1 = y1

    self.x2 = x2
    self.y2 = y2
end

function Wall:__eq(other)
    if self.x1 == other.x1 and self.y1 == other.y1 and self.x2 == other.x2 and self.y2 == other.y2 then
        return true
    end

    return false
end

function Wall:get()
    return self.x1, self.y1, self.x2, self.y2
end

function Wall:get_points()
    local start_x, start_y, end_x, end_y = self.x1, self.y1, self.x2, self.y2

    if self.x1 > self.x2 then
        start_x, end_x, start_y, end_y = self.x2, self.x1, self.y2, self.y1
    end

    if self.y1 > self.y2 then
        start_y, end_y, start_x, end_x = self.y2, self.y1, self.x2, self.x1
    end

    local result = {}

    for i = start_x, end_x do
        for j = start_y, end_y do
            table.insert(result, {x = i, y = j})
        end
    end

    return result
end

return Wall
