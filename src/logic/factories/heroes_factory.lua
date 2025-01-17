local class = require "middleclass"

local HeroWarrior = require "units.heroes.warrior"


local HeroesFactory = class("HeroesFactory")

function HeroesFactory:initialize()
    
end

function HeroesFactory:get_warrior()
    local warrior = HeroWarrior()

    return warrior
end

return HeroesFactory
