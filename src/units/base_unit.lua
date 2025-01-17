local class = require "middleclass"

local Actor = require "turn_engine.actor"

local EntityTypes = require "enums.entity_types"


local BaseUnit = class("BaseUnit")

function BaseUnit:initialize(data)
    self.type = EntityTypes.unit

    self.team = data.team
    self.tile = data.tile
    self.corps_tile = data.corps_tile
    self.x = data.x
    self.y = data.y
    self.properties = data.properties

    self.actor = Actor(
        {
            input_actor = data.input_actor or false,
            energy = 10,
            speed = data.speed,
            brain = data.brain
        }
    )
end

function BaseUnit:get_type()
    return self.type
end

function BaseUnit:get_tile()
    return self.tile
end

function BaseUnit:get_corps_tile()
    return self.corps_tile
end

function BaseUnit:set_tile(tile)
    self.tile = tile
end

function BaseUnit:get_position()
    return self.x, self.y
end

function BaseUnit:set_position(x, y)
    self.x = x
    self.y = y
end

function BaseUnit:get_actor()
    return self.actor
end

function BaseUnit:get_properties()
    return self.properties
end

function BaseUnit:get_team()
    return self.team
end

return BaseUnit
