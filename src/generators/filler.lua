local class = require "middleclass"


local Filler = class("Filler")

function Filler:initialize()
    
end

function Filler:fill_rooms(rooms, map)
    local required_data = {
        {">", "@"},
        {"RND", "<"},
        {"RND", "RND", "RND"},
        {"RND", "RND", "RND"},
        {"RND", "RND", "RND", "RND"},
        {"RND", "RND", "RND", "RND", "RND"},
        {"RND", "RND", "RND", "RND"},
        {"RND", "RND", "RND", "RND"},
        {"RND", "RND", "RND", "RND"},
    }

    for _, room in ipairs(rooms) do
        local w, h = room:get_size()

        if w > 3 and h > 3 then
            if #required_data > 0 then
                local data = table.remove(required_data, 1)

                local area = room:get_indoor()

                for _, value in ipairs(data) do
                    if value == "RND" then
                        value = self:_rnd_item()
                    end

                    local rnd_pos = area[math.random(1, #area)]
                    map:set_cell(rnd_pos.x, rnd_pos.y, value)
                end
            end
        end
    end
end

function Filler:_rnd_item()
    local rnd = {
        ".",
        ".",
        "X",
        "S"
    }

    return rnd[math.random(1, #rnd)]
end

return Filler
