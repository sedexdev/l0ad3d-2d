--[[
    Player: class

    Includes: Entity - parent class for entity objects 

    Description:
        Creates, updates, and renders a Player character object
        using the parent Entity class
]]

Player = Class{__includes = Entity}

--[[
    Player constructor

    Params:
        id:         number - defines which character animations will be used
        animations: table  - Player animations
        def:        table  - Player object definition
    Returns:
        nil
]]
function Player:init(id, animations, def)
    Entity.init(self, def)
    self.id                = id
    self.texture           = animations.texture
    self.fireShot          = animations.fireShot
    self.animations        = animations.animations
    self.health            = def.health
    self.ammo              = def.ammo
    self.shotFired         = def.shotFired
    self.weapons           = def['character'..tostring(self.id)].weapons
    self.currentWeapon     = def['character'..tostring(self.id)].currentWeapon
    self.direction         = def.direction
    self.lastDirection     = def.lastDirection
    self.invulnerable      = def.invulnerable
    self.lives             = def.lives
    self.powerups          = def.powerups
    self.keys              = def.keys
    -- defines the current area of the player: {id = areaID, type = 'area' | 'corridor'}
    self.currentArea       = {id = START_AREA_ID, type = 'area'}
    -- powerup timers
    self.invulnerableTimer = 0
    self.invicibleTimer    = 0
    self.doubleSpeedTimer  = 0
    self.isDead            = false
    -- even listener for grunt attacks
    Event.on('gruntAttack', function (grunt)
        self:takeDamage(grunt.damage)
        if self.isDead then
            io.write('Player:init() \'gameOver\' event triggered...\n')
            Event.dispatch('gameOver')
        end
    end)
end

