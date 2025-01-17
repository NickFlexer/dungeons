local class = require "middleclass"

local BaseUnit = require "units.base_unit"
local Properties = require "units.properties"

local SkeletonWarriorBrain = require "ai.skeleton_warrior_brain"

local Tiles = require "enums.tiles"
local Teams = require "enums.teams"


local SkeletonWarrior = class("SkeletonWarrior", BaseUnit)

function SkeletonWarrior:initialize()
    local data = {
        team = Teams.monsters,
        tile = Tiles.skeleton_warrior,
        corps_tile = Tiles.skeleton_corpse,
        speed = 8,
        brain = SkeletonWarriorBrain(),
        properties = Properties({
            name = "Скелет воин",
            hp = 10,
            min_damage = 1,
            max_damage = 4,
            accuracy = 70,
            crit_chanse = 5,
            view_distance = 12
        })
    }

    BaseUnit.initialize(self, data)
end

return SkeletonWarrior
