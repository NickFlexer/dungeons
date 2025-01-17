local class = require "middleclass"


local View = class("View")

function View:initialize()
    
end

function View:get_str(map)
    local str = ""

    local size_x, size_y = map:get_size()

    for x, _, cell in map:iterate() do
        str = str .. cell

        if x == size_x then
            str = str .. "\n"
        end
    end

    return str
end

return View
