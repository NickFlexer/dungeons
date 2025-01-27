local class = require "middleclass"

local Barrel = require "map.environment.barrel"

local Tile = require "entity.components.tile"

local Tiles = require "enums.tiles"


local EnvironmentFactory = class("EnvironmentFactory")

function EnvironmentFactory:initialize()
    
end

function EnvironmentFactory:get_barrel()
    local barrel = Barrel()
    barrel:add(Tile({
        main = Tiles.barrel,
        corpse = Tiles.destroyed_barrel
    }))

    return barrel
end

return EnvironmentFactory
