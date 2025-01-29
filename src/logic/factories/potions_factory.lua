local class = require "middleclass"

local Potion = require "map.items.potion"

local Tile = require "entity.components.tile"
local Info = require "entity.components.info"
local Use = require "entity.components.use"

local Tiles = require "enums.tiles"
local Colors = require "enums.colors"


local PotionsFactory = class("PotionsFactory")

function PotionsFactory:initialize()
    
end

function PotionsFactory:get_rnd_potion()
    local potion = self:get_heal_potion()

    return potion
end

function PotionsFactory:get_heal_potion()
    local heal_potion = Potion({})
    heal_potion:add(Tile({
        main = Tiles.heal_potion_small
    }))
    heal_potion:add(Info({
        name = "Пузырек живительного зелья",
        description = "При использовании восстанавливает 10 единиц HP",
        on_map = {
            Colors.white, "Тут лежит ",
            Colors.red, "пузырек живительного зелья"
        },
        on_pickup = {
            Colors.white, " подобрал ",
            Colors.red, "пузырек живительного зелья"
        }
    }))
    heal_potion:add(Use({
        action = function (data)
            if data.unit:get_properties():is_wounded() then
                data.unit:get_properties():heal(10)

                return true
            else
                print("!!!")

                return false
            end
        end
    }))

    return heal_potion
end

return PotionsFactory
