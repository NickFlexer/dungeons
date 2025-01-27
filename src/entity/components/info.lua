local class = require "middleclass"


local Info = class("Info")

function Info:initialize(data)
    self.visible_name = data.name
    self.description = data.description
    self.on_map = data.on_map
end

function Info:get_name()
    return self.visible_name
end

function Info:get_description()
    return self.description
end

function Info:get_msg_on_map()
    return self.on_map
end

return Info
