Grunt = Class{__includes = Entity}

function Grunt:init(animations, def)
    Entity.init(self, def)
    self.texture = animations.texture
    self.animations = animations.animations
    self.direction = def.direction
    self.health = def.health
    self.speed = def.speed
    self.powerUpChance = def.powerUpChance
end

function Grunt:update(dt)
    Entity.update(self, dt)
end

function Grunt:render()
    Entity.render(self)
end