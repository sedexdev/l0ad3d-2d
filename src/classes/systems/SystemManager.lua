--[[
    SystemManager: class

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
    self.map = map
    self.player = player
    -- create a DoorSystem
    self.doorSystem = DoorSystem(self.map)
    -- create a CollisionSystem
    self.collisionSystem = CollisionSystem(self)
    -- create a ObjectSystem
    self.objectSystem = ObjectSystem(self)
    -- create an instance of SpriteBatch for Grunt Entity objects
    self.gruntSpriteBatch = SpriteBatcher(GTextures['grunt'])
    -- create an EnemySystem
    self.enemySystem = EnemySystem(self.gruntSpriteBatch, self)
    -- crate an EffectsSystem
    self.effectsSystem = EffectsSystem(self)
    -- playerData table
    self.playerData = {}
    -- bulletData table
    self.bulletData = {}
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
    self.enemySystem:update(dt)
    self.effectsSystem:update(dt)
end

--[[
    SystemManager render function 

    Params:
        none
    Returns:
        nil
]]
function SystemManager:render()
    self.doorSystem:render()
    self.effectsSystem:render()
    self.objectSystem:render()
    self.enemySystem:render()
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
        self.playerData = data
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
    local key = self.objectSystem:getAreaKey()
    if key then
        if self.collisionSystem:objectCollision(key) then
            self.objectSystem:handleKeyCollision(key)
        end
    end
end

--[[
    Checks the appropriate systems for collisions with crate
    type PowerUp objects and calls the handler in the event
    of a collision

    Params:
        currentAreaID: number - ID of the current area
    Returns:
        nil
]]
function SystemManager:checkCrates()
    local crates = self.objectSystem:getAreaCrates()
    for _, crate in pairs(crates) do
        -- check for Player collisions if playerData has been sent by the Observable
        local playerCollision = self.collisionSystem:crateCollision(crate, self.playerData)
        if playerCollision.detected then
            self.collisionSystem:handlePlayerCrateCollision(crate, playerCollision.edge)
        end
        -- check for grunt collisions
        for _, grunt in pairs(self.enemySystem.grunts) do
            if grunt.areaID == self.playerData.currentAreaID then
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
    local powerups = self.objectSystem:getAreaPowerUps()
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
        area: table - MapArea object
    Returns:
        nil 
]]
function SystemManager:checkMap()
    local area = self.map:getAreaDefinition(self.playerData.areaID)
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
            -- first check Player proximity and open door if not locked
            local proximity = self.collisionSystem:checkDoorProximity(door)
            if proximity then
                -- then check collision with the Door object to avoid Player running over it
                local doorCollision = self.collisionSystem:checkDoorCollsion(door)
                if doorCollision.detected then
                    -- and handle the collision if so
                    self.collisionSystem:handleDoorCollision(door, doorCollision.edge)
                end
            end
        end
    end
end

--[[
    Check the area adjacencies for the area ID passed in and
    spawns more grunts in those areas if the current count is 0

    Params:
        currentAreaID: number MapArea ID
    Returns:
        nil
]]
function SystemManager:checkGrunts()
    -- will only spawn grunts in adjacent areas that have 0 grunts in
    self.enemySystem:spawn(self.map:getAreaAdjacencies(self.playerData.areaID))
end

--[[
    Checks ton see if we need to spawn the Boss

    Params:
        none
    Returns:
        nil
]]
function SystemManager:checkBoss()
    -- spawn Boss if we are in the spawn area and not yet spawned
    if self.playerData.areaID == BOSS_SPAWN_AREA_ID and not self.enemySystem.bossSpawned then
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
    -- use boolean flag to track if we need to check checking for Bullet hits
    local bulletHit = false
    local crates = self.objectSystem:getAreaCrates()
    for _, crate in pairs(crates) do
        if self.collisionSystem:bulletCollision(self.bulletData, crate) then
            -- remove the Bullet on hit to avoid it continuing to update
            self.effectsSystem:removeBullet(self.bulletData.id)
            self.objectSystem:removeCrate(crate.id)
            table.insert(self.effectsSystem.explosions, Explosion:factory(crate))
            bulletHit = true
            break
        end
    end
    -- if Bullet didn't hit a crate check for grunts
    if not bulletHit then
        local grunts = self.enemySystem:getAreaGrunts()
        for _, grunt in pairs(grunts) do
            if self.collisionSystem:bulletCollision(self.bulletData, grunt) then
                -- remove the Bullet on hit to avoid it continuing to update
                self.effectsSystem:removeBullet(self.bulletData.id)
                grunt:takeDamage()
                if grunt.isDead then
                    local bloodStain = BloodSplatter:factory(grunt.x, grunt.y, grunt.direction)
                    table.insert(self.effectsSystem.bloodStains, bloodStain)
                    Timer.after(BLOOD_STAIN_INTERVAL, function ()
                        bloodStain = nil
                        -- pass 1 as the index to always remove the first one rendered
                        table.remove(self.effectsSystem.bloodStains, 1)
                    end)
                    self.enemySystem:removeGrunt(grunt.id)
                    bulletHit = true
                    break
                end
            end
        end
    end
    -- if Bullet hit nothing then remove it when it hits the area boundary
    if not bulletHit then
        if self.collisionSystem:bulletHitBoundary(self.bulletData.x, self.bulletData.y) then
            self.effectsSystem:emitWallParticleEffect(self.bulletData.x, self.bulletData.y)
            self.effectsSystem:removeBullet(self.bulletData.id)
        end
    end
end
