local class = require "middleclass"


local Use = class("Use")

function Use:initialize(data)
    self.action_function = data.action
end

function Use:on_use(data)
    return self.action_function(data)
end

return Use
