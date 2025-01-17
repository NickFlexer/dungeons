local class = require "middleclass"


local LogMessageEvent = class("LogMessageEvent")

function LogMessageEvent:initialize(msg)
    self.msg = msg
end

function LogMessageEvent:get_message()
    return self.msg
end

return LogMessageEvent
