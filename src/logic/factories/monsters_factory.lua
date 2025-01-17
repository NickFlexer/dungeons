local class = require "middleclass"

local SkeletonWarrior = require "units.monsters.skeleton_warrior"


local MonstersFactory = class("MonstersFactory")

function MonstersFactory:initialize()
    
end

function MonstersFactory:get_skeleton()
    local skeleton_warrior = SkeletonWarrior()

    return skeleton_warrior
end

return MonstersFactory
