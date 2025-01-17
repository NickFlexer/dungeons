local class = require "middleclass"


local InputActionEvent = class("InputActionEvent")

function InputActionEvent:initialize(action)
    self.action = action
end

function InputActionEvent:get_action()
    return self.action
end

return InputActionEvent
