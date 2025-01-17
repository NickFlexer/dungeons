local class = require "middleclass"

local BaseAction = require "turn_engine.actions.base_action"

local ActionResult = require "turn_engine.action_result"

local RemoveActorEvent = require "events.engine.remove_actor_event"
local LogMessageEvent = require "events.common.log_message_event"
local UpdateViewEvent = require "events.view.update_menu_view_event"
local AddEffectEvent = require "events.map.add_effect_event"

local UITypes = require "enums.ui_types"
local Teams = require "enums.teams"
local Colors = require "enums.colors"
local Tiles = require "enums.tiles"


local FightAction = class("FightAction", BaseAction)

function FightAction:initialize(target_unit)
    BaseAction.initialize(self, 10)

    self.target_unit = target_unit

    self.msg = {}
end

function FightAction:perform(data, unit)
    local accuracy = unit:get_properties():get_accuracy()
    local crit_chanse = unit:get_properties():get_crit_chanse()
    local min_dmg, max_dmg = unit:get_properties():get_damage()
    self:_get_name(unit)

    self:_add_to_msg(Colors.white)

    if self:_is_hit(accuracy) then
        local dmg

        if self:_is_crit(crit_chanse) then
            dmg = max_dmg * 2

            self:_add_to_msg(" нанес критический урон ")
            self:_add_to_msg(Colors.orange)
            self:_add_to_msg(tostring(dmg))
        else
            dmg = self:_get_damage(min_dmg, max_dmg)

            self:_add_to_msg(" нанес урон ")
            self:_add_to_msg(Colors.orange)
            self:_add_to_msg(tostring(dmg))
        end

        self.target_unit:get_properties():take_damage(dmg)

        if self.target_unit:get_properties():is_alive() then
            self:_add_to_msg(Colors.white)
            self:_add_to_msg(". ")
            self:_get_name(self.target_unit)
            self:_add_to_msg(Colors.white)
            self:_add_to_msg(" все еще жив")
        else
            self:_add_to_msg(Colors.white)
            self:_add_to_msg(". ")
            self:_get_name(self.target_unit)
            self:_add_to_msg(Colors.white)
            self:_add_to_msg(" погибает!")

            self:_kill_unit(self.target_unit, data.map:get(), data.event_manager)
        end
    else
        self:_add_to_msg(" промазал!")
    end

    local x, y = self.target_unit:get_position()

    data.event_manager:post_event(AddEffectEvent(x, y, Tiles.fight))
    data.event_manager:post_event(LogMessageEvent(self.msg))
    data.event_manager:post_event(UpdateViewEvent(nil, UITypes.gameplay))

    return ActionResult({success = true})
end

function FightAction:_get_name(unit)
    local team = unit:get_team()

    if team == Teams.hero then
        self:_add_to_msg(Colors.green)
    elseif team == Teams.monsters then
        self:_add_to_msg(Colors.red)
    end

    self:_add_to_msg(unit:get_properties():get_name())
end

function FightAction:_add_to_msg(block)
    table.insert(self.msg, block)
end

function FightAction:_is_hit(accuracy)
    local rnd_hit = math.random(1, 100)

    return rnd_hit <= accuracy
end

function FightAction:_is_crit(crit_chanse)
    local rnd_hit = math.random(1, 100)

    return rnd_hit <= crit_chanse
end

function FightAction:_get_damage(min_dmg, max_dmg)
    return math.random(min_dmg, max_dmg)
end

function FightAction:_kill_unit(unit, map, event_manager)
    if unit:get_team() ~= Teams.hero then
        event_manager:post_event(RemoveActorEvent(unit))
    end

    local x, y = unit:get_position()
    map:get_cell(x, y):remove_entity()

    local corpse_tile = unit:get_corps_tile()
    map:get_cell(x, y):get_terrain():add_decoration(corpse_tile)
end

return FightAction
