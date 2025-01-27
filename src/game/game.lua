local class = require "middleclass"
local EventManager = require "event_manager"
local FSM = require "fsm"
local Timer = require "hump.timer"

local GameLogic = require "logic.game_logic"

local InputController = require "input.input_controller"
local ViewController = require "view.view_controller"

local Map = require "map.map"
local TurnEngine = require "turn_engine.engine"

local ChangeGameStateEvent = require "events.common.change_game_state_event"
local UpdateMenuViewEvent = require "events.view.update_menu_view_event"
local InputActionEvent = require "events.common.input_action_event"
local AddActorEvent = require "events.engine.add_actor_event"
local RemoveActorEvent = require "events.engine.remove_actor_event"
local ClearActorsEvent = require "events.engine.clear_actors_event"
local SolveFovEvent = require "events.map.solve_fov_event"
local AddEffectEvent = require "events.map.add_effect_event"
local LogMessageEvent = require "events.common.log_message_event"
local ClearLogEvent = require "events.common.clear_log_event"

local StartMenuState = require "game.states.start_menu_state"
local SelectPlayerState = require "game.states.select_player_state"
local GenerateMapState = require "game.states.generate_map_state"
local GameplayState = require "game.states.gameplay_state"
local GameOverState = require "game.states.game_over_state"
local FinishLevelState = require "game.states.finish_level_state"
local InventoryState = require "game.states.inventory_state"

local GameStates = require "enums.game_states"


local Game = class("Game")

function Game:initialize()
    self.event_manager = EventManager()
    self.fsm = FSM(self)
    self.timer = Timer()

    self.logic = GameLogic()
    self.map = Map(
        {
            event_manager = self.event_manager,
            logic = self.logic,
            timer = self.timer
        }
    )
    self.turn_engine = TurnEngine()

    self.input_controller = InputController({event_manager = self.event_manager})
    self.view_controller = ViewController(
        {
            event_manager = self.event_manager,
            map = self.map,
            logic = self.logic
        }
    )

    self.event_manager:add_listener(ChangeGameStateEvent.name, self, self.handle_events)
    self.event_manager:add_listener(InputActionEvent.name, self, self.handle_events)
    self.event_manager:add_listener(UpdateMenuViewEvent.name, self.view_controller, self.view_controller.handle_events)
    self.event_manager:add_listener(AddActorEvent.name, self.turn_engine, self.turn_engine.handle_events)
    self.event_manager:add_listener(RemoveActorEvent.name, self.turn_engine, self.turn_engine.handle_events)
    self.event_manager:add_listener(ClearActorsEvent.name, self.turn_engine, self.turn_engine.handle_events)
    self.event_manager:add_listener(SolveFovEvent.name, self.map, self.map.handle_events)
    self.event_manager:add_listener(AddEffectEvent.name, self.map, self.map.handle_events)
    self.event_manager:add_listener(LogMessageEvent.name, self.logic, self.logic.handle_events)
    self.event_manager:add_listener(ClearLogEvent.name, self.logic, self.logic.handle_events)

    local state_data = {
        event_manager = self.event_manager,
        logic = self.logic,
        map = self.map,
        engine = self.turn_engine
    }

    self.states = {
        [GameStates.start_menu] = StartMenuState(state_data),
        [GameStates.select_player] = SelectPlayerState(state_data),
        [GameStates.generate_map] = GenerateMapState(state_data),
        [GameStates.gameplay] = GameplayState(state_data),
        [GameStates.game_over] = GameOverState(state_data),
        [GameStates.finish_level_state] = FinishLevelState(state_data),
        [GameStates.inventory] = InventoryState(state_data)
    }
end

function Game:start()
    self.event_manager:post_event(ChangeGameStateEvent(GameStates.start_menu))
end

function Game:update(dt)
    self.input_controller:handle_input()

    self.fsm:update(dt)
    self.timer:update(dt)

    self.view_controller:update(dt)
end

function Game:draw()
    self.view_controller:draw()
end

function Game:handle_events(event)
    if event.class.name == ChangeGameStateEvent.name then
        self.fsm:change_state(self.states[event:get_name()])
    elseif event.class.name == InputActionEvent.name then
        self.fsm:get_current_state():handle_events(event)
    end
end

return Game
