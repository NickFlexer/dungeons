local class = require "middleclass"

local BaseEnvironment = require "map.environment.base_environment"

local Properties = require "units.properties"

local Tiles = require "enums.tiles"


local Barrel = class("Barrel", BaseEnvironment)

function Barrel:initialize()
    local data = {
        tile = Tiles.barrel,
        corps_tile = Tiles.destroyed_barrel,
        properties = Properties({
            name = "Деревянная бочка",
            hp = 3
        })
    }

    BaseEnvironment.initialize(self, data)
end

return Barrel
