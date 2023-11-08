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
        ['oneShotBossKill'] = {},
        ['keys'] = {}
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
function PowerUpSystem:initialiseAll()
    self:initialiseCrates()
    self:initialiseKeys()
    -- self:initialisePowerUps()
end

--[[
    Spawns crates all over the map in random locations

    Params:
        none
    Returns:
        nil
]]
function PowerUpSystem:initialiseCrates()
    
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