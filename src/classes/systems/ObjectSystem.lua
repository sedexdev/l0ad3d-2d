--[[
    ObjectSystem: class

    Includes: Observer - parent class for observers

    Description:
        The object system is responsible for spawning powerups and
        handling collisions after detection with the Player so they can 
        be collected. It also spawns keys and crates in the map
]]

ObjectSystem = Class{__includes = Observer}

--[[
    ObjectSystem constructor. Tables are used to store currently
    available powerups which are then removed from memory once 
    collected. The ObjectSystem also initialises/respawns crates 
    and also manages keys

    Params:
        systemManager: table - SystemManager object
    Returns:
        nil
]]
function ObjectSystem:init(systemManager)
    self.systemManager = systemManager
    self.currentAreaID = START_AREA_ID
    -- uses area IDs as keys
    self.objects       = {}
    -- populate keys and sub-tables in self.objects
    for i = 1, #GMapAreaDefinitions do
        self.objects[i]          = {}
        self.objects[i].powerups = {}
        self.objects[i].crates   = {}
        self.objects[i].keys     = {}
    end
    self.objectIDs = {
        powerupID = 1,
        crateID   = 1
    }
    self.locationCount = 1
end

--[[
    ObjectSystem update function

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function ObjectSystem:update(dt)
    for areaID, _ in pairs(self.objects) do
        for _, powerup in pairs(self.objects[areaID].powerups) do
            powerup:update(dt)
            if powerup.remove then
                Remove(self.objects[areaID].powerups, powerup)
            end
        end
    end
end

--[[
    ObjectSystem render function. Calls the render function
    of each powerup in the system

    Params:
        none
    Returns:
        none
]]
function ObjectSystem:render()
    for _, areaID in pairs(self.objects) do
        for _, powerup in pairs(areaID.powerups) do
            powerup:render()
        end
        for _, crate in pairs(areaID.crates) do
            crate:render()
        end
        for _, key in pairs(areaID.keys) do
            key:render()
        end
    end
end

--[[
    Observer message function implementation. Updates the current
    (x, y) coordinates of the Player

    Params:
        data: table - Player object current state
    Returns;
        nil
]]
function ObjectSystem:message(data)
    if data.source == 'PlayerWalkingState' then
        self.currentAreaID = data.areaID
    end
end

-- =========================== SPAWN OBJECTS ===========================

--[[
    Calls all the initialisation functions below for
    inistialising PowerUp objects

    Params:
        none
    Returns:
        nil
]]
function ObjectSystem:spawn()
    for i = START_AREA_ID, #GMapAreaDefinitions do
        self:spawnCrate(i)
    end
    self:spawnKeys()
end

--[[
    Spawns crates all over the map in random locations. Crates
    have a random chance of spawning a PowerUp underneath them

    Params:
        areaID: number - area ID to spawn the Crate in
    Returns:
        nil
]]
function ObjectSystem:spawnCrate(areaID)
    local startCount, endCount = self:getCrateLimits(areaID)
    local numCrates = math.random(startCount, endCount)
    for _ = 1, numCrates do
        -- determine an (x, y) for the crate based on room size
        local x, y = self:setCrateXYCoordinates(areaID)
        table.insert(self.objects[areaID].crates, Crate(self.objectIDs.crateID, areaID, x, y))
        self.objectIDs.crateID = self.objectIDs.crateID + 1
        -- set a random chance of hiding a powerup under the crate
        local powerUpChance = math.random(1, 4) == 1 and true or false
        -- assign same (x, y) as the crate
        if powerUpChance then
            self:spawnPowerUp(x, y, areaID)
        end
    end
end

--[[
    Gets the start and end values for the random number
    generated to decide on the number of crates to insert
    based on the size of the area

    Params:
        areaID: number - area ID to spawn the Crate in
    Returns:
        number: start of range
        number: end of range
]]
function ObjectSystem:getCrateLimits(areaID)
    -- get the area of the area
    local roomArea = GMapAreaDefinitions[areaID].width * GMapAreaDefinitions[areaID].height
    -- generate a random number of crates dependent on room size
    local startCount, endCount, numCrates
    if roomArea < 64 then
        startCount = 1
        endCount = 3
    elseif roomArea == 64 then
        startCount = 4
        endCount = 6
    else
        startCount = 6
        endCount = 8
    end
    return startCount, endCount
end

--[[
    Spawns the 3 keys available in the Map in specific locations

    Params:
        none
    Returns:
        nil
]]
function ObjectSystem:spawnKeys()
    for i = 1, #GKeyDefinitions do
        table.insert(self.objects[GKeyDefinitions[i].areaID].keys, Key(
            i,
            GKeyDefinitions[i].areaID,
            GKeyDefinitions[i].x,
            GKeyDefinitions[i].y
        ))
    end
end

--[[
    Initialises a random number of powerups in the Map and 
    inserts them into the <self.powerups> table

    Params:
        x: number - x coordinate of the crate covering the PowerUp object
        y: number - y coordinate of the crate covering the PowerUp object
        areaID: number - MapArea ID
    Returns:
        nil
]]
function ObjectSystem:spawnPowerUp(x, y, areaID)
    -- set (x, y) based on crate
    x = x + (CRATE_WIDTH - POWERUP_WIDTH) / 2
    y = y + (CRATE_HEIGHT - POWERUP_HEIGHT) / 2
    -- set random chance of finding each powerup
    local health = math.random(3) == 1 and true or false
    if health then
        table.insert(self.objects[areaID].powerups, PowerUp(self.objectIDs.powerupID, 'health', areaID, x, y))
        self.objectIDs.powerupID = self.objectIDs.powerupID + 1
        return
    end
    local ammo = math.random(4) == 1 and true or false
    if ammo then
        table.insert(self.objects[areaID].powerups, PowerUp(self.objectIDs.powerupID, 'ammo', areaID, x, y))
        self.objectIDs.powerupID = self.objectIDs.powerupID + 1
        return
    end
    local doubleSpeed = math.random(5) == 1 and true or false
    if doubleSpeed then
        table.insert(self.objects[areaID].powerups, PowerUp(self.objectIDs.powerupID, 'doubleSpeed', areaID, x, y))
        self.objectIDs.powerupID = self.objectIDs.powerupID + 1
        return
    end
    local invincible = math.random(15) == 1 and true or false
    if invincible then
        table.insert(self.objects[areaID].powerups, PowerUp(self.objectIDs.powerupID, 'invincible', areaID, x, y))
        self.objectIDs.powerupID = self.objectIDs.powerupID + 1
        return
    end
    local oneShotBossKill = math.random(20) == 1 and true or false
    if oneShotBossKill then
        table.insert(self.objects[areaID].powerups, PowerUp(self.objectIDs.powerupID, 'oneShotBossKill', areaID, x, y))
        self.objectIDs.powerupID = self.objectIDs.powerupID + 1
        return
    end
end

-- =========================== CRATE (X, Y) HELPERS ===========================

--[[
    Determines an (x, y) coordinate for a Crate object based on 
    the area of a MapArea object and the location of its doors

    Params:
        areaID: number - ID of the MapArea to get door information
    Returns:
        table: (x, y) coordinates of crate
]]
function ObjectSystem:setCrateXYCoordinates(areaID)
    local x, y = self:getCrateXYCoordinates(areaID)
    -- check (x, y) doesn't overlap any previous crates in this area
    for _, crate in pairs(self.objects[areaID].crates) do
        -- test for overlap of new crate
        local xOverlap = (crate.x < x and x < crate.x + CRATE_WIDTH) or (crate.x < x + CRATE_WIDTH and x + CRATE_WIDTH < crate.x + CRATE_WIDTH)
        local yOverlap = (crate.y < y and y < crate.y + CRATE_HEIGHT) or (crate.y < y + CRATE_HEIGHT and y + CRATE_HEIGHT < crate.y + CRATE_HEIGHT)
        if xOverlap or yOverlap then
            -- recursivley start again if an overlap occurs
            return self:setCrateXYCoordinates(areaID)
        end
    end
    return x, y
end

--[[
    Gets the (x, y) crate coordinates to return to the setCrateXYCoordinates 
    function using the getCrateXCoordinateHelper and getCrateYCoordinateHelper
    getter helper functions

    Params:
        areaID: number - ID of the area
    Returns:
        table: (x, y) coordinates of the crate
]]
function ObjectSystem:getCrateXYCoordinates(areaID)
    local areaDef = GMapAreaDefinitions[areaID]
    local edgeOffset = 50
    local wallEdges = {
        [1] = areaDef.x + edgeOffset,                                                      -- left
        [2] = areaDef.x + (areaDef.width * FLOOR_TILE_WIDTH) - CRATE_WIDTH - edgeOffset,   -- right
        [3] = areaDef.y + edgeOffset,                                                      -- top
        [4] = areaDef.y + (areaDef.height * FLOOR_TILE_HEIGHT) - CRATE_HEIGHT - edgeOffset -- bottom
    }
    local edgeID = math.random(1, 4)
    -- if this is a vertical edge an x coordinate is returned
    if edgeID == 1 or edgeID == 2 then
        -- get random y to make an (x, y) vector
        return wallEdges[edgeID], math.random(wallEdges[3], wallEdges[4])
    end
    -- if this is a horizontal edge a y coordinate is returned
    if edgeID == 3 or edgeID == 4 then
        -- get random x to make an (x, y) vector
        return math.random(wallEdges[1], wallEdges[2]), wallEdges[edgeID]
    end
end

-- =========================== COLLISIONS HANDLERS ===========================

--[[
    Handles a key collision by removing the key from memory 
    and then adding the key to the Player objects keys table

    Params:
        key: table - key type PowerUp object to detect
    Returns:
        nil
]]
function ObjectSystem:handleKeyCollision(key)
    if key.id == 1 then
        self.systemManager.player.keys['red'] = true
    end
    if key.id == 2 then
        self.systemManager.player.keys['blue'] = true
    end
    if key.id == 3 then
        self.systemManager.player.keys['green'] = true
    end
    -- remove this key
    key.remove = true
    for _, k in pairs(self.objects[self.currentAreaID].keys) do
        if k.remove then
            Remove(self.objects[self.currentAreaID].keys, k)
        end
    end
end

--[[
    Handles a powerup collision by removing the powerup from memory 
    and then adding the powerup to the Player objects powerups table

    Params:
        powerup: table - powerup type PowerUp object to detect
    Returns:
        nil
]]
function ObjectSystem:handlePowerUpCollision(powerup)
    if powerup.type == 'doubleSpeed' then
        self.systemManager.player:setDoubleSpeed()
        powerup.remove = true
    elseif powerup.type == 'oneShotBossKill' then
        self.systemManager.player:setOneShotBossKill()
        powerup.remove = true
    elseif powerup.type == 'ammo' then
        if self.systemManager.player.ammo < MAX_AMMO then
            self.systemManager.player:increaseAmmo()
            powerup.remove = true
        end
    elseif powerup.type == 'health' then
        if self.systemManager.player.health < MAX_HEALTH then
            self.systemManager.player:increaseHealth()
            powerup.remove = true
        end
    elseif powerup.type == 'invincible' then
        self.systemManager.player:makeInvicible()
        powerup.remove = true
    end
end
