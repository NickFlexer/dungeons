local class = require "middleclass"

local GameLog = require "logic.game_log"

local LogMessageEvent = require "events.common.log_message_event"
local ClearLogEvent = require "events.common.clear_log_event"


local GameLogic = class("GameLogic")

function GameLogic:initialize(data)
    self.hero = nil

    self.log = GameLog()
end

function GameLogic:get_hero()
    return self.hero
end

function GameLogic:set_hero(hero)
    self.hero = hero
end

function GameLogic:get_log()
    return self.log:get()
end

function GameLogic:handle_events(event)
    if event.class.name == LogMessageEvent.name then
        self.log:add(event:get_message())
    elseif event.class.name == ClearLogEvent.name then
        self.log:clear()
    end
end

return GameLogic
