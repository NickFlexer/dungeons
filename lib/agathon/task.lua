local _PACKAGE = (...):match("^(.+)[%./][^%./]+") or ""
local Result = require(_PACKAGE .. "/result")


local Task = {}

local TaskMt = {
    __index = Task
}

function Task.new(data)
    return setmetatable(
        {
            run = data.run
        },
        TaskMt
    )
end

function Task:perform(result, object, ...)
    local new_result = Result()
    self.run(new_result, object, ...)

    if new_result:get() == Result.values.error then
        result:error()

        return
    end

    result:set(new_result:get())
end

function Task.__tostring(self)
    return "Task"
end

return setmetatable(Task, {__call = function (_, ...)
    return Task.new(...)
end})
