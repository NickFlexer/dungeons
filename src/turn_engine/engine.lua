local class = require "middleclass"
local Ringer = require "ringer"

local AddActorEvent = require "events.engine.add_actor_event"
local RemoveActorEvent = require "events.engine.remove_actor_event"
local ClearActorsEvent = require "events.engine.clear_actors_event"


local Engine = class("Engine")

function Engine:initialize(data)
    self.actors = Ringer()
end

function Engine:update(data)
    while true do
        if self.actors:is_empty() then
            return
        end

        local current_actor = self.actors:get():get_actor()

        if current_actor:can_take_turn() and current_actor:needs_input() then
            return
        end

        local action

        while not action do
            current_actor = self.actors:get():get_actor()

            if not current_actor:has_action() then
                if current_actor:needs_input() then
                    return
                end

                current_actor:think(data, self.actors:get())
            end

            if current_actor:can_take_turn() or current_actor:gain_energy() then
                action = current_actor:get_action()
            else
                self.actors:next()
            end
        end

        local result = action:perform(data, self.actors:get())

        while result:has_alternative() do
            action = result:get_alternative()
            result = action:perform(data, self.actors:get())
        end

        if result:is_success() then
            current_actor:spend_energy(action:get_cost())

            if not self.actors:is_empty() then
                self.actors:next()
            else
                return
            end
        end
    end
end

function Engine:handle_events(event)
    if event.class.name == AddActorEvent.name then
        local new_actor = event:get_actor()
        self.actors:insert(new_actor)
    elseif event.class.name == RemoveActorEvent.name then
        local actor = event:get_actor()

        if self.actors:is_exist(actor) then
            self.actors:remove(actor)
        end
    elseif event.class.name == ClearActorsEvent.name then
        self.actors = Ringer()
    end
end

return Engine
