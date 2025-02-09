local class = require "middleclass"

local Info = require "entity.components.info"


local Cell = class("Cell")

function Cell:initialize(data)
    self.terrain = data.terrain
    self.entity = data.entity
    self.item = data.item
    self.effect = nil

    self.obscure = true
    self.shadow = true
end

function Cell:get_terrain()
    return self.terrain
end

function Cell:get_entity()
    return self.entity
end

function Cell:set_entity(entity)
    self.entity = entity
end

function Cell:remove_entity()
    local entity = self.entity
    self.entity = nil

    return entity
end

function Cell:get_item()
    return self.item
end

function Cell:set_item(item)
    self.item = item
end

function Cell:remove_item()
    local item = self.item
    self.item = nil

    return item
end

function Cell:get_effect()
    return self.effect
end

function Cell:set_effect(effect)
    self.effect = effect
end

function Cell:is_obscured()
    return self.obscure
end

function Cell:make_visible()
    self.obscure = false
end

function Cell:is_in_shadow()
    return self.shadow
end

function Cell:illuminate()
    self.shadow = false
end

function Cell:shade()
    self.shadow = true
end

function Cell:get_message()
    local msg

    if self.terrain:get_message() then
        msg = self.terrain:get_message()
    end

    if self.item then
        msg = self.item:get(Info.name):get_msg_on_map()
    end

    if msg then
        return msg
    end
end

function Cell:get_action()
    local action = self.terrain:get_action()

    if action then
        return action
    end
end

return Cell
