local class = require "middleclass"


local AddEffectEvent = class("AddEffectEvent")

function AddEffectEvent:initialize(x, y, effect)
    self.x = x
    self.y = y
    self.effect = effect
end

function AddEffectEvent:get_position()
    return self.x, self.y
end

function AddEffectEvent:get_effect()
    return self.effect
end

return AddEffectEvent
