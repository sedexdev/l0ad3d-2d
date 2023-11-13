--[[
    PowerUpSystem: class

    TODO:
        - Crates: spawn crates all over the map and have a chance
          of finding a power up under one
        - Initialise keys

    Description:
        A powerup system is responsible for spawning powerups and
        handling collision detection with the Player so they can 
        be collected
]]

PowerUpSystem = Class{}

--[[
    PowerUpSystem constructor. Tables are used to store currently
    available powerups which are then removed from memory once 
    collected. The PowerUpSystem also initialises/respawns crates 
    and also manages keys

    Params:
        player: table - Player object
    Returns:
        nil
]]
function PowerUpSystem:init(player)
    self.player = player
    self.powerups = {
        ['ammo'] = {},
        ['health'] = {},
        ['invincible'] = {},
        ['doubleSpeed'] = {},
        ['oneShotBossKill'] = {}
    }
    self.crates = {}
    self.keys = {}
end

--[[
    PowerUpSystem update function. Calls the update function
    of each powerup in the system

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function PowerUpSystem:update(dt)
    for _, category in pairs(self.powerups) do
        for _, powerup in pairs(category) do
            powerup:update(dt)
        end
    end
end

--[[
    PowerUpSystem render function. Calls the render function
    of each powerup in the system

    Params:
        none
    Returns:
        none
]]
function PowerUpSystem:render()
    for _, category in pairs(self.powerups) do
        for _, powerup in pairs(category) do
            powerup:render()
        end
    end
    for _, key in pairs(self.keys) do
        key:render()
    end
end

--[[
    Calls all the initialisation functions below for
    inistialising PowerUp objects including crates and
    keys

    Params:
        none
    Returns:
        nil
]]
function PowerUpSystem:spawn()
    self:initialiseCrates()
    self:initialiseKeys()
    -- self:initialisePowerUps()
end

--[[
    Spawns crates all over the map in random locations. Crates
    have a random chance of spawning a PowerUp underneath them

    Params:
        none
    Returns:
        nil
]]
function PowerUpSystem:initialiseCrates()
    local crateID = 1
    local startAreaID = 17
    for i = startAreaID, #GMapAreaDefinitions do
        -- get the area of the area
        local roomArea = GMapAreaDefinitions[i].x * GMapAreaDefinitions[i].y
        -- generate a random number of crates dependent on room size
        local startCount
        local endCount
        local numCrates
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
        local prevLocation = {x = nil, y = nil}
        for j = 1, numCrates do
            -- determine an (x, y) for the crate based on room size
            local x, y = self:setCrateXYCoordinates(i, roomArea, prevLocation)
            -- create the crate type PowerUp objects and add to self.crates
            local crate = PowerUp(
                crateID,
                i,
                x, y,
                'crate',
                1 -- quadID of 1
            )
            table.insert(self.crates, crate)
            crateID = crateID + 1
        end

        -- set a random chance of hiding a powerup under the crate

        -- write a separate function to randomly spawn powerups and assign same (x, y) as the crate

    end
end

--[[
    Determines an (x, y) coordinate for a crate type PowerUp
    object based on the area of a MapArea object and the location
    of its doors

    Params:
        areaID: number - ID of the MapArea to get door information
        roomArea: number - area of the MapArea object
        prevLocation: table - (x, y) of the last generated crate
    Returns:
        table: (x, y) coordinates of crate
]]
function PowerUpSystem:setCrateXYCoordinates(areaID, roomArea, prevLocation)
    local edgeOffset = 100
    local x, y
    local areaDef = GMapAreaDefinitions[areaID]
    local doors = areaDef.doors
    local edges = {'L', 'T', 'R', 'B'}
    local edge = edges[math.random(1, 4)]
    -- if this is the first crate
    if not prevLocation.x and not prevLocation.y then
        if edge == 'L' or edge == 'R' then
            -- MapArea y conditions
            local yTop = areaDef.y
            local yCenter = areaDef.y + (areaDef.height * FLOOR_TILE_HEIGHT / 2)
            local yBottom = areaDef.y + (areaDef.height * FLOOR_TILE_HEIGHT)
            -- x will be constant for each crate dependent on edge
            x = edge == 'L' and areaDef.x + edgeOffset or areaDef.x + (areaDef.wdth * FLOOR_TILE_WIDTH) - CRATE_WIDTH - edgeOffset
            if edge == 'L' then
                if doors.L then
                    -- don't include door location in y coordinate
                    local yLocations = {
                        math.random(areaDef.y, yCenter - CRATE_HEIGHT - edgeOffset),
                        math.random(yCenter + CRATE_HEIGHT + edgeOffset, yBottom - CRATE_HEIGHT - edgeOffset)
                    }
                    -- pick random locatio either above or below door
                    y = yLocations[math.random(2)]
                else
                    y = math.random(yTop + edgeOffset, yBottom - CRATE_HEIGHT - edgeOffset)
                end
            elseif edge == 'R' then
                if doors.R then
                    -- don't include door location in y coordinate
                    local yLocations = {
                        math.random(areaDef.y, yCenter - CRATE_HEIGHT - edgeOffset),
                        math.random(yCenter + CRATE_HEIGHT + edgeOffset, yBottom - CRATE_HEIGHT - edgeOffset)
                    }
                    -- pick random locatio either above or below door
                    y = yLocations[math.random(2)]
                else
                    y = math.random(yTop + edgeOffset, yBottom - CRATE_HEIGHT - edgeOffset)
                end
            end
        end
        if edge == 'T' or edge == 'B' then
            -- MapArea x conditions
            local xTop = areaDef.x
            local xCenter = areaDef.x + (areaDef.width * FLOOR_TILE_WIDTH / 2)
            local xBottom = areaDef.x + (areaDef.width * FLOOR_TILE_WIDTH)
            -- y will be constant for each crate dependent on edge
            y = edge == 'T' and areaDef.y + edgeOffset or areaDef.y + (areaDef.width * FLOOR_TILE_HEIGHT) - CRATE_HEIGHT - edgeOffset
            if edge == 'T' then
                if doors.T then
                    -- don't include door location in x coordinate
                    local xLocations = {
                        math.random(areaDef.x, xCenter - CRATE_WIDTH - edgeOffset),
                        math.random(xCenter + CRATE_WIDTH + edgeOffset, xBottom - CRATE_WIDTH - edgeOffset)
                    }
                    -- pick random location either left or right of door
                    x = xLocations[math.random(2)]
                else
                    x = math.random(xTop + edgeOffset, xBottom - CRATE_WIDTH - edgeOffset)
                end
            elseif edge == 'B' then
                if doors.B then
                    -- don't include door location in x coordinate
                    local xLocations = {
                        math.random(areaDef.x, xCenter - CRATE_WIDTH - edgeOffset),
                        math.random(xCenter + CRATE_WIDTH + edgeOffset, xBottom - CRATE_WIDTH - edgeOffset)
                    }
                    -- pick random locatio either above or below door
                    x = xLocations[math.random(2)]
                else
                    x = math.random(xTop + edgeOffset, xBottom - CRATE_WIDTH - edgeOffset)
                end
            end
        end
    else
        -- if a crate location has already been spawned check random (x, y) don't overlap previous crate

    end
    prevLocation.x = x
    prevLocation.y = y
    return x, y
end

--[[
    Helper function to set x crate coordinate to reduce
    bulk in the function above
        
    Params:
        TBC...
    Returns:
        TBC...
]]
function PowerUpSystem:setCrateXCoordinatesHelper()
    
end

--[[
    Helper function to set y crate coordinate to reduce
    bulk in the function above
        
    Params:
        TBC...
    Returns:
        TBC...
]]
function PowerUpSystem:setCrateYCoordinatesHelper(areaDef, doorEdge)
    -- define edge offset to stop crates touching walls
    local edgeOffset = 100
    -- define y boundarys
    local yTop = areaDef.y
    local yCenter = areaDef.y + (areaDef.height * FLOOR_TILE_HEIGHT / 2)
    local yBottom = areaDef.y + (areaDef.height * FLOOR_TILE_HEIGHT)
    -- declare y but don't initialise
    local y
    -- check if the edge has a door
    if doorEdge then
        -- don't include door location in y coordinate
        local yLocations = {
            math.random(areaDef.y, yCenter - CRATE_HEIGHT - edgeOffset),
            math.random(yCenter + CRATE_HEIGHT + edgeOffset, yBottom - CRATE_HEIGHT - edgeOffset)
        }
        -- pick random location either side of the door
        y = yLocations[math.random(2)]
    else
        y = math.random(yTop + edgeOffset, yBottom - CRATE_HEIGHT - edgeOffset)
    end
    return y
end

--[[
    Spawns the 3 keys available in the Map in specific 
    locations

    Params:
        none
    Returns:
        nil
]]
function PowerUpSystem:initialiseKeys()
    for i = 1, #GKeyDefinitions do
        table.insert(self.keys, PowerUp(
            GKeyDefinitions[i].id,
            GKeyDefinitions[i].areaID,
            GKeyDefinitions[i].x,
            GKeyDefinitions[i].y,
            'key',
            GKeyDefinitions[i].quadID
        ))
    end
end

--[[
    Initialises a random number of powerups in the Map and 
    inserts them into the <self.powerups> table

    Params:
        none
    Returns:
        nil
]]
function PowerUpSystem:initialisePowerUps()
    -- set starting area ID - only add powerups to area type MapArea objects
    local startAreaID = 17
    for i = startAreaID, #GMapAreaDefinitions do
        local areaDef = GMapAreaDefinitions[i]
        local areaSize = areaDef.width * areaDef.height
        -- only spawn powerups in the 9 small 8x8 areas (excluding area ID 21)
        if areaSize == 64 and i ~= 21 then
            local numPowerUps = math.random(0, 3)
            local lastPowerUpLocation = {x = nil, y = nil}
            local totalAreaPowerUps = 0
            -- while the system has not populated all of the areas powerups 
            while totalAreaPowerUps ~= numPowerUps do
                local ammo = math.random(2) == 1 and true or false
                local health = math.random(2) == 1 and true or false
                local doubleSpeed = math.random(2) == 1 and true or false
                local invincible = math.random(2) == 1 and true or false
                local oneShotBossKill = math.random(2) == 1 and true or false
                if ammo then
                    self:PowerUpFactory(i, areaDef, lastPowerUpLocation, 'ammo', 'powerup')
                    totalAreaPowerUps = totalAreaPowerUps + 1
                    goto continue
                end
                if health then
                    self:PowerUpFactory(i, areaDef, lastPowerUpLocation, 'health', 'powerup')
                    totalAreaPowerUps = totalAreaPowerUps + 1
                    goto continue
                end
                if doubleSpeed then
                    self:PowerUpFactory(i, areaDef, lastPowerUpLocation, 'doubleSpeed', 'powerup')
                    totalAreaPowerUps = totalAreaPowerUps + 1
                    goto continue
                end
                if invincible then
                    self:PowerUpFactory(i, areaDef, lastPowerUpLocation, 'invincible', 'powerup')
                    totalAreaPowerUps = totalAreaPowerUps + 1
                    goto continue
                end
                if oneShotBossKill then
                    self:PowerUpFactory(i, areaDef, lastPowerUpLocation, 'oneShotBossKill', 'powerup')
                    totalAreaPowerUps = totalAreaPowerUps + 1
                    goto continue
                end
                ::continue::
            end
        end
    end
end

--[[
    Inserts a PowerUp object into the correct powerup table within
    <self.powerups>. Also updates the <lastPowerUpLocation> table

    Params:
        areaID: number - ID for the area type MapArea object 
        areaDef: table - definition of the MapArea object
        lastPowerUpLocation: table - (x, y) of the last PowerUp object
        name: string - name of the PowerUp object
    Returns:
        nil
]]
function PowerUpSystem:PowerUpFactory(areaID, areaDef, lastPowerUpLocation, name, type)
    local x, y = self:setPowerUpCoordinates(areaDef, lastPowerUpLocation)
    table.insert(self.powerups[name], PowerUp(POWERUP_IDS[name], areaID, x, y, type))
    lastPowerUpLocation.x = x
    lastPowerUpLocation.y = y
end

--[[
    Set the (x, y) coordinates for a powerup. The powerups
    cannot overlap each other and must not block doorways

    Params:
        areaDef: table - definition of the MapArea object
        prevRef: table - contains the (x, y) of the last powerup for this area 
    Returns:
        table: (x, y) cooridinates of the powerup
]]
function PowerUpSystem:setPowerUpCoordinates(areaDef, prevRef)
    local x, y
    local edgeOffset = 100
    -- set edge opposite door to place powerups against
    local edge
    if areaDef.doors.L then edge = 'R' end
    if areaDef.doors.T then edge = 'B' end
    if areaDef.doors.R then edge = 'L' end
    if areaDef.doors.B then edge = 'T' end
    -- set (x, y) for vertical wall edges
    if edge == 'L' or edge == 'R' then
        x = edge == 'L' and areaDef.x + edgeOffset or (areaDef.x + areaDef.width * FLOOR_TILE_WIDTH) - POWERUP_WIDTH - edgeOffset
        y = prevRef.y and prevRef.y + CRATE_HEIGHT or areaDef.y + edgeOffset
    else
    -- set (x, y) for horizontal wall edges
        y = edge == 'T' and areaDef.y + edgeOffset or (areaDef.y + areaDef.height * FLOOR_TILE_HEIGHT) - POWERUP_HEIGHT - edgeOffset
        x = prevRef.x and prevRef.x + CRATE_WIDTH or areaDef.x + edgeOffset
    end
    return x, y
end

--[[
    Handles a key collision by removing the key from memory 
    and then adding the key to the Player objects keys table

    Params:
        key: table - key type PowerUp object to detect
    Returns:
        nil
]]
function PowerUpSystem:handleKeyCollision(key)
    if key.id == DOOR_IDS['red'] then
        self.player.keys['red'] = true
    end
    if key.id == DOOR_IDS['blue'] then
        self.player.keys['blue'] = true
    end
    if key.id == DOOR_IDS['green'] then
        self.player.keys['green'] = true
    end
    local keyIndex
    for i = 1, #self.keys do
        if self.keys[i].id == key.id then
            keyIndex = i
            break
        end
    end
    table.remove(self.keys, keyIndex)
end