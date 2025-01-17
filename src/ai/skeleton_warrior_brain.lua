local class = require "middleclass"
local Agathon = require "agathon"
local Bresenham = require "Bresenham"
local luastar = require "lua-star"

local WaitAction = require "turn_engine.actions.wait_action"
local FightAction = require "turn_engine.actions.fight_action"
local MoveAction = require "turn_engine.actions.move_action"

local Directions = require "enums.directions"


local SkeletonWarriorBrain = class("SkeletonWarriorBrain")

function SkeletonWarriorBrain:initialize()
    self.path = nil
    self.last_hero_pos = nil

    self.brain = Agathon.Tree({
        root = Agathon.Priority({
            nodes = {
                Agathon.Sequence({
                    name = "Атаковать персонаж игрока",
                    nodes = {
                        Agathon.Task({
                            name = "Игрок рядом?",
                            run = function (result, unit, data)
                                if self:_is_hero_near(unit, data.logic:get_hero()) then
                                    result:success()
                                else
                                    result:fail()
                                end
                            end
                        }),
                        Agathon.Task({
                            name = "Атаковать",
                            run = function (result, unit, data)
                                unit:get_actor():set_action(FightAction(data.logic:get_hero()))
                                result:success()
                            end
                        })
                    }
                }),
                Agathon.Sequence({
                    name = "Приближаться к игроку",
                    nodes = {
                        Agathon.Task({
                            name = "Видит игрока?",
                            run = function (result, unit, data)
                                if self:_check_hero_visible(unit, data.logic:get_hero(), data.map:get() ) then
                                    local hero_x, hero_y = data.logic:get_hero():get_position()
                                    self.last_hero_pos = {x = hero_x, y = hero_y}

                                    result:success()
                                else
                                    result:fail()
                                end
                            end
                        }),
                        Agathon.Task({
                            name = "Построение маршрута",
                            run = function (result, unit, data)
                                local hero_x, hero_y = data.logic:get_hero():get_position()
                                local path = self:_find_path(unit, data.map:get(), {x = hero_x, y = hero_y})

                                if path then
                                    self.path = path
                                    result:success()
                                else
                                    result:fail()
                                end
                            end
                        }),
                        Agathon.Task({
                            name = "Двигаться к игроку",
                            run = function (result, unit, data)
                                if #self.path > 0 then
                                    local position = table.remove(self.path, 1)

                                    local direction = self:_get_direction(unit, position)

                                    if direction then
                                        unit:get_actor():set_action(MoveAction(direction))
                                        result:success()
                                    else
                                        result:fail()
                                    end
                                else
                                    result:fail()
                                end
                            end
                        })
                    }
                }),
                Agathon.Sequence({
                    name = "Искать игрока в последней видимой точке",
                    nodes = {
                        Agathon.Task({
                            name = "Есть ли в памяти последняя видимая точка?",
                            run = function (result, unit, data)
                                if self.last_hero_pos then
                                    result:success()
                                else
                                    result:fail()
                                end
                            end
                        }),
                        Agathon.Task({
                            name = "Построить маршрут к последней видимой точке",
                            run = function (result, unit, data)
                                local path = self:_find_path(unit, data.map:get(), self.last_hero_pos)

                                if path then
                                    self.path = path
                                    result:success()
                                else
                                    self.last_hero_pos = nil
                                    result:fail()
                                end
                            end
                        }),
                        Agathon.Task({
                            name = "Идти по маршруту",
                            run = function (result, unit, data)
                                if #self.path > 0 then
                                    local position = table.remove(self.path, 1)

                                    local direction = self:_get_direction(unit, position)

                                    if direction then
                                        unit:get_actor():set_action(MoveAction(direction))
                                        result:success()
                                    else
                                        self.last_hero_pos = nil
                                        result:fail()
                                    end
                                else
                                    self.last_hero_pos = nil
                                    result:fail()
                                end
                            end
                        })
                    }
                }),
                Agathon.Task({
                    name = "Остановиться и ждать",
                    run = function (result, unit, data)
                        unit:get_actor():set_action(WaitAction())

                        result:success()
                    end
                })
            }
        })
    })
end

function SkeletonWarriorBrain:think(unit, world_data)
    self.brain:set_object(unit)
    self.brain:run(world_data)
end

function SkeletonWarriorBrain:_is_hero_near(unit, hero)
    local unit_x, unit_y = unit:get_position()
    local hero_x, hero_y = hero:get_position()

    local distance = math.abs(unit_x - hero_x) + math.abs(unit_y - hero_y)

    return distance == 1
end

function SkeletonWarriorBrain:_check_hero_visible(unit, hero, map)
    local unit_x, unit_y = unit:get_position()
    local max_distance = unit:get_properties():get_view_distance()
    local hero_x, hero_y = hero:get_position()

    local result, counter = Bresenham.line(
        unit_x, unit_y,
        hero_x, hero_y,
        function(x, y)
            return map:get_cell(x, y):get_terrain():is_transparent()
        end
    )

    return result and counter <= max_distance
end

function SkeletonWarriorBrain:_find_path(unit, map, target)
    local unit_x, unit_y = unit:get_position()
    local size_x, size_y = map:get_size()

    local path = luastar:find(
        size_x, size_y,
        {x = unit_x, y = unit_y},
        {x = target.x, y = target.y},
        function (x, y)
            if not map:get_cell(x, y):get_terrain():is_walkable() then
                return false
            end

            local entity = map:get_cell(x, y):get_entity()

            if not entity then
                return true
            end

            if entity == unit then
                return true
            end

            if x == target.x and y == target.y then
                return true
            end

            return false
        end,
        false,
        true
    )

    if path then
        table.remove(path, 1)
        table.remove(path, #path)

        return path
    end
end

function SkeletonWarriorBrain:_get_direction(unit, next_position)
    local unit_x, unit_y = unit:get_position()
    local dx, dy = next_position.x - unit_x, next_position.y - unit_y

    if dx == -1 and dy == 0 then
        return Directions.left
    elseif dx == 1 and dy == 0 then
        return Directions.right
    elseif dx == 0 and dy == -1 then
        return Directions.up
    elseif dx == 0 and dy == 1 then
        return Directions.down
    end
end

return SkeletonWarriorBrain
