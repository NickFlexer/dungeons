local class = require "middleclass"

local Floor = require "map.terrain.floor"
local Wall = require "map.terrain.wall"
local Door = require "map.terrain.door"
local Stairway = require "map.terrain.stairway"

local StairwayDirections = require "enums.stairway_directions"


local TerrainsFactory = class("TerrainsFactory")

function TerrainsFactory:initialize()
    
end

function TerrainsFactory:get_floor()
    local floor = Floor()

    return floor
end

function TerrainsFactory:get_wall()
    local wall = Wall()

    return wall
end

function TerrainsFactory:get_door()
    local door = Door()

    return door
end

function TerrainsFactory:get_stairway(tile)
    local stairway

    if tile == ">" then
        stairway = Stairway(StairwayDirections.upstairs)
    elseif tile == "<" then
        stairway = Stairway(StairwayDirections.downstairs)
    end

    return stairway
end

return TerrainsFactory
