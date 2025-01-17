local class = require "middleclass"


local Actor = class("Actor")

function Actor:initialize(data)
    self.input_actor = data.input_actor or false
    self.brain = data.brain
    self.energy = data.energy
    self.speed = data.speed

    self.action = nil
end

function Actor:needs_input()
    if not self.action and self.input_actor then
        return true
    end

    return false
end

function Actor:can_take_turn()
    if self.action and (self.energy >= self.action:get_cost())then
        return true
    end

    return false
end

function Actor:gain_energy()
    if self.action then
        self.energy = self.energy + self.speed

        return self.energy >= self.action:get_cost()
    end

    return false
end

function Actor:spend_energy(cost)
    self.energy = self.energy - cost
end

function Actor:set_action(action)
    self.action = action
end

function Actor:get_action()
    local action = self.action
    self.action = nil

    return action
end

function Actor:has_action()
    return not not self.action
end

function Actor:think(data, unit)
    if self.brain then
        self.brain:think(unit, data)
    end
end

return Actor
