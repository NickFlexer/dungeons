local class = require "middleclass"

local UISettings = require "settings.ui_setting"


local ConverterHelper = class("ConverterHelper")

function ConverterHelper:initialize()
    
end

function ConverterHelper:grid_to_pos(x, y)
    return
        (x - 1) * UISettings.tile_size,
        (y - 1) * UISettings.tile_size
end

function ConverterHelper:pos_to_grid(x, y)
    return
        x / UISettings.tile_size + 1,
        y / UISettings.tile_size + 1
end

return ConverterHelper
