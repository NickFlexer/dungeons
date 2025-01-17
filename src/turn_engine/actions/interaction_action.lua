local class = require "middleclass"

local BaseAction = require "turn_engine.actions.base_action"

local ActionResult = require "turn_engine.action_result"

local LogMessageEvent = require "events.common.log_message_event"
local UpdateViewEvent = require "events.view.update_menu_view_event"

local Teams = require "enums.teams"
local UITypes = require "enums.ui_types"


local InteractionAction = class("InteractionAction", BaseAction)

function InteractionAction:initialize()
    BaseAction.initialize(self, 10)
end

function InteractionAction:perform(data, unit)
    local map_data = data.map:get()
    local cur_x, cur_y = unit:get_position()
    local cell = map_data:get_cell(cur_x, cur_y)

    local action = cell:get_action()

    if action then
        local res = action(data)

        if res then
            data.event_manager:post_event(UpdateViewEvent(nil, UITypes.gameplay))
            return ActionResult({success = true})
        else
            data.event_manager:post_event(UpdateViewEvent(nil, UITypes.gameplay))
            return ActionResult({success = false})
        end
    else
        if unit:get_team() == Teams.hero then
            data.event_manager:post_event(LogMessageEvent("Тут не с чем взаимодействовать!"))
        end

        data.event_manager:post_event(UpdateViewEvent(nil, UITypes.gameplay))

        return ActionResult({success = false})
    end
end

return InteractionAction
