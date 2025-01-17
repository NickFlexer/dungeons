local _PACKAGE = (...):match("^(.+)[%./][^%./]+") or ""
local Result = require(_PACKAGE .. "/result")


local Priority = {}

local PriorityMt = {
    __index = Priority
}

function Priority.new(data)
    return setmetatable(
        {
            nodes = data.nodes
        },
        PriorityMt
    )
end

function Priority:perform(result, object, ...)
    for _, node in ipairs(self.nodes) do
        local new_result = Result()
        node:perform(new_result, object, ...)

        if new_result:get() == Result.values.success then
            result:success()

            return
        end
    end

    result:fail()
end

function Priority.__tostring(self)
    return "Priority"
end

return setmetatable(Priority, {__call = function (_, ...)
    return Priority.new(...)
end})
