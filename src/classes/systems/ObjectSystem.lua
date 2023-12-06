--[[
    ObjectSystem: class

    Includes: Observer - parent class for observers

    TODO: crates and powerups need to be replaced as the level goes on

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
    self:spawnCrates()
    self:spawnKeys()
end

--[[
    Spawns crates all over the map in random locations. Crates
    have a random chance of spawning a PowerUp underneath them

    Params:
        none
    Returns:
        nil
]]
function ObjectSystem:spawnCrates()
    for i = START_AREA_ID, #GMapAreaDefinitions do
        -- get the area of the area
        local roomArea = GMapAreaDefinitions[i].width * GMapAreaDefinitions[i].height
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
        numCrates = math.random(startCount, endCount)
        local prevLocations = {[1] = {x = nil, y = nil}}
        -- reset the number of spawned locations before setting the crate (x, y) 
        self.locationCount = 1
        for _ = 1, numCrates do
            -- determine an (x, y) for the crate based on room size
            local x, y = self:setCrateXYCoordinates(i, prevLocations)
            table.insert(self.objects[i].crates, Crate(self.objectIDs.crateID, i, x, y))
            self.objectIDs.crateID = self.objectIDs.crateID + 1
            -- set a random chance of hiding a powerup under the crate
            local powerUpChance = math.random(1, 4) == 1 and true or false
            -- assign same (x, y) as the crate
            if powerUpChance then
                self:spawnPowerUp(x, y, i)
            end
        end
    end
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

-- =========================== CRATE (X, Y) HELPERS ===========================

--[[
    Determines an (x, y) coordinate for a Crate object based on 
    the area of a MapArea object and the location of its doors

    Params:
        areaID:        number - ID of the MapArea to get door information
        prevLocations: table  - (x, y) of the last generated crate
    Returns:
        table: (x, y) coordinates of crate
]]
function ObjectSystem:setCrateXYCoordinates(areaID, prevLocations)
    local edgeOffset = 50
    local x, y
    local edges = {'L', 'T', 'R', 'B'}
    local edge = edges[math.random(1, 4)]
    -- if this is the first crate
    if #prevLocations == 1 then
        x, y = self:getCrateXYCoordinates(edge, areaID, GMapAreaDefinitions[areaID], edgeOffset)
        self.locationCount = self.locationCount + 1
    else
        x, y = self:getCrateXYCoordinates(edge, areaID, GMapAreaDefinitions[areaID], edgeOffset)
        -- if a crate location has already been spawned check random (x, y) doesn't overlap previous crate
        for _, location in pairs(prevLocations) do
            if not location.x or not location.y then goto continue end
            local xOverlap = (location.x < x and x < location.x + CRATE_WIDTH) or (location.x < x + CRATE_WIDTH and x + CRATE_WIDTH < location.x + CRATE_WIDTH)
            local yOverlap = (location.y < y and y < location.y + CRATE_HEIGHT) or (location.y < y + CRATE_HEIGHT and y + CRATE_HEIGHT < location.y + CRATE_HEIGHT)
            if xOverlap or yOverlap then
                return self:setCrateXYCoordinates(areaID, prevLocations)
            end
            ::continue::
        end
        self.locationCount = self.locationCount + 1
    end
    prevLocations[self.locationCount] = {x = x, y = y}
    return x, y
end

--[[
    Gets the (x, y) crate coordinates to return to the setCrateXYCoordinates 
    function using the getCrateXCoordinateHelper and getCrateYCoordinateHelper
    getter helper functions

    Params:
        edge:       string - wall edge to place the crate against
        areaID:     number - ID of this MapArea definition
        areaDef:    table  - MapArea definition
        edgeOffset: number - wall offset for palcing the crate
    Returns:
        table: (x, y) coordinates of the crate
]]
function ObjectSystem:getCrateXYCoordinates(edge, areaID, areaDef, edgeOffset)
    -- set door table for checking if a wall has a door
    local doors = {
        leftDoor   = false,
        topDoor    = false,
        rightDoor  = false,
        bottomDoor = false
    }
    local areaDoors = self.systemManager.doorSystem:getAreaDoors(areaID)
    -- update the boolean table
    self:setDoorLocations(doors, areaDoors, areaID)
    local x, y
    if edge == 'L' or edge == 'R' then
        -- x will be constant for each crate dependent on edge
        x = edge == 'L' and areaDef.x + edgeOffset or areaDef.x + (areaDef.width * FLOOR_TILE_WIDTH) - CRATE_WIDTH - edgeOffset
        if edge == 'L' then
            y = self:getCrateYCoordinateHelper(areaDef, doors.leftDoor)
        elseif edge == 'R' then
            y = self:getCrateYCoordinateHelper(areaDef, doors.rightDoor)
        end
    end
    if edge == 'T' or edge == 'B' then
        -- y will be constant for each crate dependent on edge
        y = edge == 'T' and areaDef.y + edgeOffset or areaDef.y + (areaDef.height * FLOOR_TILE_HEIGHT) - CRATE_HEIGHT - edgeOffset
        if edge == 'T' then
            x = self:getCrateXCoordinateHelper(areaDef, doors.topDoor)
        elseif edge == 'B' then
            x = self:getCrateXCoordinateHelper(areaDef, doors.bottomDoor)
        end
    end
    return x, y
end

--[[
    Updates a table of doors to help set area crates (x, y) so they
    don't get in the way of doorways

    Params:
        doors:     table  - booleans stating if door is present in area
        areaDoors: table  - all the Door objects in this MapArea
        areaID:    number - MapArea ID
    Returns:
        nil
]]
function ObjectSystem:setDoorLocations(doors, areaDoors, areaID)
    for _, door in pairs(areaDoors) do
        if door.areaID ~= areaID then
            if door.id == 1 then doors.rightDoor  = true end
            if door.id == 2 then doors.bottomDoor = true end
            if door.id == 3 then doors.leftDoor   = true end
            if door.id == 4 then doors.topDoor    = true end
        else
            if door.id == 1 then doors.leftDoor   = true end
            if door.id == 2 then doors.topDoor    = true end
            if door.id == 3 then doors.rightDoor  = true end
            if door.id == 4 then doors.bottomDoor = true end
        end
    end
end

--[[
    Helper function to get x crate coordinate to reduce
    bulk in the getCrateXYCoordinates function
        
    Params:
        areaDef:  table  - definition of the MapArea object
        doorEdge: string - area edge the crate will be spawned against
    Returns:
        number: x coordinate of the crate
]]
function ObjectSystem:getCrateXCoordinateHelper(areaDef, doorEdge)
    -- define edge offset to stop crates overlapping doors
    local edgeOffset = 100
    -- MapArea x conditions
    local xLeft   = areaDef.x + edgeOffset
    local xCenter = areaDef.x + (areaDef.width * FLOOR_TILE_WIDTH / 2)
    local xRight  = areaDef.x + (areaDef.width * FLOOR_TILE_WIDTH) - edgeOffset
    -- declare x but don't initialise
    local x
    -- check if edge has a door
    if doorEdge then
        -- don't include door location in x coordinate
        local xLocations = {
            math.random(xLeft, xCenter - CRATE_WIDTH - edgeOffset),
            math.random(xCenter + CRATE_WIDTH + edgeOffset, xRight - CRATE_WIDTH)
        }
        -- pick random location either left or right of door
        x = xLocations[math.random(2)]
    else
        x = math.random(xLeft, xRight - CRATE_WIDTH)
    end
    return x
end

--[[
    Helper function to get y crate coordinate to reduce
    bulk in the getCrateXYCoordinates function
        
    Params:
        areaDef:  table  - definition of the MapArea object
        doorEdge: string - area edge the crate will be spawned against
    Returns:
        number: y coordinate of the crate
]]
function ObjectSystem:getCrateYCoordinateHelper(areaDef, doorEdge)
    -- define edge offset to stop crates overlapping doors
    local edgeOffset = 100
    -- define y boundarys
    local yTop    = areaDef.y + edgeOffset
    local yCenter = areaDef.y + (areaDef.height * FLOOR_TILE_HEIGHT / 2)
    local yBottom = areaDef.y + (areaDef.height * FLOOR_TILE_HEIGHT) - edgeOffset
    -- declare y but don't initialise
    local y
    -- check if the edge has a door
    if doorEdge then
        -- don't include door location in y coordinate
        local yLocations = {
            math.random(yTop, yCenter - CRATE_HEIGHT - edgeOffset),
            math.random(yCenter + CRATE_HEIGHT + edgeOffset, yBottom - CRATE_HEIGHT)
        }
        -- pick random location either side of the door
        y = yLocations[math.random(2)]
    else
        y = math.random(yTop, yBottom - CRATE_HEIGHT)
    end
    return y
end
