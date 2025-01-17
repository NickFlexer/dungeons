local class = require "middleclass"

local BaseAction = require "turn_engine.actions.base_action"

local ActionResult = require "turn_engine.action_result"

local LogMessageEvent = require "events.common.log_message_event"
local SolveFovEvent = require "events.map.solve_fov_event"
local UpdateViewEvent = require "events.view.update_menu_view_event"

local UITypes = require "enums.ui_types"


local OpenDoorAction = class("OpenDoorAction", BaseAction)

function OpenDoorAction:initialize(x, y)
    BaseAction.initialize(self, 10)

    self.door_x = x
    self.door_y = y
end

function OpenDoorAction:perform(data, unit)
    local map_data = data.map:get()

    map_data:get_cell(self.door_x, self.door_y):get_terrain():open()
    data.event_manager:post_event(LogMessageEvent("Дверь открыта"))

    data.event_manager:post_event(SolveFovEvent())
    data.event_manager:post_event(UpdateViewEvent(nil, UITypes.gameplay))

    return ActionResult({success = true})
end

return OpenDoorAction
