local Result = {
    values = {
        success = "SUCCESS",
        fail = "FAIL",
        error = "ERROR"
    }
}

local ResultMt = {
    __index = Result
}

function Result.new()
    return setmetatable(
        {
            res = Result.values.error
        },
        ResultMt
    )
end

function Result:success()
    self.res = Result.values.success
end

function Result:fail()
    self.res = Result.values.fail
end

function Result:error()
    self.res = Result.values.error
end

function Result:get()
    return self.res
end

function Result:set(res)
    self.res = res
end

return setmetatable(Result, {__call = function (_, ...)
    return Result.new()
end})
