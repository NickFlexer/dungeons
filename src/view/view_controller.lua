local class = require "middleclass"
local SUIT = require "suit"

local MenuRender = require "view.render.menu_render"
local ListRender = require "view.render.list_render"
local MessageRender = require "view.render.message_render"
local GameplayRender = require "view.render.gameplay_render"
local MapRender = require "view.render.map_render"

local UpdateMenuViewEvent = require "events.view.update_menu_view_event"

local UITypes = require "enums.ui_types"


local ViewController = class("ViewController")

function ViewController:initialize(data)
    self.event_manager = data.event_manager
    self.map = data.map
    self.logic = data.logic

    self.ui = SUIT.new()

    self.canvas = love.graphics.newCanvas()
    self.map_canvas = love.graphics.newCanvas()

    self.menu_render = MenuRender({ui = self.ui})
    self.list_render = ListRender({ui = self.ui})
    self.message_render = MessageRender({ui = self.ui})
    self.gameplay_render = GameplayRender({ui = self.ui})
    self.map_render = MapRender()
end

function ViewController:update(dt)
    
end

function ViewController:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.map_canvas, 0, 0, 0, 1.5)
    love.graphics.draw(self.canvas, 0, 0)
end

function ViewController:handle_events(event)
    if event.class.name == UpdateMenuViewEvent.name then
        local ui_type = event:get_type()

        if ui_type == UITypes.menu then
            self.menu_render:render(self.canvas, event:get_items())
            self.map_render:clear(self.map_canvas)
        elseif ui_type == UITypes.list then
            self.list_render:render(self.canvas, event:get_items())
        elseif ui_type == UITypes.message then
            self.message_render:render(self.canvas, event:get_items())
            self.map_render:clear(self.map_canvas)
        elseif ui_type == UITypes.gameplay then
            self.gameplay_render:render(self.canvas, self.logic)
            self.map_render:render(self.map_canvas, self.map, self.logic)
        end
    end
end

return ViewController
