local _PACKAGE = string.gsub(...,"%.","/") or ""

local result = {
    Tree = require(_PACKAGE.."/agathon"),
    Task = require(_PACKAGE.."/task"),
    Sequence = require(_PACKAGE.."/sequence"),
    Priority = require(_PACKAGE.."/priority"),
    Result = require(_PACKAGE.."/result")
}

return result
