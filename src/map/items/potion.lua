local class = require "middleclass"

local BaseItem = require "map.items.base_item"


local Potion = class("Potion", BaseItem)

function Potion:initialize(data)
    local potion_data = {
        tile = data.tile
    }

    BaseItem.initialize(self, potion_data)
end

return Potion
