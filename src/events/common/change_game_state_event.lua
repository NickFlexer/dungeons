local class = require "middleclass"


local ChangeGameStateEvent = class("ChangeGameStateEvent")

function ChangeGameStateEvent:initialize(state_name)
    self.state_name = state_name
end

function ChangeGameStateEvent:get_name()
    return self.state_name
end

return ChangeGameStateEvent
