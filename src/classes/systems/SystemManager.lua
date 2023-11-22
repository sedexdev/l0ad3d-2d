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
    self.collisionSystem = CollisionSystem(self, self.player)
    -- create a PowerUpSystem
    self.powerupSystem = PowerUpSystem(self, self.player)
    -- create an instance of SpriteBatch for Grunt Entity objects
    self.gruntSpriteBatch = SpriteBatcher(GTextures['grunt'])
    -- create an EnemySystem
    self.enemySystem = EnemySystem(self.gruntSpriteBatch, self)
    -- crate an EffectsSystem
    self.effectsSystem = EffectsSystem(self)
    -- playerData table
    self.playerData = {}
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
    self.powerupSystem:render()
    self.enemySystem:render()
end

--[[
    Observer message function implementation. Updates the
    <self.playerData> instance variable with the latest
    Player data

    Params:
        playerData: table - Player object current state
    Returns;
        nil
]]
function SystemManager:message(playerData)
    self.playerData = playerData
end

--[[
    Checks the appropriate systems for collisions with key
    type PowerUp objects and calls the handler in the event
    of a collision

    Params:
        currentAreaID: number - ID of the current area
    Returns:
        nil
]]
function SystemManager:checkKeys(currentAreaID)
    for _, key in pairs(self.powerupSystem.keys) do
        if currentAreaID == key.areaID then
            if self.collisionSystem:objectCollision(key) then
                self.powerupSystem:handleKeyCollision(key)
            end
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
function SystemManager:checkCrates(currentAreaID)
    for _, crate in pairs(self.powerupSystem.crates) do
        if currentAreaID == crate.areaID then
            local next = next
            if next(self.playerData) ~= nil then
                -- check for Player collisions if playerData has been sent by the Observable
                local playerCollision = self.collisionSystem:crateCollision(crate, self.playerData)
                if playerCollision.detected then
                    self.collisionSystem:handlePlayerCrateCollision(crate, playerCollision.edge)
                end
            end
            -- check for grunt collisions
            for _, grunt in pairs(self.enemySystem.grunts) do
                if grunt.areaID == currentAreaID then
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
end

--[[
    Checks the appropriate systems for collisions with powerup
    type PowerUp objects and calls the handler in the event
    of a collision

    Params:
        currentAreaID: number - ID of the current area
    Returns:
        nil
]]
function SystemManager:checkPowerUps(currentAreaID)
    -- check for powerup collisions in the current area
    for _, category in pairs(self.powerupSystem.powerups) do
        for _, powerup in pairs(category) do
            if currentAreaID == powerup.areaID then
                if self.collisionSystem:objectCollision(powerup) then
                    self.powerupSystem:handlePowerUpCollision(powerup)
                end
            end
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
function SystemManager:checkMap(area)
    local next = next
    if next(self.playerData) ~= nil then
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
end

--[[
    Check the area adjacencies for the area ID passed in and
    spawns more grunts in those areas if the current count is 0

    Params:
        currentAreaID: number MapArea ID
    Returns:
        nil
]]
function SystemManager:checkGrunts(currentAreaID)
    -- will only spawn grunts in adjacent areas that have 0 grunts in
    self.enemySystem:spawn(self.map:getAreaAdjacencies(currentAreaID))
end
