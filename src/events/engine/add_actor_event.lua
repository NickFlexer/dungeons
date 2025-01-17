local class = require "middleclass"


local AddActorEvent = class("AddActorEvent")

function AddActorEvent:initialize(actor)
    self.actor = actor
end

function AddActorEvent:get_actor()
    return self.actor
end

return AddActorEvent
