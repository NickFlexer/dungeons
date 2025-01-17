local class = require "middleclass"

local Message = require "logic.ui.message"

local UpdateViewEvent = require "events.view.update_menu_view_event"
local ClearActorsEvent = require "events.engine.clear_actors_event"
local ChangeGameStateEvent = require "events.common.change_game_state_event"

local UITypes = require "enums.ui_types"
local GameStates = require "enums.game_states"


local FinishLevelState = class("FinishLevelState")

function FinishLevelState:initialize(data)
    self.event_manager = data.event_manager
    self.logic = data.logic
    self.map = data.map
    self.engine = data.engine

    self.load_message = Message()
    self.first = true
end

function FinishLevelState:enter(owner)
    print("FinishLevelState enter!")

    self.load_message:set_msg("Загрузка")
    self.first = true
end

function FinishLevelState:execute(owner, dt)
    if self.first then
        self.event_manager:post_event(ClearActorsEvent())
        self.event_manager:post_event(UpdateViewEvent(self.load_message:get_msg(), UITypes.message))
        self.event_manager:post_event(ChangeGameStateEvent(GameStates.generate_map))

        self.first = false
    end
end

function FinishLevelState:exit(owner)
    print("FinishLevelState exit!")
end

function FinishLevelState:handle_events(event)
end

return FinishLevelState
