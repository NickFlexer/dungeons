local class = require "middleclass"

local TileRender = require "view.render.tile_render"

local ConverterHelper = require "helpers.converter_helper"

local UISettings = require "settings.ui_setting"

local Tile = require "entity.components.tile"

local Tiles = require "enums.tiles"


local MapRender = class("MapRender")

function MapRender:initialize()
    self.tile_render = TileRender()
    self.converter = ConverterHelper()
end

function MapRender:render(canvas, map_data, logic)
    local map = map_data:get()
    local hero_x, hero_y = logic:get_hero():get_position()

    local x_range = 16
    local y_range = 10

    local size_x, size_y = map:get_size()

    canvas:renderTo(
        function ()
            love.graphics.clear()

            local xstart, xfinish = hero_x - x_range, hero_x + x_range
            local ystart, yfinish = hero_y - y_range, hero_y + y_range

            if xstart < 1 then
                xstart = 1
                xfinish = x_range * 2 + 1
            end

            if xfinish > size_x then
                xfinish = size_x
                xstart = size_x - (x_range * 2)
            end

            if ystart < 1 then
                ystart = 1
                yfinish = y_range * 2 + 1
            end

            if yfinish > size_y then
                yfinish = size_y
                ystart = size_y - (y_range * 2)
            end

            local dx, dy = 1, 1

            for x = xstart, xfinish do
                dy = 1

                for y = ystart, yfinish do
                    local cell = map:get_cell(x, y)

                    local pos_x, pos_y = self.converter:grid_to_pos(dx, dy)
                    local px, py = pos_x + UISettings.shift, pos_y + UISettings.shift

                    if not cell:is_obscured() then
                        self.tile_render:draw(
                            cell:get_terrain():get_tile(),
                            px,
                            py
                        )

                        local decorations = cell:get_terrain():get_decorations()

                        for _, tile in ipairs(decorations) do
                            self.tile_render:draw(
                                tile,
                                px,
                                py
                            )
                        end

                        if not cell:is_in_shadow() then
                            if cell:get_item() then
                                self.tile_render:draw(
                                    cell:get_item():get(Tile.name):get_main(),
                                    px,
                                    py
                                )
                            end

                            if cell:get_entity() then
                                self.tile_render:draw(
                                    cell:get_entity():get(Tile.name):get_main(),
                                    px,
                                    py
                                )
                            end

                            if cell:get_effect() then
                                self.tile_render:draw(
                                    cell:get_effect(),
                                    px,
                                    py
                                )
                            end
                        else
                            self.tile_render:draw(
                                Tiles.shadow,
                                px,
                                py
                            )
                        end
                    end

                    dy = dy + 1
                end

                dx = dx + 1
            end
        end
    )
end

function MapRender:clear(canvas)
    canvas:renderTo(
        function ()
            love.graphics.clear()
        end
    )
end

return MapRender
