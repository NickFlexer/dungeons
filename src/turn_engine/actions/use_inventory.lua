local class = require "middleclass"

local BaseAction = require "turn_engine.actions.base_action"

local ActionResult = require "turn_engine.action_result"

local LogMessageEvent = require "events.common.log_message_event"
local UpdateViewEvent = require "events.view.update_menu_view_event"
local ChangeGameStateEvent = require "events.common.change_game_state_event"

local GameStates = require "enums.game_states"
local Teams = require "enums.teams"
local Colors = require "enums.colors"
local UITypes = require "enums.ui_types"


local UseInventory = class("UseInventory", BaseAction)

function UseInventory:initialize()
    BaseAction.initialize(self, 10)

    self.msg = {}
end

function UseInventory:perform(data, unit)
    if unit:get_team() == Teams.hero then
        self:_get_name(unit)
        self:_add_to_msg(Colors.white)
        self:_add_to_msg(" залез в инвентарь")

        data.event_manager:post_event(ChangeGameStateEvent(GameStates.inventory))
    end

    data.event_manager:post_event(LogMessageEvent(self.msg))
    data.event_manager:post_event(UpdateViewEvent(nil, UITypes.gameplay))

    return ActionResult({success = true})
end

function UseInventory:_add_to_msg(block)
    table.insert(self.msg, block)
end

function UseInventory:_get_name(unit)
    local team = unit:get_team()

    if team == Teams.hero then
        self:_add_to_msg(Colors.green)
    elseif team == Teams.monsters then
        self:_add_to_msg(Colors.red)
    end

    self:_add_to_msg(unit:get_properties():get_name())
end

return UseInventory
