local class = require "middleclass"


local GameLog = class("GameLog")

function GameLog:initialize()
    self.log = {}
end

function GameLog:add(msg)
    table.insert(self.log, msg)
end

function GameLog:get()
    local result = {}

    for i = #self.log, #self.log - 6, -1 do
        table.insert(result, self.log[i])
    end

    return result
end

function GameLog:clear()
    self.log = {}
end

return GameLog
