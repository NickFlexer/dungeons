local class = require "middleclass"


local UpdateViewEvent = class("UpdateViewEvent")

function UpdateViewEvent:initialize(items, ui_type)
    self.items = items
    self.ui_type = ui_type
end

function UpdateViewEvent:get_items()
    return self.items
end

function UpdateViewEvent:get_type()
    return self.ui_type
end

return UpdateViewEvent
