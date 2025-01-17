local class = require "middleclass"


local Menu = class("Menu")

function Menu:initialize(data)
    self.menu_items = {}
end

-- items:
-- text 
-- action
function Menu:set_items(items)
    for index, item in ipairs(items) do
        local selected = false

        if index == 1 then
            selected = true
        end

        table.insert(
            self.menu_items,
            {
                text = item.text,
                selected = selected,
                action = item.action
            }
        )
    end
end

function Menu:remove_items()
    self.menu_items = {}
end

function Menu:move_up()
    for index, item in ipairs(self.menu_items) do
        if item.selected and index ~= 1 then
            item.selected = false
            self.menu_items[index - 1].selected = true

            break
        end
    end
end

function Menu:move_down()
    for index, item in ipairs(self.menu_items) do
        if item.selected and index ~= #self.menu_items then
            item.selected = false
            self.menu_items[index + 1].selected = true

            break
        end
    end
end

function Menu:execute_action()
    for _, item in ipairs(self.menu_items) do
        if item.selected then
            item.action()

            break
        end
    end
end

function Menu:get_state()
    local result = {}

    for _, item in ipairs(self.menu_items) do
        local forward = ""
        local backward = ""

        if item.selected then
            forward = "--> "
            backward = " <--"
        end

        table.insert(result, forward .. item.text .. backward)
        -- table.insert(result, item.text)
    end

    return result
end

return Menu
