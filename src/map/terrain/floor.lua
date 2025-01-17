local class = require "middleclass"

local BaseTerrain = require "map.terrain.base_terrain"

local Terrains = require "enums.terrains"
local Tiles = require "enums.tiles"


local Floor = class("Floor", BaseTerrain)

function Floor:initialize()
    local data = {
        walkable = true,
        terrain_type = Terrains.floor,
        tile = Tiles.floor_1,
        transparent = true
    }

    BaseTerrain.initialize(self, data)
end

return Floor
