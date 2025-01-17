local class = require "middleclass"
local Input = require "Input"

local InputActionEvent = require "events.common.input_action_event"

local InputActions = require "enums.input_actions"


local InputController = class("InputController")

function InputController:initialize(data)
    self.event_manager = data.event_manager

    self.input = Input()
    self.interval = 0.4
    self.keys = {}

    self:_bind()
end

function InputController:handle_input()
    for _, value in ipairs(self.keys) do
        if self.input:down(value.action, self.interval) then
            self.event_manager:post_event(InputActionEvent(value.action))
        end
    end
end

function InputController:_bind()
    table.insert(self.keys, {key = "w", action = InputActions.up})
    table.insert(self.keys, {key = "s", action = InputActions.down})
    table.insert(self.keys, {key = "a", action = InputActions.left})
    table.insert(self.keys, {key = "d", action = InputActions.right})

    table.insert(self.keys, {key = "z", action = InputActions.wait})

    table.insert(self.keys, {key = "return", action = InputActions.enter})

    for _, value in ipairs(self.keys) do
        self.input:bind(value.key, value.action)
    end
end

return InputController
