local class = require "middleclass"

local UISettings = require "settings.ui_setting"

local Colors = require "enums.colors"


local GameplayRender = class("GameplayRender")

function GameplayRender:initialize(data)
    self.ui = data.ui
end

function GameplayRender:render(canvas, logic)
    canvas:renderTo(
        function ()
            love.graphics.clear()

            local map_w = UISettings.tile_size * 33 * 1.5 + UISettings.shift
            local map_h = UISettings.tile_size * 21 * 1.5 + UISettings.shift

            -- map
            love.graphics.rectangle(
                "line",
                UISettings.shift,
                UISettings.shift,
                map_w,
                map_h,
                UISettings.shift
            )

            -- log
            love.graphics.rectangle(
                "line",
                UISettings.shift,
                map_h + UISettings.shift * 2,
                map_w,
                love.graphics.getHeight() - (map_h + UISettings.shift * 3),
                UISettings.shift
            )

            self:_game_log(map_w, map_h, logic)

            -- map data
            love.graphics.rectangle(
                "line",
                map_w + UISettings.shift * 2,
                UISettings.shift,
                love.graphics.getWidth() - (map_w + UISettings.shift * 3),
                UISettings.tile_size * 5,
                UISettings.shift
            )

            -- hero data
            love.graphics.rectangle(
                "line",
                map_w + UISettings.shift * 2,
                UISettings.tile_size * 5 + UISettings.shift * 2,
                love.graphics.getWidth() - (map_w + UISettings.shift * 3),
                love.graphics.getHeight() - (UISettings.tile_size * 6 + UISettings.shift),
                UISettings.shift
            )

            self:_hero_data(map_w + UISettings.shift * 2, UISettings.tile_size * 5 + UISettings.shift * 2, logic)

            self.ui:draw()
        end
    )
end

function GameplayRender:_game_log(w, h, logic)
    local x = UISettings.shift * 2
    local y = h + UISettings.shift

    self.ui.layout:reset(x, y)
    self.ui:Label("", self.ui.layout:row(w, UISettings.tile_size))

    local options = {font = UISettings.font, align = "left"}
    local messages = logic:get_log()

    for index, msg in ipairs(messages) do
        self.ui:Label(msg, options, self.ui.layout:row())

        if index > 5 then
            return
        end
    end
end

function GameplayRender:_hero_data(w, h, logic)
    local x = w + UISettings.shift
    local y = h

    self.ui.layout:reset(x, y)
    self.ui:Label("", self.ui.layout:row(w, UISettings.tile_size))

    local hero_data = logic:get_hero():get_properties()
    local options = {font = UISettings.font, align = "left"}
    local cur_hp, max_hp = hero_data:get_hp()
    local min_dmg, max_dmg = hero_data:get_damage()

    self.ui:Label({Colors.green, hero_data:get_name()}, options, self.ui.layout:row())
    self.ui:Label(
        {Colors.red, "HP: " .. tostring(cur_hp) .. "/" .. tostring(max_hp)},
        options,
        self.ui.layout:row()
    )
    self.ui:Label(
        {Colors.orange, "Урон: " .. tostring(min_dmg) .. "-" .. tostring(max_dmg)},
        options,
        self.ui.layout:row()
    )
end

return GameplayRender
