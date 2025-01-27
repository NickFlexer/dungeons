local class = require "middleclass"


local Inventory = class("Inventory")

function Inventory:initialize(data)
    self.max_value = data.max_value
    self.items = data.preset or {}
end

function Inventory:get_items()
    return self.items
end

function Inventory:remove_item(item)
    local index

    for i, value in ipairs(self.items) do
        if item == value then
            index = i
        end
    end

    return table.remove(self.items, index)
end

return Inventory
