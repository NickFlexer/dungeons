local class = require "middleclass"


local BaseAction = class("BaseAction")

function BaseAction:initialize(cost)
    self.cost = cost
end

function BaseAction:get_cost()
    return self.cost
end

return BaseAction