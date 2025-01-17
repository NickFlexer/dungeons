local class = require "middleclass"

local Message = require "logic.ui.message"

local UpdateViewEvent = require "events.view.update_menu_view_event"
local ChangeGameStateEvent = require "events.common.change_game_state_event"

local GeneratorBSP = require "generators.generator_bsp"
local MapView = require "generators.view"

local MapController = require "map.map_controller"

local UITypes = require "enums.ui_types"
local GameStates = require "enums.game_states"

local MapSettings = require "settings.map_settings"


local GenerateMapState = class("GenerateMapState")

function GenerateMapState:initialize(data)
    self.event_manager = data.event_manager
    self.logic = data.logic
    self.map = data.map

    self.bsp_generator = GeneratorBSP()
    self.load_message = Message()
    self.terminal_view = MapView()
    self.map_controller = MapController(
        {
            logic = self.logic,
            event_manager = self.event_manager
        }
    )
end

function GenerateMapState:enter(owner)
    print("GenerateMapState enter!")

    self.load_message:set_msg("Загрузка")

    self.event_manager:post_event(UpdateViewEvent(self.load_message:get_msg(), UITypes.message))
end

function GenerateMapState:execute(owner, dt)
    local new_map = self.bsp_generator:generate(MapSettings.size_x, MapSettings.size_y)

    if new_map then
        local map_str = self.terminal_view:get_str(new_map)
        print(map_str)
        local map = self.map_controller:read_map(map_str)
        self.map:set(map)

        self.event_manager:post_event(ChangeGameStateEvent(GameStates.gameplay))
    end
end

function GenerateMapState:exit(owner)
    print("GenerateMapState exit!")
end

function GenerateMapState:handle_events(event)
end

return GenerateMapState
