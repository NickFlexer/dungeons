local class = require "middleclass"

local InputActionEvent = require "events.common.input_action_event"
local LogMessageEvent = require "events.common.log_message_event"
local UpdateViewEvent = require "events.view.update_menu_view_event"
local ClearActorsEvent = require "events.engine.clear_actors_event"
local ChangeGameStateEvent = require "events.common.change_game_state_event"
local ClearLogEvent = require "events.common.clear_log_event"

local InputActions = require "enums.input_actions"
local Colors = require "enums.colors"
local UITypes = require "enums.ui_types"
local GameStates = require "enums.game_states"


local GameOverState = class("GameOverState")

function GameOverState:initialize(data)
    self.event_manager = data.event_manager
    self.logic = data.logic
    self.map = data.map
    self.engine = data.engine
end

function GameOverState:enter(owner)
    print("GameOverState enter!")

    local msg = {
        Colors.green, self.logic:get_hero():get_properties():get_name(),
        Colors.white, " погиб в этом подземелье. Игра окончена. Нажмите ",
        Colors.orange,
        "Enter",
        Colors.white,
        " для выхода."
    }

    self.event_manager:post_event(LogMessageEvent(msg))
    self.event_manager:post_event(UpdateViewEvent(nil, UITypes.gameplay))
end

function GameOverState:execute(owner, dt)
end

function GameOverState:exit(owner)
    print("GameOverState exit!")
end

function GameOverState:handle_events(event)
    if event.class.name == InputActionEvent.name then
        if event:get_action() == InputActions.enter then
            self.event_manager:post_event(ClearActorsEvent())
            self.event_manager:post_event(ClearLogEvent())
            self.event_manager:post_event(ChangeGameStateEvent(GameStates.start_menu))
        end
    end
end

return GameOverState
