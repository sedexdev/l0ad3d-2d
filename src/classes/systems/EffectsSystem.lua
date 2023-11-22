--[[
    EffectsSystem: class

    Description:
        The effects system is responsible for updating and rendering out 
        the graphical effects within the game. This includes explosions, 
        shots fired, powerup rotation physics, and particle systems
]]

EffectsSystem = Class{__includes = Observer}

--[[
    EffectsSystem constructor

    Params:
        player:        table - Player object
        systemManager: table - SystemManager object
    Returns:
        nil
]]
function EffectsSystem:init(systemManager)

    -- upates with data received from Observable PlayerWalkingState class
    -- instantiate with Player starting data
    self.playerX = PLAYER_STARTING_X
    self.playerY = PLAYER_STARTING_Y
    self.currentAreaID = START_AREA_ID

    self.systemManager = systemManager
    -- explosions table
    self.explosions = {}
    -- shots table keeps track of Shot objects so they can be 
    -- instantiated and removed after the assigned interval
    self.shots = {}
    -- bullet management table
    self.bulletID = 1
    self.bullets = {}
    -- bullet fired event
    self.spawnBullet = Event.on('shotFired', function (entity)
        table.insert(self.shots, Shot(entity))
        -- TODO: change shot sound for Boss/Turret
        GAudio['gunshot']:stop()
        GAudio['gunshot']:play()
        table.insert(self.bullets, Bullet(self.bulletID, entity))
        self.bulletID = self.bulletID + 1
    end)
    -- blood stains
    self.bloodStains = {}
end

--[[
    EffectsSystem update function

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function EffectsSystem:update(dt)
    for _, explosion in pairs(self.explosions) do
        explosion:update(dt)
    end
    for _, bullet in pairs(self.bullets) do
        bullet:update(dt)
        self:checkBullets(self.systemManager.powerupSystem.crates, bullet)
        self:checkBullets(self.systemManager.enemySystem.grunts, bullet)
        self:checkBullets(self.systemManager.enemySystem.turrets, bullet)
        if self.systemManager.enemySystem.boss then
            -- check for Boss damage using Boss class
        end
    end
    for _, shot in pairs(self.shots) do
        -- update the shot animation
        shot:update(dt)
        if not shot.renderShot then
            shot = nil
            -- remove shots once their interval has passed
            table.remove(self.shots, shot)
        end
    end
end

--[[
    EffectsSystem render function

    Params:
        none
    Returns:
        none
]]
function EffectsSystem:render()
    love.graphics.setColor(1, 1, 1, 1)
    -- explosions
    for key, explosion in pairs(self.explosions) do
        explosion:render()
        if explosion.animations:getCurrentFrame() == 16 then
            explosion = nil
            table.remove(self.explosions, key)
        end
    end
    -- blood stains
    for _, stain in pairs(self.bloodStains) do
        stain:render()
    end
    -- shots
    for _, shot in pairs(self.shots) do
        if shot.renderShot then
            shot:render()
        end
    end
end

--[[
    Observer message function implementation. Updates the current
    (x, y) coordinates of the Player

    Params:
        playerData: table - Player object current state
    Returns;
        nil
]]
function EffectsSystem:message(playerData)
    self.playerX = playerData.x
    self.playerY = playerData.y
    self.currentAreaID = playerData.areaID
end

--[[
    Checks for Bullet hits and removes the object it hit 
    from the game

    Params:
        systemTable: table - system objects
        bullet:      table - Bullet object
    Returns:
        nil
]]
function EffectsSystem:checkBullets(systemTable, bullet)
    for key, object in pairs(systemTable) do
        if bullet:hit(object) then
            if object.type == 'crate' then
                table.insert(self.explosions, Explosion:factory(object))
                object = nil
                table.remove(systemTable, key)
                bullet = nil
                table.remove(self.bullets, bullet)
                break
            end
            if object.type == 'grunt' then
                self:handleGruntHit(systemTable, key, object)
                bullet = nil
                table.remove(self.bullets, bullet)
                break
            end
        end
    end
end

--[[
    Handles the workflow when a Bullet object hits a 
    Grunt Entity object
    
    Params:
        systemTable: table  - system table objects
        key:         number - table index
        grunt:       table  - grunt type Entity object      
    Returns:
        nil
]]
function EffectsSystem:handleGruntHit(systemTable, key, grunt)
    grunt:takeDamage()
    if grunt.isDead then
        local bloodSplatter = BloodSplatter(GTextures['blood-splatter'], grunt.x, grunt.y, grunt.direction)
        table.insert(self.bloodStains, bloodSplatter)
        Timer.after(180, function ()
            for i, _ in pairs(self.bloodStains) do
                table.remove(self.bloodStains, i)
            end
        end)
        -- set a random chance of spawning a powerup
        local powerUpChance = math.random(1, 5) == 1 and true or false
        -- assign same (x, y) as the crate
        if powerUpChance then
            self.systemManager.powerupSystem:spawnPowerUp(grunt.x, grunt.y, self.currentAreaID)
        end
        grunt = nil
        table.remove(systemTable, key)
    end
end