--[[
    Player update function. Defines input for firing the Players
    weapon and applys the effects of time depenedant powerups and
    temporary invulnerability after taking damage

    Key bindings:
        space: fire weapon - self:fire() called
    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function Player:update(dt)
    Entity.update(self, dt)
    if love.keyboard.wasPressed('space') then
        self:fire()
    end
    -- update timers if powerups are true
    if self.invulnerable then
        self.invulnerableTimer = self.invulnerableTimer + dt
        if self.invulnerableTimer > INVULNERABLE_DURATION then
            self.invulnerable = false
            self.invulnerableTimer = 0
        end
    end
    if self.powerups.invincible then
        self.invicibleTimer = self.invicibleTimer + dt
        if self.invicibleTimer > INVINCIBLE_DURATION then
            self.powerups.invincible = false
            self.invicibleTimer = 0
        end
    end
    if self.powerups.doubleSpeed then
        self.doubleSpeedTimer = self.doubleSpeedTimer + dt
        if self.doubleSpeedTimer > X2_SPEED_DURATION then
            self.powerups.doubleSpeed = false
            self.doubleSpeedTimer = 0
            -- reset velocity
            self.dx = CHARACTER_SPEED
            self.dy = CHARACTER_SPEED
        end
    end
end

--[[
    Player render function

    Params:
        none
    Returns:
        nil
]]
function Player:render()
    Entity.render(self)
end

--[[
    Called when an end user fires the Players weapon using
    the space key. A 'shotFired' event is dispatched to the
    PlayState to handle the shot fired. Also checks if the 
    character has more than one weapon and updates the 
    <self.currentWeapon> attribute so shots can be rendered
    from alternating weapons

    Params:
        none
    Returns:
        nil
]]
function Player:fire()
    -- dispatch event to create Shot and Bullet instances
    Event.dispatch('shotFired', self)
    -- reduce ammo count
    self.ammo = self.ammo - 1
    -- change weapon if character has 2 weapons
    if self.weapons > 1 then
        self.currentWeapon = self.currentWeapon == 'right' and 'left' or 'right'
    end
end

--[[
    Updates the location of the Player object so area-specific
    checks can be performed as the game progresses

    Params:
        map: table - Map object
    Returns:
        nil
]]
function Player:setCurrentArea(map)
    -- areas includes both areas and corridors
    for _, area in pairs(map.areas) do
        local areaWidth = area.x + (area.width * FLOOR_TILE_WIDTH) + WALL_OFFSET
        local areaHeight = area.y + (area.height * FLOOR_TILE_HEIGHT) + WALL_OFFSET
        if area.type == 'area' then
            -- if player within area/corridor x coordinate boundary
            if (self.x > area.x - WALL_OFFSET) and (self.x + self.width) < areaWidth then
                -- if player within a rea/corridor y coordinate boundary
                if (self.y > area.y - WALL_OFFSET) and (self.y + self.height) < areaHeight then
                    -- player current area updated
                    self.currentArea.id = area.id
                    self.currentArea.type = area.type
                end
            end
        else
            if (self.x + ENTITY_CORRECTION > area.x - WALL_OFFSET) and (self.x + self.width - ENTITY_CORRECTION) < areaWidth then
                -- if player within area/corridor y coordinate boundary
                if (self.y + ENTITY_CORRECTION > area.y - WALL_OFFSET) and (self.y + self.height - ENTITY_CORRECTION) < areaHeight then
                    -- player current area updated
                    self.currentArea.id = area.id
                    self.currentArea.type = area.type
                end
            end
        end
    end
end

--[[
    Handles damage dealt by enemies

    Params:
        damage: number - amount of damage dealt
    Returns:
        nil
]]
function Player:takeDamage(damage)
    -- only take damage if the Player is not invulnerable or invincible
    if self.invulnerable or self.powerups.invincible then
        return
    end
    self.health = self.health - damage
    -- go invulnerable temporarily
    self.invulnerable = true
    if self.health <= 0 then
        if self.lives > 1 then
            -- dispatch lostLife event to show remaining lives
            Event.dispatch('lostLife')
            self.lives = self.lives - 1
            self.health = MAX_HEALTH
        else
            self.isDead = true
        end
    end
end

--[[
    Increase Player health after collecting a 'health' type
    PowerUp object. Health is only increased by enough to 
    bring it up to MAX_HEALTH. If Player is already at 
    MAX_HEALTH then <self.health> is unchanged
        
    Params:
        none
    Returns:
        nil
]]
function Player:increaseHealth()
    Audio_HealthPickup()
    local healthIncrease = 25
    local currentHealthDiff = MAX_HEALTH - self.health
    if currentHealthDiff < healthIncrease then
        self.health = self.health + currentHealthDiff
    else
        self.health = self.health + healthIncrease
    end
end

--[[
    Increase Player ammo after collecting a 'ammo' type
    PowerUp object. Ammo is only increased by enough to 
    bring it up to MAX_AMMO. If Player is already at 
    MAX_AMMO then <self.ammo> is unchanged
        
    Params:
        none
    Returns:
        nil
]]
function Player:increaseAmmo()
    Audio_AmmoPickup()
    local ammoIncrease = 500
    local currentAmmoDiff = MAX_AMMO - self.ammo
    if currentAmmoDiff < ammoIncrease then
        self.ammo = self.ammo + currentAmmoDiff
    else
        self.ammo = self.ammo + ammoIncrease
    end
end

--[[
    Makes the Player invincible for INVINCIBLE_DURATION seconds

    Params:
        none
    Returns:
        nil
]]
function Player:makeInvicible()
    if not self.powerups.invincible then
        Audio_InvinciblePickup()
        self.powerups.invincible = true
    end
end

--[[
    Doubles the speed of the Player for X2_SPEED_DURATION seconds

    Params:
        none
    Returns:
        nil
]]
function Player:setDoubleSpeed()
    -- only increase speed once
    if not self.powerups.doubleSpeed then
        Audio_DoubleSpeedPickup()
        self.powerups.doubleSpeed = true
        self.dx = self.dx * 2
        self.dy = self.dy * 2
    end
end

--[[
    Sets the one shot boss kill boolean to true

    Params:
        none
    Returns:
        nil
]]
function Player:setOneShotBossKill()
    if not self.powerups.oneShotBossKill then
        Audio_OneShotBossKillPickup()
        self.powerups.oneShotBossKill = true
    end
end
