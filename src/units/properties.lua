local class = require "middleclass"


local Properties = class("Properties")

function Properties:initialize(data)
    self.name = data.name
    self.cur_hp = data.hp
    self.max_hp = data.hp
    self.min_damage = data.min_damage
    self.max_damade = data.max_damage
    self.accuracy = data.accuracy
    self.crit_chanse = data.crit_chanse
    self.view_distance = data.view_distance
end

function Properties:get_hp()
    return self.cur_hp, self.max_hp
end

function Properties:get_name()
   return  self.name
end

function Properties:get_damage()
    return self.min_damage, self.max_damade
end

function Properties:get_accuracy()
    return self.accuracy
end

function Properties:get_crit_chanse()
    return self.crit_chanse
end

function Properties:take_damage(damage)
    self.cur_hp = self.cur_hp - damage
end

function Properties:is_alive()
    return self.cur_hp > 0
end

function Properties:get_view_distance()
    return self.view_distance
end

return Properties
