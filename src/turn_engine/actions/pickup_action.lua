local class = require "middleclass"

local BaseAction = require "turn_engine.actions.base_action"

local ActionResult = require "turn_engine.action_result"

local LogMessageEvent = require "events.common.log_message_event"
local UpdateViewEvent = require "events.view.update_menu_view_event"

local Inventory = require "entity.components.inventory"
local Info = require "entity.components.info"

local UITypes = require "enums.ui_types"
local Colors = require "enums.colors"
local Teams = require "enums.teams"


local PickupAction = class("PickupAction", BaseAction)

function PickupAction:initialize()
    BaseAction.initialize(self, 10)

    self.msg = {}
end

function PickupAction:perform(data, unit)
    if unit:get(Inventory.name):can_add() then
        local pos_x, pos_y = unit:get_position()
        local item = data.map:get():get_cell(pos_x, pos_y):remove_item()
        unit:get(Inventory.name):add_item(item)

        self:_get_name(unit)
        self:_add_block_to_msg(item:get(Info.name):get_on_pickup())

        data.event_manager:post_event(LogMessageEvent(self.msg))
        data.event_manager:post_event(UpdateViewEvent(nil, UITypes.gameplay))

        return ActionResult({success = true})
    else
        data.event_manager:post_event(LogMessageEvent("Инвентарь полон!"))
        data.event_manager:post_event(UpdateViewEvent(nil, UITypes.gameplay))

        return ActionResult({success = false})
    end
end

function PickupAction:_add_to_msg(block)
        table.insert(self.msg, block)
end

function PickupAction:_add_block_to_msg(block)
    for _, value in ipairs(block) do
        table.insert(self.msg, value)
    end
end

function PickupAction:_get_name(unit)
    local team = unit:get_team()

    if team == Teams.hero then
        self:_add_to_msg(Colors.green)
    elseif team == Teams.monsters then
        self:_add_to_msg(Colors.red)
    end

    self:_add_to_msg(unit:get_properties():get_name())
end

return PickupAction
