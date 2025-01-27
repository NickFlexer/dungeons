local class = require "middleclass"

local HeroWarrior = require "units.heroes.warrior"

local Tile = require "entity.components.tile"
local Inventory = require "entity.components.inventory"

local PotionsFactory = require "logic.factories.potions_factory"

local Tiles = require "enums.tiles"


local HeroesFactory = class("HeroesFactory")

function HeroesFactory:initialize()
    self.potions_factory = PotionsFactory()
end

function HeroesFactory:get_warrior()
    local warrior = HeroWarrior()
    warrior:add(Tile({
        main = Tiles.hero_warrior,
        corpse = Tiles.hero_warrior_corpse
    }))
    warrior:add(Inventory({
        max_value = 12,
        preset = {
            self.potions_factory:get_heal_potion(),
            self.potions_factory:get_heal_potion(),
            self.potions_factory:get_heal_potion()
        }
    }))

    return warrior
end

return HeroesFactory
