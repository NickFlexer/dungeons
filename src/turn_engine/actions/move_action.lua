local class = require "middleclass"

local BaseAction = require "turn_engine.actions.base_action"
local FightAction = require "turn_engine.actions.fight_action"
local PushEnvironmentAction = require "turn_engine.actions.push_environment_action"
local OpenDoorAction = require "turn_engine.actions.open_door_action"

local ActionResult = require "turn_engine.action_result"

local UpdateViewEvent = require "events.view.update_menu_view_event"
local SolveFovEvent = require "events.map.solve_fov_event"
local LogMessageEvent = require "events.common.log_message_event"
local AddEffectEvent = require "events.map.add_effect_event"

local Directions = require "enums.directions"
local Terrains = require "enums.terrains"
local UITypes = require "enums.ui_types"
local EntityTypes = require "enums.entity_types"
local Tiles = require "enums.tiles"
local Teams = require "enums.teams"


local MoveAction = class("MoveAction", BaseAction)

function MoveAction:initialize(direction)
    BaseAction.initialize(self, 10)

    self.direction = direction
end

function MoveAction:perform(data, unit)
    local map_data = data.map:get()

    local cur_x, cur_y = unit:get_position()
    local dx, dy = self:_get_shift()
    local target_x, target_y = cur_x + dx, cur_y + dy

    if self:_chack_walkable(target_x, target_y, map_data) then
        if self:_check_unit(target_x, target_y, map_data) then
            local target_unit = map_data:get_cell(target_x, target_y):get_entity()

            if self:_is_enimy(unit, target_unit) then
                return ActionResult({success = true, alternative = FightAction(target_unit)})
            else
                return ActionResult({success = false})
            end
        end

        if self:_check_environment(target_x, target_y, map_data) then
            local environment = map_data:get_cell(target_x, target_y):get_entity()

            return ActionResult(
                {
                    success = true,
                    alternative = PushEnvironmentAction(self.direction, environment, MoveAction)
                }
            )
        end

        if self:_check_closed_door(target_x, target_y, map_data) then
            return ActionResult(
                {
                    success = true,
                    alternative = OpenDoorAction(target_x, target_y)
                }
            )
        end

        unit:set_position(target_x, target_y)
        map_data:get_cell(cur_x, cur_y):remove_entity()
        map_data:get_cell(target_x, target_y):set_entity(unit)

        local cell_message = map_data:get_cell(target_x, target_y):get_message()

        if cell_message and unit:get_team() == Teams.hero then
            data.event_manager:post_event(LogMessageEvent(cell_message))
        end

        data.event_manager:post_event(SolveFovEvent())
        data.event_manager:post_event(UpdateViewEvent(nil, UITypes.gameplay))

        return ActionResult({success = true})
    else
        data.event_manager:post_event(AddEffectEvent(target_x, target_y, Tiles.no_pass))
        data.event_manager:post_event(LogMessageEvent("Тут не пройти"))
        data.event_manager:post_event(UpdateViewEvent(nil, UITypes.gameplay))
    end

    return ActionResult({success = false})
end

function MoveAction:_get_shift()
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

function MoveAction:_chack_walkable(x, y, map)
    if map:is_valid(x, y) then
        local terrain = map:get_cell(x, y):get_terrain()

        if terrain:is_walkable() then
            return true
        end
    end

    return false
end

function MoveAction:_check_closed_door(x, y, map)
    local cell = map:get_cell(x, y):get_terrain()

    if cell:get_type() == Terrains.door and cell:is_closed() then
        return true
    end

    return false
end

function MoveAction:_check_unit(x, y, map)
    local entity = map:get_cell(x, y):get_entity()

    if entity then
        return entity:get_type() == EntityTypes.unit
    end

    return false
end

function MoveAction:_check_environment(x, y, map)
    local entity = map:get_cell(x, y):get_entity()

    if entity then
        return entity:get_type() == EntityTypes.environment
    end

    return false
end

function MoveAction:_is_enimy(unit, other)
    local unit_team = unit:get_team()
    local other_team = other:get_team()

    return unit_team ~= other_team
end

return MoveAction
