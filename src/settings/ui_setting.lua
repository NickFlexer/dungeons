local UISettings = {
    font = love.graphics.newFont("res/fonts/keyrusMedium.ttf", 18),
    button_width = 256,
    button_height = 32,

    center_x = love.graphics.getWidth() / 2,
    center_y = love.graphics.getHeight() / 2,

    shift = 8,
    tile_size = 16,

    tileset_path = "res/tileset/roguelike_01.png",
}

return UISettings
