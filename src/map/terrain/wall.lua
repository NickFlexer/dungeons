local class = require "middleclass"

local BaseTerrain = require "map.terrain.base_terrain"

local Terrains = require "enums.terrains"
local Tiles = require "enums.tiles"


local Wall = class("Wall", BaseTerrain)

function Wall:initialize()
    local data = {
        walkable = false,
        terrain_type = Terrains.wall,
        tile = Tiles.wall_0,
        transparent = false
    }

    BaseTerrain.initialize(self, data)
end

return Wall
