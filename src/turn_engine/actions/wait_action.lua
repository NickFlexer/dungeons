local class = require "middleclass"

local BaseAction = require "turn_engine.actions.base_action"

local ActionResult = require "turn_engine.action_result"

local LogMessageEvent = require "events.common.log_message_event"
local UpdateViewEvent = require "events.view.update_menu_view_event"

local Teams = require "enums.teams"
local UITypes = require "enums.ui_types"


local WaitAction = class("WaitAction", BaseAction)

function WaitAction:initialize()
    BaseAction.initialize(self, 10)
end

function WaitAction:perform(data, unit)
    if unit:get_team() == Teams.hero then
        data.event_manager:post_event(LogMessageEvent("Решил подождать"))
    end

    data.event_manager:post_event(UpdateViewEvent(nil, UITypes.gameplay))

    return ActionResult({success = true})
end

return WaitAction
