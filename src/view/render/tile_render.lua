local class = require "middleclass"
local TileCutter = require "tile_cutter"

local UISettings = require "settings.ui_setting"

local Tiles = require "enums.tiles"


local TileRender = class("TileRender")

function TileRender:initialize()
    self.tile_cutter = TileCutter(UISettings.tileset_path, UISettings.tile_size)

    self.tile_cutter:config_tileset(
        {
            {Tiles.floor_1, 1, 2},
            {Tiles.floor_2, 2, 2},
            {Tiles.floor_3, 3, 2},
            {Tiles.floor_4, 4, 2},
            {Tiles.floor_5, 5, 2},
            {Tiles.floor_6, 6, 2},
            {Tiles.floor_7, 7, 2},
            {Tiles.floor_8, 8, 2},

            {Tiles.wall_0, 15, 13},
            {Tiles.wall_1, 15, 13},
            {Tiles.wall_2, 15, 13},
            {Tiles.wall_3, 14, 8},
            {Tiles.wall_4, 15, 13},
            {Tiles.wall_5, 15, 13},
            {Tiles.wall_6, 16, 9},
            {Tiles.wall_7, 16, 9},
            {Tiles.wall_8, 15, 13},
            {Tiles.wall_9, 14, 10},
            {Tiles.wall_10, 14, 7},
            {Tiles.wall_11, 14, 9},
            {Tiles.wall_12, 15, 7},
            {Tiles.wall_13, 15, 9},
            {Tiles.wall_14, 15, 10},
            {Tiles.wall_15, 15, 11},

            {Tiles.closed_door, 1, 4},
            {Tiles.open_door, 2, 4},

            {Tiles.upstairs, 1, 5},
            {Tiles.downstairs, 2, 5},

            {Tiles.hero_warrior, 1, 13},

            {Tiles.skeleton_warrior, 1, 14},

            {Tiles.skeleton_corpse, 1, 16},
            {Tiles.hero_warrior_corpse, 2, 16},

            {Tiles.barrel, 1, 9},
            {Tiles.destroyed_barrel, 1, 10},

            {Tiles.wall_shadow_n, 1, 1},
            {Tiles.wall_shadow_w, 2, 1},

            {Tiles.shadow, 3, 1},

            {Tiles.no_pass, 16, 1},
            {Tiles.fight, 15, 1}
        }
    )
end

function TileRender:draw(tile_name, x, y)
    self.tile_cutter:draw(tile_name, x, y)
end

return TileRender
