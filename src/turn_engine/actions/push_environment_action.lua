local class = require "middleclass"

local BaseAction = require "turn_engine.actions.base_action"

local ActionResult = require "turn_engine.action_result"

local UpdateViewEvent = require "events.view.update_menu_view_event"
local SolveFovEvent = require "events.map.solve_fov_event"
local LogMessageEvent = require "events.common.log_message_event"
local AddEffectEvent = require "events.map.add_effect_event"

local Directions = require "enums.directions"
local Terrains = require "enums.terrains"
local UITypes = require "enums.ui_types"
local Colors = require "enums.colors"
local Tiles = require "enums.tiles"


local PushEnvironmentAction = class("PushEnvironmentAction", BaseAction)

function PushEnvironmentAction:initialize(direction, environment, move)
    BaseAction.initialize(self, 10)

    self.direction = direction
    self.environment = environment
    self.move = move

    self.msg = {}
end

function PushEnvironmentAction:perform(data, unit)
    local map_data = data.map:get()

    local cur_x, cur_y = self.environment:get_position()
    local dx, dy = self:_get_shift()
    local target_x, target_y = cur_x + dx, cur_y + dy

    if self:_check_is_free(target_x, target_y, map_data) then
        self.environment:set_position(target_x, target_y)
        map_data:get_cell(cur_x, cur_y):remove_entity()
        map_data:get_cell(target_x, target_y):set_entity(self.environment)

        data.event_manager:post_event(SolveFovEvent())
        data.event_manager:post_event(UpdateViewEvent(nil, UITypes.gameplay))

        return ActionResult({success = true, alternative = self.move(self.direction)})
    else
        self:_hit()
        data.event_manager:post_event(AddEffectEvent(cur_x, cur_y, Tiles.fight))

        if self.environment:get_properties():is_alive() then
            local cur_hp, max_hp = self.environment:get_properties():get_hp()

            self:_add_to_msg(Colors.orange)
            self:_add_to_msg(self.environment:get_properties():get_name())
            self:_add_to_msg(Colors.white)
            self:_add_to_msg(". Прочность ")
            self:_add_to_msg(Colors.red)
            self:_add_to_msg(tostring(cur_hp) .. "/" .. tostring(max_hp))
        else
            self:_add_to_msg(Colors.orange)
            self:_add_to_msg(self.environment:get_properties():get_name())
            self:_add_to_msg(Colors.white)
            self:_add_to_msg(" разрушается")

            self:_remove_environment(map_data)
        end

        data.event_manager:post_event(LogMessageEvent(self.msg))
        data.event_manager:post_event(SolveFovEvent())
        data.event_manager:post_event(UpdateViewEvent(nil, UITypes.gameplay))

        return ActionResult({success = true})
    end
end

function PushEnvironmentAction:_get_shift()
    if self.direction == Directions.up then
        return 0, -1
    elseif self.direction == Directions.down then
        return 0, 1
    elseif self.direction == Directions.left then
        return -1, 0
    elseif self.direction == Directions.right then
        return 1, 0
    end
end

function PushEnvironmentAction:_check_is_free(x, y, map)
    local terrain = map:get_cell(x, y):get_terrain()

    if terrain:is_walkable() then
        if map:get_cell(x, y):get_terrain():get_type() ~= Terrains.floor then
            return false
        end

        local entity = map:get_cell(x, y):get_entity()

        if not entity then
            return true
        end
    end

    return false
end

function PushEnvironmentAction:_hit()
    self.environment:get_properties():take_damage(1)
end

function PushEnvironmentAction:_add_to_msg(block)
    table.insert(self.msg, block)
end

function PushEnvironmentAction:_remove_environment(map)
    local x, y = self.environment:get_position()
    map:get_cell(x, y):remove_entity()

    local corpse_tile = self.environment:get_corps_tile()
    map:get_cell(x, y):get_terrain():add_decoration(corpse_tile)
end

return PushEnvironmentAction
