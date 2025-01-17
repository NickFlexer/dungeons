local class = require "middleclass"


local Tree = class("Tree")

function Tree:initialize(root)
    self.root = root
end

function Tree:iterate()
    local start_idx, end_idx = 0, 0
    local traverse
    local nodes = {}
    local dept = {}
    local depth = 0

    function traverse(node)
        if not node then
            return
        end

        depth = depth + 1
        end_idx = end_idx + 1

        table.insert(nodes, node)
        dept[end_idx] = depth

        if node:get_left() then
            traverse(node:get_left())
        end

        if node:get_right() then
            traverse(node:get_right())
        end

        depth = depth - 1
    end

    traverse(self.root)

    return function ()
        if start_idx >= end_idx then
            return
        end

        start_idx = start_idx + 1

        return dept[start_idx], nodes[start_idx]
    end
end

function Tree:get_root()
    return self.root
end

function Tree:get_leafs()
    local leafs = {}

    for _, node in self:iterate() do
        if not node:get_left() and not node:get_right() then
            table.insert(leafs, node)
        end
    end

    return leafs
end

function Tree:get_iterations()
    local result = {}

    for dept, node in self:iterate() do
        if not result[dept] then
            result[dept] = {}
        end

        table.insert(result[dept], node)
    end

    return result
end

return Tree
