local class = require "middleclass"

local List = require "logic.ui.list"

local HeroesFactory = require "logic.factories.heroes_factory"

local ChangeGameStateEvent = require "events.common.change_game_state_event"
local UpdateMenuViewEvent = require "events.view.update_menu_view_event"
local InputActionEvent = require "events.common.input_action_event"

local InputActions = require "enums.input_actions"
local UITypes = require "enums.ui_types"
local GameStates = require "enums.game_states"


local SelectPlayerState = class("SelectPlayerState")

function SelectPlayerState:initialize(data)
    self.event_manager = data.event_manager
    self.logic = data.logic

    self.player_selection = List()
    self.heroes_factory = HeroesFactory()
end

function SelectPlayerState:enter(owner)
    print("SelectPlayerState enter!")

    self.player_selection:set_items({
        {
            text = "Воин",
            description = "Базовый персонаж",
            action = function ()
                local warrior = self.heroes_factory:get_warrior()
                self.logic:set_hero(warrior)

                self.event_manager:post_event(ChangeGameStateEvent(GameStates.generate_map))
            end
        },
        {
            text = "Назад",
            description = "",
            action = function ()
                self.event_manager:post_event(ChangeGameStateEvent(GameStates.start_menu))
            end
        }
    })

    self.event_manager:post_event(UpdateMenuViewEvent(self.player_selection:get_state(), UITypes.list))
end

function SelectPlayerState:execute(owner, dt)
    
end

function SelectPlayerState:exit(owner)
    print("SelectPlayerState exit!")

    self.player_selection:remove_items()
end

function SelectPlayerState:handle_events(event)
    if event.class.name == InputActionEvent.name then
        if event:get_action() == InputActions.down then
            self.player_selection:move_down()
            self.event_manager:post_event(UpdateMenuViewEvent(self.player_selection:get_state(), UITypes.list))
        elseif event:get_action() == InputActions.up then
            self.player_selection:move_up()
            self.event_manager:post_event(UpdateMenuViewEvent(self.player_selection:get_state(), UITypes.list))
        elseif event:get_action() == InputActions.enter then
            self.player_selection:execute_action()
        end
    end
end

return SelectPlayerState
