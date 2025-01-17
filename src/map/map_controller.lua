local class = require "middleclass"
local Grid = require "grid"

local Cell = require "map.cell"

local TerrainsFactory = require "logic.factories.terrains_factory"
local MonstersFactory = require "logic.factories.monsters_factory"
local EnvironmentFactory = require "logic.factories.environment_factory"

local AddActorEvent = require "events.engine.add_actor_event"

local Terrains = require "enums.terrains"
local Tiles = require "enums.tiles"


local MapController = class("MapController")

function MapController:initialize(data)
    self.logic = data.logic
    self.event_manager = data.event_manager

    self.terrains_factory = TerrainsFactory()
    self.monsters_factory = MonstersFactory()
    self.environment_factory = EnvironmentFactory()
end

function MapController:read_map(map_str)
    local map_size_x = #string.match(map_str, "[^\n]+")
    local _, map_size_y = string.gsub(map_str, "\n", "")

    local map = Grid(map_size_x, map_size_y)

    local x, y = 1, 1

    for row in map_str:gmatch("[^\n]+") do
        x = 1

        for tile in row:gmatch(".") do
            local cell = self:_get_cell(tile, x, y)

            map:set_cell(x, y, cell)

            x = x + 1
        end

        y = y + 1
    end

    self:_beautify(map)

    return map
end

function MapController:_get_cell(tile, x, y)
    local terrain
    local entity

    if tile == "." then
        terrain = self.terrains_factory:get_floor()
    elseif tile == "#" then
        terrain = self.terrains_factory:get_wall()
    elseif tile == "+" then
        terrain = self.terrains_factory:get_door()
    elseif tile == ">" or tile == "<" then
        terrain = self.terrains_factory:get_stairway(tile)
    elseif tile == "@" then
        terrain = self.terrains_factory:get_floor()
        self.logic:get_hero():set_position(x, y)
        entity = self.logic:get_hero()

        self.event_manager:post_event(AddActorEvent(entity))
    elseif tile == "S" then
        terrain = self.terrains_factory:get_floor()

        local monster = self.monsters_factory:get_skeleton()
        monster:set_position(x, y)
        entity = monster

        self.event_manager:post_event(AddActorEvent(entity))
    elseif tile == "X" then
        terrain = self.terrains_factory:get_floor()

        local barrel = self.environment_factory:get_barrel()
        barrel:set_position(x, y)
        entity = barrel
    end

    local new_cell = Cell({
        terrain = terrain,
        entity = entity
    })

    return new_cell
end

function MapController:_beautify(map)
    local floor_variants = 8

    for x, y, cell in map:iterate() do
        if cell:get_terrain():get_type() == Terrains.floor then
            cell:get_terrain():set_tile("FLOOR_" .. tostring(math.random(1, floor_variants)))

            if map:get_cell(x, y -1):get_terrain():get_type() == Terrains.wall then
                cell:get_terrain():add_decoration(Tiles.wall_shadow_n)
            end

            if map:get_cell(x - 1, y):get_terrain():get_type() == Terrains.wall then
                cell:get_terrain():add_decoration(Tiles.wall_shadow_w)
            end
        end

        if cell:get_terrain():get_type() == Terrains.wall then
            local wall_num = 0

            for dx, dy, dcell in map:iterate_neighbor(x, y) do
                if dcell:get_terrain():get_type() == Terrains.wall or dcell:get_terrain():get_type() == Terrains.door then
                    if dx == -1 and dy == 0 then
                        wall_num = wall_num + 4
                    end

                    if dx == 1 and dy == 0 then
                        wall_num = wall_num + 8
                    end

                    if dy == -1 and dx == 0 then
                        wall_num = wall_num + 1
                    end

                    if dy == 1 and dx == 0 then
                        wall_num = wall_num + 2
                    end

                    cell:get_terrain():set_tile("WALL_" .. tostring(wall_num))
                end
            end
        end
    end
end

return MapController
