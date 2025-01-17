local class = require "middleclass"

local EntityTypes = require "enums.entity_types"


local BaseEnvironment = class("BaseEnvironment")

function BaseEnvironment:initialize(data)
    self.type = EntityTypes.environment

    self.tile = data.tile
    self.corps_tile = data.corps_tile
    self.x = data.x
    self.y = data.y
    self.properties = data.properties
end

function BaseEnvironment:get_type()
    return self.type
end

function BaseEnvironment:get_tile()
    return self.tile
end

function BaseEnvironment:set_tile(tile)
    self.tile = tile
end

function BaseEnvironment:get_position()
    return self.x, self.y
end

function BaseEnvironment:set_position(x, y)
    self.x = x
    self.y = y
end

function BaseEnvironment:get_properties()
    return self.properties
end

function BaseEnvironment:get_corps_tile()
    return self.corps_tile
end

return BaseEnvironment
