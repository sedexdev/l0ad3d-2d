--[[
    SystemManager: class

    Includes: Observer - parent class for observers

    Description:
        The system manager initialises, updates and renders 
        all game systems
]]

SystemManager = Class{__includes = Observer}

--[[
    SystemManager constructor 

    Params:
        map:    table - Map object
        player: table - Player object
    Returns:
        nil
]]
function SystemManager:init(map, player)
    self.map              = map
    self.player           = player
    -- create a DoorSystem
    self.doorSystem       = DoorSystem(self.map, player)
    -- create a CollisionSystem
    self.collisionSystem  = CollisionSystem(self)
    -- create a ObjectSystem
    self.objectSystem     = ObjectSystem(self)
    -- create an instance of SpriteBatch for Grunt Entity objects
    self.gruntSpriteBatch = SpriteBatcher(GTextures['grunt'])
    -- create an EnemySystem
    self.enemySystem      = EnemySystem(self.gruntSpriteBatch, self)
    -- crate an EffectsSystem
    self.effectsSystem    = EffectsSystem(self)
    -- playerData table
    self.playerData       = {}
    self.currentAreaID    = START_AREA_ID
    -- bulletData table
    self.bulletData       = {}
end

--[[
    SystemManager update function

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function SystemManager:update(dt)
    self.doorSystem:update(dt)
    self.objectSystem:update(dt)
    self.enemySystem:update(dt)
    self.effectsSystem:update(dt)
end

--[[
    SystemManager render function. manages the order in which
    systems render their components. Blood stains should be
    rendered underneath crates for example

    Params:
        none
    Returns:
        nil
]]
function SystemManager:render()
    self.doorSystem:render()
    -- blood on top of Map but under everything else
    self.effectsSystem:renderBloodStains()
    self.objectSystem:render()
    --  explosions over objects
    self.effectsSystem:renderExplosions()
    -- smoke over objects
    self.effectsSystem:render()
    self.enemySystem:render()
    -- shots over everything
    self.effectsSystem:renderShots()
end

--[[
    Observer message function implementation. Updates the
    <self.playerData> instance variable with the latest
    Player data and checks for collision with game objects
    and the map enevironment

    Params:
        data: table - Player object current state
    Returns;
        nil
]]
function SystemManager:message(data)
    if data.source == 'PlayerWalkingState' then
        self.playerData    = data
        self.currentAreaID = self.playerData.areaID
        self:checkKeys()
        self:checkCrates()
        self:checkPowerUps()
        self:checkMap()
        self:checkGrunts()
        self:checkBoss()
    end
    if data.source == 'Bullet' then
        self.bulletData = data
        self:checkBullet()
    end
end

--[[
    Checks the appropriate systems for collisions with key
    type PowerUp objects and calls the handler in the event
    of a collision

    Params:
        none
    Returns:
        nil
]]
function SystemManager:checkKeys()
    local keys = self.objectSystem.objects[self.currentAreaID].keys
    if keys[1] ~= nil then
        if self.collisionSystem:objectCollision(keys[1]) then
            self.objectSystem:handleKeyCollision(keys[1])
        end
    end
end

--[[
    Checks the appropriate systems for collisions with crate
    type PowerUp objects and calls the handler in the event
    of a collision

    Params:
        none
    Returns:
        nil
]]
function SystemManager:checkCrates()
    local crates = self.objectSystem.objects[self.currentAreaID].crates
    for _, crate in pairs(crates) do
        -- check for Player collisions if playerData has been sent by the Observable
        local playerCollision = self.collisionSystem:crateCollision(crate, self.playerData)
        if playerCollision.detected then
            self.collisionSystem:handlePlayerCrateCollision(crate, playerCollision.edge)
        end
        -- check for grunt collisions
        for _, grunt in pairs(self.enemySystem.enemies[self.currentAreaID].grunts) do
            if grunt.areaID == self.currentAreaID then
                local gruntCollision = self.collisionSystem:crateCollision(crate, grunt)
                if gruntCollision.detected then
                    self.collisionSystem:handleEnemyCrateCollision(grunt, gruntCollision.edge)
                end
            end
        end
        -- check for boss collisions
        if self.enemySystem.boss then
            local bossCollision = self.collisionSystem:crateCollision(crate, self.enemySystem.boss)
            if bossCollision.detected then
                self.collisionSystem:handleEnemyCrateCollision(self.enemySystem.boss, bossCollision.edge)
            end
        end
    end
end

--[[
    Checks the appropriate systems for collisions with powerup
    type PowerUp objects and calls the handler in the event
    of a collision

    Params:
        none
    Returns:
        nil
]]
function SystemManager:checkPowerUps()
    local powerups = self.objectSystem.objects[self.currentAreaID].powerups
    -- check for powerup collisions in the current area
    for _, powerup in pairs(powerups) do
        if self.collisionSystem:objectCollision(powerup) then
            self.objectSystem:handlePowerUpCollision(powerup)
        end
    end
end

--[[
    Checks for interactions with the Map environment by
    querying the relevant systems for updates
    
    Params:
        none
    Returns:
        nil 
]]
function SystemManager:checkMap()
    local area = self.map:getAreaDefinition(self.currentAreaID)
    -- check if the player has collided with the wall in this area
    local wallCollision = self.collisionSystem:checkWallCollision(area, self.playerData)
    if wallCollision.detected then
        -- handle the wall collision
        self.collisionSystem:handlePlayerWallCollision(area, wallCollision.edge)
    end
    -- check for any area door collisions
    local doors = nil
    if area.type == 'area' then
        doors = self.doorSystem:getAreaDoors(area.id)
    else
        doors = self.doorSystem:getCorridorDoors(area.id)
    end
    if doors then
        for _, door in pairs(doors) do
            local proximity = self.collisionSystem:checkDoorProximity(door)
            if proximity and door.isLocked then
                self.doorSystem:handleLockedDoor(door)
            end
        end
    end
end

--[[
    Check the area adjacencies for the current Player area ID and
    spawns more grunts in those areas if the current count is 0

    Params:
        none
    Returns:
        nil
]]
function SystemManager:checkGrunts()
    -- get the adjacent area IDs
    local areaIDs = GAreaAdjacencyDefinitions[self.currentAreaID]
    for _, id in pairs(areaIDs) do
        -- check if any of the areas have 0 grunts in
        if id >= START_AREA_ID and Length(self.enemySystem.enemies[id].grunts) == 0 then
            self.enemySystem:spawn(self.map:getAreaDefinition(id))
        end
    end
end

--[[
    Checks to see if the Player has entered the area defined by
    BOSS_SPAWN_AREA_ID and spawns the Boss Entity object if so

    Params:
        none
    Returns:
        nil
]]
function SystemManager:checkBoss()
    -- spawn Boss if we are in the spawn area and not yet spawned
    if self.currentAreaID == BOSS_SPAWN_AREA_ID and not self.enemySystem.bossSpawned then
        -- Boss is then spawned in the defined area
        self.enemySystem:spawnBoss(self.map:getAreaDefinition(BOSS_AREA_ID))
        self.enemySystem.bossSpawned = true
    end
end

--[[
    Check the area for Bullet hits

    Params:
        none
    Returns:
        nil
]]
function SystemManager:checkBullet()
    local bulletHit = false
    if self.bulletData.entity.type == 'character' then
        -- use boolean flag to track if we need to check checking for Bullet hits
        bulletHit = self:crateHelper()
        -- if Bullet didn't hit a crate check for grunts
        if not bulletHit then
            bulletHit = self:gruntHelper()
        end
        -- if Bullet didn't hit a grunt check for turrets
        if not bulletHit then
            bulletHit = self:turretHelper()
        end
        -- if Bullet didn't hit a grunt check for boss
        if not bulletHit then
            bulletHit = self:bossHelper()
        end
    end
    if self.bulletData.entity.type == 'turret' or self.bulletData.entity.type == 'boss' then
        self:playerHelper()
    end
    -- if Bullet hit nothing then remove it when it hits the area boundary
    if not bulletHit then
        self:boundaryHelper()
    end
end

-- ======================= BULLET COLLISION HELPERS =======================

--[[
    Gets the crates in the local area and checks for a
    bullet collision with any of them. If a collision is
    detected both the bullet and the crate are removed
    and an explosion is rendered

    Params:
        none
    Returns:
        boolean: true if bullet hit a Crate object
]]
function SystemManager:crateHelper()
    local crates = self.objectSystem.objects[self.currentAreaID].crates
    for _, crate in pairs(crates) do
        if self.collisionSystem:bulletCollision(self.bulletData, crate) then
            Audio_Explosion()
            -- remove the Bullet on hit to avoid it continuing to update
            Remove(self.effectsSystem.bullets, self.bulletData.bullet)
            self.effectsSystem:insertExplosion(crate)
            Remove(self.objectSystem.objects[self.currentAreaID].crates, crate)
            return true
        end
    end
    return false
end

--[[
    Gets the grunts in the local area and checks for a
    bullet collision with any of them. If a collision is
    detected both the bullet and the grunt are removed
    and a blood splatter is rendered. A chance of also
    dropping a powerup is also handled

    Params:
        none
    Returns:
        boolean: true if bullet hit a Grunt object
]]
function SystemManager:gruntHelper()
    local grunts = self.enemySystem.enemies[self.currentAreaID].grunts
    for _, grunt in pairs(grunts) do
        if self.collisionSystem:bulletCollision(self.bulletData, grunt) then
            -- remove the Bullet on hit to avoid it continuing to update
            Remove(self.effectsSystem.bullets, self.bulletData.bullet)
            grunt:takeDamage()
            if grunt.isDead then
                Audio_GruntDeath()
                self.effectsSystem:insertBlood(grunt)
                -- set 1/10 chance to drop a powerup
                local powerUpChance = math.random(1, 4) == 1 and true or false
                if powerUpChance then
                    self.objectSystem:spawnPowerUp(grunt.x, grunt.y, grunt.areaID)
                end
                Remove(self.enemySystem.enemies[self.currentAreaID].grunts, grunt)
                Event.dispatch('score', 25)
                break
            end
            return true
        end
    end
    return false
end

--[[
    Gets the turrets in the local area and checks for a
    bullet collision with any of them. If a collision is
    detected both the bullet and the turret are removed
    and an explosion is rendered

    Params:
        none
    Returns:
        boolean: true if bullet hit a Turret object
]]
function SystemManager:turretHelper()
    local turrets = self.enemySystem.enemies[self.currentAreaID].turrets
    for _, turret in pairs(turrets) do
        if self.collisionSystem:bulletCollision(self.bulletData, turret) then
            -- remove the Bullet on hit to avoid it continuing to update
            Remove(self.effectsSystem.bullets, self.bulletData.bullet)
            turret:takeDamage()
            if turret.isDead then
                Audio_Explosion()
                self.effectsSystem:insertExplosion(turret)
                Remove(self.enemySystem.enemies[self.currentAreaID].turrets, turret)
                Event.dispatch('score', 100)
                break
            end
            return true
        end
    end
    return false
end

--[[
    Checks to see if the Boss has been spawned by checking 
    it is not nil, then handles a Bullet collision with the
    Boss if one occurred. Killing the Boss dispatches a
    levelComplete event 

    Params:
        none
    Returns:
        boolean: true if bullet hit the Boss object
]]
function SystemManager:bossHelper()
    if self.enemySystem.boss ~= nil then
        if self.collisionSystem:bulletCollision(self.bulletData, self.enemySystem.boss) then
            -- remove the Bullet on hit to avoid it continuing to update
            Remove(self.effectsSystem.bullets, self.bulletData.bullet)
            self.enemySystem.boss:takeDamage(self.player)
            if self.enemySystem.boss.isDead then
                self.enemySystem.boss = nil
                Event.dispatch('score', 1000)
                Event.dispatch('levelComplete')
            end
            return true
        end
    end
    return false
end

--[[
    Checks for the moment when the bullet hits the area boundary wall
    and removes the bullet and emits a Smoke instance animation

    Params:
        none
    Returns:
        nil
]]
function SystemManager:boundaryHelper()
    if self.collisionSystem:bulletHitBoundary(self.bulletData.x, self.bulletData.y) then
        -- store bullet (x, y)
        local x = self.bulletData.x
        local y = self.bulletData.y
        -- remove bullet
        Remove(self.effectsSystem.bullets, self.bulletData.bullet)
        -- use stored (x, y) to instantiate smoke effect
        self.effectsSystem:insertSmoke(x, y)
    end
end

--[[
    Checks for a bullet collision with the Player from a bullet
    fired by an enemy e.g. Turrets or the Boss

    Params:
        none
    Returns:
        nil
]]
function SystemManager:playerHelper()
    if self.collisionSystem:bulletCollision(self.bulletData, self.player) then
        self.player:takeDamage(self.bulletData.entity.damage)
        Remove(self.effectsSystem.bullets, self.bulletData.bullet)
        if self.player.isDead then
            Event.dispatch('gameOver')
        end
        return true
    end
    return false
end
