local class = require "middleclass"

local UISettings = require "settings.ui_setting"


local MessageRender = class("MessageRender")

function MessageRender:initialize(data)
    self.ui = data.ui
end

function MessageRender:render(canvas, item)
    canvas:renderTo(
        function ()
            love.graphics.clear()

            love.graphics.rectangle(
                "line",
                UISettings.shift,
                UISettings.shift,
                love.graphics.getWidth() - UISettings.shift * 2,
                love.graphics.getHeight() - UISettings.shift * 2,
                UISettings.shift
            )

            local x = UISettings.center_x - UISettings.button_width / 2
            local y = UISettings.center_y - UISettings.button_height / 2

            self.ui.layout:reset(x, y)
            self.ui:Label("", self.ui.layout:row(UISettings.button_width, UISettings.button_height))

            self.ui:Label(item, {font = UISettings.font}, self.ui.layout:row())

            self.ui:draw()
        end
    )
end

return MessageRender
