local class = require "middleclass"

local Entity = require "entity.entity"


local BaseItem = class("BaseItem", Entity)

function BaseItem:initialize(data)
    Entity.initialize(self)

    self.tile = data.tile
    self.x = data.x
    self.y = data.y
end

function BaseItem:get_tile()
    return self.tile
end

function BaseItem:get_position()
    return self.x, self.y
end

function BaseItem:set_position(x, y)
    self.x = x
    self.y = y
end

function BaseItem:clear_position()
    self.x = nil
    self.y = nil
end

return BaseItem
