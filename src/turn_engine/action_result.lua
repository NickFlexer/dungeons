local class = require "middleclass"


local ActionResult = class("ActionResult")

function ActionResult:initialize(data)
    self.success = data.success
    self.alternative = data.alternative
end

function ActionResult:is_success()
    return self.success
end

function ActionResult:has_alternative()
    return not not self.alternative
end

function ActionResult:get_alternative()
    return self.alternative
end

function ActionResult:set_alternative(alternative)
    self.alternative = alternative
end

return ActionResult
