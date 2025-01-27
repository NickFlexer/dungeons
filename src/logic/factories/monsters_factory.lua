local class = require "middleclass"

local SkeletonWarrior = require "units.monsters.skeleton_warrior"

local Tile = require "entity.components.tile"

local Tiles = require "enums.tiles"


local MonstersFactory = class("MonstersFactory")

function MonstersFactory:initialize()
    
end

function MonstersFactory:get_skeleton()
    local skeleton_warrior = SkeletonWarrior()
    skeleton_warrior:add(Tile({
        main = Tiles.skeleton_warrior,
        corpse = Tiles.skeleton_corpse
    }))

    return skeleton_warrior
end

return MonstersFactory
