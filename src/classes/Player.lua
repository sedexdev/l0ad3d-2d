Player = Class{__includes = Entity}

function Player:init(id, animations, def)
    Entity.init(self, def)
    self.id = id
    self.texture = animations.texture
    self.animations = animations.animations
    self.health = def.health
    self.ammo = def.ammo
    self.direction = def.direction
    self.lastDirection = def.lastDirection
    self.speed = def.speed
    self.powerups = def.powerups
end

function Player:update(dt)
    Entity.update(self, dt)
end

function Player:render()
    Entity.render(self)
end
