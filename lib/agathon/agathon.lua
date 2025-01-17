local _PACKAGE = (...):match("^(.+)[%./][^%./]+") or ""
local Result = require(_PACKAGE .. "/result")


local Agathon = {
    root = {}
}

local AgathonMt = {
    __index = Agathon
}

function Agathon.new(data)
    return setmetatable(
        {
            root = data.root
        },
        AgathonMt
    )
end

function Agathon:set_object(object)
    self.object = object
end

function Agathon:run(...)
    local result = Result()
    self.root:perform(result, self.object, ...)

    if result:get() == Result.values.error then
        print("Agathon run() end with error!")
    end
end

return setmetatable(Agathon, {__call = function (_, ...)
    return Agathon.new(...)
end})
