local class = require "middleclass"
local Shadowcast = require "Shadowcast"

local SolveFovEvent = require "events.map.solve_fov_event"
local AddEffectEvent = require "events.map.add_effect_event"
local UpdateViewEvent = require "events.view.update_menu_view_event"

local UITypes = require "enums.ui_types"


local Map = class("Map")

function Map:initialize(data)
    self.logic = data.logic
    self.timer = data.timer
    self.event_manager = data.event_manager

    self.cur_map = nil

    self.cast = nil
end

function Map:set(map)
    self.cur_map = map
    local size_x, size_y = self.cur_map:get_size()

    self.cast = Shadowcast(
        size_x,
        size_y,
        function (x, y)
            return not self.cur_map:get_cell(x, y):get_terrain():is_transparent()
        end,
        function (x, y)
            if self.cur_map:get_cell(x, y):is_obscured() then
                self.cur_map:get_cell(x, y):make_visible()
            end

            if self.cur_map:get_cell(x, y):is_in_shadow() then
                self.cur_map:get_cell(x, y):illuminate()
            end
        end
    )
end

function Map:get()
    return self.cur_map
end

function Map:handle_events(event)
    if event.class.name == SolveFovEvent.name then
        for _, _, cell in self.cur_map:iterate() do
            cell:shade()
        end

        local pos_x, pos_y = self.logic:get_hero():get_position()
        local view_distance = self.logic:get_hero():get_properties():get_view_distance()

        self.cast:solve(pos_x, pos_y, view_distance)
    elseif event.class.name == AddEffectEvent.name then
        local x, y = event:get_position()
        local effect = event:get_effect()

        self.cur_map:get_cell(x, y):set_effect(effect)

        self.timer:after(
            0.2,
            function()
                self.cur_map:get_cell(x, y):set_effect(nil)
                self.event_manager:post_event(UpdateViewEvent(nil, UITypes.gameplay))
            end
        )
    end
end

return Map
