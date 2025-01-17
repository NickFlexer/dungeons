local class = require "middleclass"

local BaseTerrain = require "map.terrain.base_terrain"

local LogMessageEvent = require "events.common.log_message_event"
local ChangeGameStateEvent = require "events.common.change_game_state_event"

local Terrains = require "enums.terrains"
local Tiles = require "enums.tiles"
local StairwayDirections = require "enums.stairway_directions"
local Colors = require "enums.colors"
local GameStates = require "enums.game_states"


local Stairway = class("Stairway", BaseTerrain)

function Stairway:initialize(direction)
    local tile
    local msg
    local action

    if direction == StairwayDirections.upstairs then
        tile = Tiles.upstairs
        msg = {
            "Лестница куда-то наверх. ",
            "Чтобы пройти нажми ",
            Colors.orange,
            "[Enter]"
        }
        action = function (data)
            data.event_manager:post_event(LogMessageEvent("Наверх не пройти - путь завален"))

            return false
        end
    elseif direction == StairwayDirections.downstairs then
        tile = Tiles.downstairs
        msg = {
            "Лестница в неизвестные глубины. ",
            "Чтобы пройти нажми ",
            Colors.orange,
            "[Enter]"
        }
        action = function (data)
            data.event_manager:post_event(ChangeGameStateEvent(GameStates.finish_level_state))

            return true
        end
    end

    local data = {
        walkable = true,
        terrain_type = Terrains.stairway,
        tile = tile,
        transparent = true,
        msg = msg,
        action = action
    }

    BaseTerrain.initialize(self, data)

    self.direction = direction
end

return Stairway
