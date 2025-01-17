package.path = package.path .. ";lib/?/init.lua;lib/?.lua;src/?.lua"


local Game = require "game.game"


local game


function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest", 3)
    math.randomseed(os.time())

    game = Game()
    game:start()
end


function love.update(dt)
    game:update(dt)
end


function love.draw()
    game:draw()
end
