local class = require "middleclass"


local Message = class("Message")

function Message:initialize()
    self.msg = ""
end

function Message:set_msg(msg)
    self.msg = msg
end

function Message:get_msg()
    return self.msg
end

return Message
