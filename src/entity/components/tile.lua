local class = require "middleclass"


local Tile = class("Tile")

function Tile:initialize(data)
    self.main = data.main
    self.corpse = data.corpse
end

function Tile:get_main()
    return self.main
end

function Tile:set_main(tile)
    self.main = tile
end

function Tile:get_corpse()
    return self.corpse
end

return Tile
