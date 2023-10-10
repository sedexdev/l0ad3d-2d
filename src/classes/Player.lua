Player = Class{__includes = Entity}

function Player:init(id, animations, def)
    Entity.init(self, def)
    self.id = id
    self.texture = animations.texture
    self.fireShot = animations.fireShot
    self.animations = animations.animations
    self.health = def.health
    self.ammo = def.ammo
    self.shotFired = def.shotFired
    self.weapons = def['character'..tostring(self.id)].weapons
    self.currentWeapon = def['character'..tostring(self.id)].currentWeapon
    self.direction = def.direction
    self.lastDirection = def.lastDirection
    self.speed = def.speed
    self.powerups = def.powerups
    self.shots = {}
end

function Player:update(dt)
    Entity.update(self, dt)

    if love.keyboard.wasPressed('space') then
        self:fire()
    end

    for _, shot in pairs(self.shots) do
        shot:update(dt)
        if not shot.renderShot then
            shot = nil
            table.remove(self.shots, shot)
        end
    end
end

function Player:render()
    Entity.render(self)

    love.graphics.setColor(1, 1, 1, 1)
    for _, shot in pairs(self.shots) do
        if shot.renderShot then
            shot:render()
        end
    end
end

function Player:fire()
    table.insert(self.shots, Shot(self))
    GAudio['gunshot']:stop()
    GAudio['gunshot']:play()
    if self.weapons > 1 then
        self.currentWeapon = self.currentWeapon == 'right' and 'left' or 'right'
    end
end