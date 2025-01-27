local class = require "middleclass"

local UISettings = require "settings.ui_setting"


local ListRender = class("ListRender")

function ListRender:initialize(data)
    self.ui = data.ui
end

function ListRender:render(canvas, items)
    canvas:renderTo(
        function ()
            love.graphics.clear()

            love.graphics.rectangle(
                "line",
                UISettings.shift,
                UISettings.shift,
                UISettings.button_width + UISettings.shift * 4,
                love.graphics.getHeight() - UISettings.shift * 2,
                UISettings.shift
            )

            love.graphics.rectangle(
                "line",
                UISettings.button_width + UISettings.shift * 6,
                UISettings.shift,
                love.graphics.getWidth() - UISettings.button_width - UISettings.shift * 7,
                love.graphics.getHeight() - UISettings.shift * 2,
                UISettings.shift
            )

            local x = UISettings.shift * 2
            local y = UISettings.shift * 2

            self.ui.layout:reset(x, y)
            self.ui:Label("", self.ui.layout:row(UISettings.button_width * 2, UISettings.button_height))

            for index, item in ipairs(items) do
                if item then
                    self.ui:Label(item, {font = UISettings.font, align = "left"}, self.ui.layout:row())
                end
            end

            x, y = UISettings.button_width + UISettings.shift * 8, UISettings.shift * 2 + UISettings.button_height
            self.ui.layout:reset(x, y)
            if items.description then
                self.ui:Label(
                    items.description,
                    {font = UISettings.font, align = "left"},
                    self.ui.layout:row(UISettings.button_width * 2.5, UISettings.button_height)
                )
            end

            self.ui:draw()
        end
    )
end

return ListRender
