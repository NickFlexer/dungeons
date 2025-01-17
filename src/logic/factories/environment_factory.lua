local class = require "middleclass"

local Barrel = require "map.environment.barrel"


local EnvironmentFactory = class("EnvironmentFactory")

function EnvironmentFactory:initialize()
    
end

function EnvironmentFactory:get_barrel()
    local barrel = Barrel()

    return barrel
end

return EnvironmentFactory
