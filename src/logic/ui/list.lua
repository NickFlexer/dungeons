local class = require "middleclass"


local List = class("List")

function List:initialize(data)
    self.items = {}
end

-- items:
-- text
-- description
-- action
function List:set_items(items)
    for index, item in ipairs(items) do
        local selected = false

        if index == 1 then
            selected = true
        end

        table.insert(
            self.items,
            {
                text = item.text,
                selected = selected,
                action = item.action,
                description = item.description
            }
        )
    end
end

function List:remove_items()
    self.items = {}
end

function List:move_up()
    for index, item in ipairs(self.items) do
        if item.selected and index ~= 1 then
            item.selected = false
            self.items[index - 1].selected = true

            break
        end
    end
end

function List:move_down()
    for index, item in ipairs(self.items) do
        if item.selected and index ~= #self.items then
            item.selected = false
            self.items[index + 1].selected = true

            break
        end
    end
end

function List:execute_action()
    for _, item in ipairs(self.items) do
        if item.selected then
            item.action()

            break
        end
    end
end

function List:get_state()
    local result = {}

    for _, item in ipairs(self.items) do
        local forward = "    "

        if item.selected then
            forward = "--> "
            result.description = item.description
        end

        table.insert(result, forward .. item.text)
    end

    return result
end

return List
