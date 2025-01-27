local class = require "middleclass"


local Entity = class("Entity")

Entity.static.id = 0

function Entity:initialize()
    Entity.static.id = Entity.static.id + 1
    self.id = Entity.static.id

    self.components = {}
end

function Entity:add(component)
    self.components[component.class.name] = component
end

function Entity:remove(component_name)
    self.components[component_name] = nil
end

function Entity:get(component_name)
    if self.components[component_name] then
        return self.components[component_name]
    else
        error("Entitty [" .. tostring(self.id) .. " ] has not component " .. component_name)
    end
end

function Entity:has(component_name)
    return not not self.components[component_name]
end

return Entity
