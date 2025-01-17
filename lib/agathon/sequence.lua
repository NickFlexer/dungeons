local _PACKAGE = (...):match("^(.+)[%./][^%./]+") or ""
local Result = require(_PACKAGE .. "/result")


local Sequence = {}

local SequenceMt = {
    __index = Sequence
}

function Sequence.new(data)
    return setmetatable(
        {
            nodes = data.nodes
        },
        SequenceMt
    )
end

function Sequence:perform(result, object, ...)
    for _, node in ipairs(self.nodes) do
        local new_result = Result()
        node:perform(new_result, object, ...)

        if new_result:get() == Result.values.fail then
            result:fail()

            return
        end
    end

    result:success()
end

function Sequence.__tostring(self)
    return "Sequence"
end

return setmetatable(Sequence, {__call = function (_, ...)
    return Sequence.new(...)
end})
