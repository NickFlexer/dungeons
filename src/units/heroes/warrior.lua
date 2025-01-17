local class = require "middleclass"

local BaseUnit = require "units.base_unit"
local Properties = require "units.properties"

local Tiles = require "enums.tiles"
local Teams = require "enums.teams"


local HeroWarrior = class("HeroWarrior", BaseUnit)

function HeroWarrior:initialize()
    local data = {
        team = Teams.hero,
        tile = Tiles.hero_warrior,
        corps_tile = Tiles.hero_warrior_corpse,
        speed = 9,
        input_actor = true,
        properties = Properties({
            name = "Воин",
            hp = 20,
            min_damage = 5,
            max_damage = 10,
            accuracy = 70,
            crit_chanse = 5,
            view_distance = 12
        })
    }

    BaseUnit.initialize(self, data)
end

return HeroWarrior
