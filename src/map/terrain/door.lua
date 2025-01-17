local class = require "middleclass"

local BaseTerrain = require "map.terrain.base_terrain"

local Terrains = require "enums.terrains"
local Tiles = require "enums.tiles"


local Door = class("Door", BaseTerrain)

function Door:initialize()
    local data = {
        walkable = true,
        terrain_type = Terrains.door,
        tile = Tiles.closed_door,
        transparent = false
    }

    BaseTerrain.initialize(self, data)

    self.closed = true
end

function Door:is_closed()
    return self.closed
end

function Door:open()
    self.closed = false
    self:set_tile(Tiles.open_door)
    self:set_transparent(true)
end

return Door
