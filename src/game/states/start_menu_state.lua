local class = require "middleclass"

local Menu = require "logic.ui.menu"

local ChangeGameStateEvent = require "events.common.change_game_state_event"
local UpdateMenuViewEvent = require "events.view.update_menu_view_event"
local InputActionEvent = require "events.common.input_action_event"

local InputActions = require "enums.input_actions"
local GameStates = require "enums.game_states"
local UITypes = require "enums.ui_types"


local StartMenuState = class("StartMenuState")

function StartMenuState:initialize(data)
    self.event_manager = data.event_manager

    self.start_menu = Menu()
end

function StartMenuState:enter(owner)
    print("StartMenuState enter!")

    self.start_menu:set_items({
        {
            text = "Новая игра",
            action = function ()
                self.event_manager:post_event(ChangeGameStateEvent(GameStates.select_player))
            end
        },
        {
            text = "Выход",
            action = function ()
                love.event.quit()
            end
        }
    })

    self.event_manager:post_event(UpdateMenuViewEvent(self.start_menu:get_state(), UITypes.menu))
end

function StartMenuState:execute(owner, dt)
    
end

function StartMenuState:exit(owner)
    print("StartMenuState exit!")

    self.start_menu:remove_items()
end

function StartMenuState:handle_events(event)
    if event.class.name == InputActionEvent.name then
        if event:get_action() == InputActions.down then
            self.start_menu:move_down()
            self.event_manager:post_event(UpdateMenuViewEvent(self.start_menu:get_state(), UITypes.menu))
        elseif event:get_action() == InputActions.up then
            self.start_menu:move_up()
            self.event_manager:post_event(UpdateMenuViewEvent(self.start_menu:get_state(), UITypes.menu))
        elseif event:get_action() == InputActions.enter then
            self.start_menu:execute_action()
        end
    end
end

return StartMenuState
