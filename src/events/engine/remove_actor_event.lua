local class = require "middleclass"


local RemoveActorEvent = class("RemoveActorEvent")

function RemoveActorEvent:initialize(actor)
    self.actor = actor
end

function RemoveActorEvent:get_actor()
    return self.actor
end

return RemoveActorEvent
