local class = require "middleclass"


local BaseTerrain = class("BaseTerrain")

function BaseTerrain:initialize(data)
    self.tile = data.tile
    self.terrain_type = data.terrain_type
    self.walkable = data.walkable
    self.transparent = data.transparent
    self.msg = data.msg
    self.action = data.action

    self.decorations = {}
end

function BaseTerrain:get_tile()
    return self.tile
end

function BaseTerrain:set_tile(tile)
    self.tile = tile
end

function BaseTerrain:is_walkable()
    return self.walkable
end

function BaseTerrain:get_type()
    return self.terrain_type
end

function BaseTerrain:get_decorations()
    return self.decorations
end

function BaseTerrain:add_decoration(decoration)
    table.insert(self.decorations, decoration)
end

function BaseTerrain:is_transparent()
    return self.transparent
end

function BaseTerrain:set_transparent(transparent)
    self.transparent = transparent
end

function BaseTerrain:get_message()
    return self.msg
end

function BaseTerrain:get_action()
    return self.action
end

return BaseTerrain
