local class = require "middleclass"

local UpdateViewEvent = require "events.view.update_menu_view_event"
local InputActionEvent = require "events.common.input_action_event"
local SolveFovEvent = require "events.map.solve_fov_event"
local ChangeGameStateEvent = require "events.common.change_game_state_event"

local MoveAction = require "turn_engine.actions.move_action"
local WaitAction = require "turn_engine.actions.wait_action"
local InteractionAction = require "turn_engine.actions.interaction_action"
local UseInventory = require "turn_engine.actions.use_inventory"

local UITypes = require "enums.ui_types"
local InputActions = require "enums.input_actions"
local Directions = require "enums.directions"
local GameStates = require "enums.game_states"


local GameplayState = class("GameplayState")

function GameplayState:initialize(data)
    self.event_manager = data.event_manager
    self.logic = data.logic
    self.map = data.map
    self.engine = data.engine
end

function GameplayState:enter(owner)
    print("GameplayState enter!")

    self.event_manager:post_event(SolveFovEvent())
    self.event_manager:post_event(UpdateViewEvent(nil, UITypes.gameplay))
end

function GameplayState:execute(owner, dt)
    local hero = self.logic:get_hero()

    if not hero:get_properties():is_alive() then
        self.event_manager:post_event(ChangeGameStateEvent(GameStates.game_over))
    end

    self.engine:update(
        {
            map = self.map,
            event_manager = self.event_manager,
            logic = self.logic
        }
    )
end

function GameplayState:exit(owner)
    print("GameplayState exit!")
end

function GameplayState:handle_events(event)
    if event.class.name == InputActionEvent.name then
        local hero = self.logic:get_hero()

        if event:get_action() == InputActions.up then
            hero:get_actor():set_action(MoveAction(Directions.up))
        elseif event:get_action() == InputActions.down then
            hero:get_actor():set_action(MoveAction(Directions.down))
        elseif event:get_action() == InputActions.left then
            hero:get_actor():set_action(MoveAction(Directions.left))
        elseif event:get_action() == InputActions.right then
            hero:get_actor():set_action(MoveAction(Directions.right))
        elseif event:get_action() == InputActions.wait then
            hero:get_actor():set_action(WaitAction())
        elseif event:get_action() == InputActions.enter then
            hero:get_actor():set_action(InteractionAction())
        elseif event:get_action() == InputActions.inventory then
            hero:get_actor():set_action(UseInventory())
        end
    end
end

return GameplayState
