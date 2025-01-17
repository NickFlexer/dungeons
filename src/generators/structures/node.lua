local class = require "middleclass"


local Node = class("Node")

function Node:initialize(data)
    self.left = nil
    self.right = nil
    self.parent = nil

    self.data = data
end

function Node:set_parent(node)
    self.parent = node
end

function Node:get_parent()
    return self.parent
end

function Node:set_left(node)
    if not node.class.name == "Node" then
        error("Invalid node type!")
    end

    node:set_parent(self)
    self.left = node
end

function Node:get_left()
    return self.left
end

function Node:set_right(node)
    if not node.class.name == "Node" then
        error("Invalid node type!")
    end

    node:set_parent(self)
    self.right = node
end

function Node:get_right()
    return self.right
end

function Node:get_data()
    return self.data
end

function Node:get_brother()
    if not self.parent then
        return
    end

    local left = self.parent:get_left()
    local right = self.parent:get_right()

    if left and left ~= self then
        return left
    end

    if right and right ~= self then
        return right
    end
end

return Node
