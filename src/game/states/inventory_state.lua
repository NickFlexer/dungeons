local class = require "middleclass"

local List = require "logic.ui.list"

local InputActionEvent = require "events.common.input_action_event"
local UpdateMenuViewEvent = require "events.view.update_menu_view_event"
local ChangeGameStateEvent = require "events.common.change_game_state_event"

local Inventory = require "entity.components.inventory"
local Info = require "entity.components.info"
local Use = require "entity.components.use"

local UITypes = require "enums.ui_types"
local InputActions = require "enums.input_actions"
local GameStates = require "enums.game_states"


local InventoryState = class("InventoryState")

function InventoryState:initialize(data)
    self.event_manager = data.event_manager
    self.logic = data.logic
    self.map = data.map
    self.engine = data.engine

    self.inventory = List()
    self.first = true
end

function InventoryState:enter(owner)
    print("InventoryState enter!")
    self.first = true

    self:_set_list()
end

function InventoryState:execute(owner, dt)
    if self.first then
        self.event_manager:post_event(UpdateMenuViewEvent(self.inventory:get_state(), UITypes.list))
        self.first = false
    end
end

function InventoryState:exit(owner)
    print("InventoryState exit!")
    self.inventory:remove_items()
end

function InventoryState:handle_events(event)
    if event.class.name == InputActionEvent.name then
        if event:get_action() == InputActions.escape then
            self.event_manager:post_event(ChangeGameStateEvent(GameStates.gameplay))
        elseif event:get_action() == InputActions.down then
            self.inventory:move_down()
            self.event_manager:post_event(UpdateMenuViewEvent(self.inventory:get_state(), UITypes.list))
        elseif event:get_action() == InputActions.up then
            self.inventory:move_up()
            self.event_manager:post_event(UpdateMenuViewEvent(self.inventory:get_state(), UITypes.list))
        elseif event:get_action() == InputActions.enter then
            self.inventory:execute_action()
            self.inventory:remove_items()
            self:_set_list()
            self.event_manager:post_event(UpdateMenuViewEvent(self.inventory:get_state(), UITypes.list))
        elseif event:get_action() == InputActions.action then
            local item = self.inventory:get_selected_item()
            self:_drop_item(item)

            self.inventory:remove_items()
            self:_set_list()
            self.event_manager:post_event(UpdateMenuViewEvent(self.inventory:get_state(), UITypes.list))
        end
    end
end

function InventoryState:_set_list()
    local hero = self.logic:get_hero()
    local inventory_items = hero:get(Inventory.name):get_items()
    local view_items = {}

    for _, item in ipairs(inventory_items) do
        table.insert(view_items,{
            text = item:get(Info.name):get_name(),
            description = item:get(Info.name):get_description(),
            action = function ()
                local data = {
                    unit = self.logic:get_hero()
                }

                local result = item:get(Use.name):on_use(data)

                if result then
                    hero:get(Inventory.name):remove_item(item)
                end
            end,
            link = item
        })
    end

    self.inventory:set_items(view_items)
end

function InventoryState:_drop_item(item_to_drop)
    local hero = self.logic:get_hero()
    local pos_x, pos_y = hero:get_position()
    local item = hero:get(Inventory.name):remove_item(item_to_drop)

    self.map:plase_item(pos_x, pos_y, item)
end

return InventoryState
