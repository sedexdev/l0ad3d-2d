--[[
    EnemySystem: class

    Includes: Observer - parent class for observers

    Description:
        An enemy system is responsible for spawning and removing
        enemy (Entity) objects from the Map. As enemies are killed
        they are replaced with blood splatter effects which fade
        over time, and enemies are replaced as the Player moves around
        the Map
]]

EnemySystem = Class{__includes = Observer}

--[[
    EnemySystem constructor. Initialises and tracks enemy
    Entity objects throughout each MapArea location

    Params:
        player:           table       - Player object
        gruntSpriteBatch: SpriteBatch - collection of Grunt Entity quads
        systemManager:    table       - SystemManager object
    Returns:
        nil
]]
function EnemySystem:init(gruntSpriteBatch, systemManager)
    self.gruntSpriteBatch = gruntSpriteBatch
    self.systemManager    = systemManager
    self.playerX          = PLAYER_STARTING_X
    self.playerY          = PLAYER_STARTING_Y
    self.currentAreaID    = START_AREA_ID
    -- boss tracker flag and object
    self.bossSpawned      = false
    self.boss             = nil
    -- track IDs for spawned enemies
    self.enemyIDs = {
        gruntID  = 1,
        turretID = 1
    }
    -- uses area IDs as keys
    self.enemies = {}
    -- populate keys and sub-tables in self.enemies
    for i = 1, #GMapAreaDefinitions do
        self.enemies[i]         = {}
        self.enemies[i].grunts  = {}
        self.enemies[i].turrets = {}
    end
end

--[[
    EnemySystem update function. Updates Entity objects in the 
    current and adjacent areas as defined in
    <definitions.lua:GAreaAdjacencyDefinitions>

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function EnemySystem:update(dt)
    for i = START_AREA_ID, #GMapAreaDefinitions do
        for _, grunt in pairs(self.enemies[i].grunts) do
            grunt:update(dt)
        end
    end
    for _, turret in pairs(self.enemies[self.currentAreaID].turrets) do
        turret:update(dt)
    end
    if self.boss then
        self.boss:update(dt)
    end
end

--[[
    EnemySystem render function. Renders Entity objects in the 
    current and adjacent areas as defined in
    <definitions.lua:GAreaAdjacencyDefinitions>

    Params:
        none
    Returns:
        none
]]
function EnemySystem:render()
    for i = START_AREA_ID, #GMapAreaDefinitions do
        for _, grunt in pairs(self.enemies[i].grunts) do
            grunt:render()
        end
    end
    for i = START_AREA_ID, #GMapAreaDefinitions do
        if GMapAreaDefinitions[i].turrets then
            for _, turret in pairs(self.enemies[i].turrets) do
                turret:render()
            end
        end
    end
    if self.boss then
        self.boss:render()
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
function EnemySystem:message(data)
    if data.source == 'PlayerWalkingState' then
        self.playerX       = data.x
        self.playerY       = data.y
        self.currentAreaID = data.areaID
    end
end

-- ========================== SPAWNING ==========================

--[[
    Spawns all enemy objects that are present at the beginning
    of the game

    Params:
        areas: table - MapArea objects table
    Returns:
        nil
]]
function EnemySystem:spawn(area)
    local startCount, endCount = self:getGruntLimits(area)
    local numGrunts = math.random(startCount, endCount)
    self:spawnGrunts(numGrunts, area)
end

--[[
    Gets a startCount number and an endCount number to use to then
    generate a random number of Grunts dependent on area size

    Params:
        area: table - area to calculate size of
    Returns
        number: start number
        number: end number
]]
function EnemySystem:getGruntLimits(area)
    local roomArea = area.width * area.height
    local startCount, endCount
    if roomArea < 64 then
        startCount = 2
        endCount = 3
    elseif roomArea == 64 then
        startCount = 4
        endCount = 8
    else
        startCount = 9
        endCount = 12
    end
    return startCount, endCount
end

--[[
    Spawns Grunt Entity objects and inserts them into the 
    <self.grunts> table

    Params:
        numGrunts: number - number of Grunt Entity objects to spawn
        area:      table  - MapArea object the Grunts will be spawned in
    Returns:
        nil
]]
function EnemySystem:spawnGrunts(numGrunts, area)
    for _ = 1, numGrunts do
        local grunt        = Grunt(self.enemyIDs.gruntID, GAnimationDefintions['grunt'], GGruntDefinition)
        -- set ID
        -- set random (x, y) within the area
        grunt.x            = math.random(area.x, area.x + (area.width * FLOOR_TILE_WIDTH) - ENTITY_WIDTH)
        grunt.y            = math.random(area.y, area.y + (area.height * FLOOR_TILE_HEIGHT) - ENTITY_HEIGHT)
        -- give Grunts different speeds
        grunt.dx           = math.random(200, 300)
        grunt.dy           = grunt.dx
        -- set random starting direction
        grunt.direction    = DIRECTIONS[math.random(1, 8)]
        grunt.areaID       = area.id
        grunt.stateMachine = StateMachine {
            ['idle']      = function () return GruntIdleState(area, grunt, self.gruntSpriteBatch, self.systemManager) end,
            ['rushing']   = function () return GruntRushingState(area, grunt, self.gruntSpriteBatch, self.systemManager) end,
            ['attacking'] = function () return GruntAttackingState(area, grunt, self.gruntSpriteBatch, self.systemManager) end,
        }
        grunt.stateMachine:change('idle')
        table.insert(self.enemies[area.id].grunts, grunt)
        self.enemyIDs.gruntID = self.enemyIDs.gruntID + 1
    end
end

--[[
    Spawns Turret Entity objects in the the defined areas of the
    Map that have them

    Params:
        ...
    Returns:
        nil
]]
function EnemySystem:spawnTurrets()
    for i = 1, #GMapAreaDefinitions do
        local areaDef = GMapAreaDefinitions[i]
        local turrets = areaDef.turrets
        if turrets ~= nil then
            if turrets == 2 then
                self:spawn2Turrets(i, areaDef)
            end
            if turrets == 4 then
                self:spawn4Turrets(i, areaDef)
            end
        end
    end
end

--[[
    Spawns 2 turrets in the MapArea location defined by
    GMapAreaDefinitions[i]

    Params:
        i:       number - current area index
        areaDef: number - definition of the MapArea object at index i
    Returns:
        nil
]]
function EnemySystem:spawn2Turrets(i, areaDef)
    -- spawn vertically in the area
    local centre   = areaDef.y + (areaDef.height * FLOOR_TILE_HEIGHT) / 2
    local xOffset  = areaDef.x + (areaDef.width * FLOOR_TILE_WIDTH) / 2 - (TURRET_WIDTH * 2.5 / 2)
    local yOffsets = {
        [1] = centre - 500 - (TURRET_HEIGHT * 2.5 / 2),
        [2] = centre + 500 - (TURRET_HEIGHT * 2.5 / 2)
    }
    for j = 1, 2 do
        self:spawnTurretsHelper(xOffset, yOffsets[j], i)
    end
end

--[[
    Spawns 4 turrets in the MapArea location defined by
    GMapAreaDefinitions[i]

    Params:
        i:       number - current area index
        areaDef: number - definition of the MapArea object at index i
    Returns:
        nil
]]
function EnemySystem:spawn4Turrets(i, areaDef)
    -- spawn vertically in the area
    local centre   = areaDef.y + (areaDef.height * FLOOR_TILE_HEIGHT) / 2
    local xOffsets = {
        [1] = areaDef.x + (areaDef.width / 4 * FLOOR_TILE_WIDTH) - (TURRET_WIDTH * 2.5 / 2),
        [2] = areaDef.x + ((areaDef.width / 4 * 3) * FLOOR_TILE_WIDTH) - (TURRET_WIDTH * 2.5 / 2)
    }
    local yOffsets = {
        [1] = centre - 600 - (TURRET_HEIGHT * 2.5 / 2),
        [2] = centre + 600 - (TURRET_HEIGHT * 2.5 / 2)
    }
    local coordinates = {
        [1] = {x = xOffsets[1], y = yOffsets[1]},
        [2] = {x = xOffsets[1], y = yOffsets[2]},
        [3] = {x = xOffsets[2], y = yOffsets[1]},
        [4] = {x = xOffsets[2], y = yOffsets[2]},
    }
    for j = 1, 4 do
        self:spawnTurretsHelper(coordinates[j].x, coordinates[j].y, i)
    end
end

--[[
    Helper function to instantiate and insert new Turret objects
    in the <self.turrets> table

    Params:
        x:      number - x coordinate  
        y:      number - y coordinate
        areaID: number - area ID
    Returns:
        nil
]]
function EnemySystem:spawnTurretsHelper(x, y, areaID)
    local turret        = Turret(self.enemyIDs.turretID, GAnimationDefintions['turret'], GTurretDefinition)
    turret.x            = x
    turret.y            = y
    turret.areaID       = areaID
    turret.direction    = DIRECTIONS[math.random(1, 8)]
    turret.stateMachine = StateMachine {
        ['idle']      = function () return TurretIdleState(turret, self.systemManager.player) end,
        ['attacking'] = function () return TurretAttackingState(turret, self.systemManager.player) end
    }
    turret.stateMachine:change('idle')
    table.insert(self.enemies[areaID].turrets, turret)
    self.enemyIDs.turretID = self.enemyIDs.turretID + 1
end

--[[
    Spawns the Boss Entity object when the Player enters the
    corridor type MapArea object with ID == 4 

    Params:
        area: table - MapArea object to spawn the Boss in
    Returns:
        nil
]]
function EnemySystem:spawnBoss(area)
    self.boss              = Boss(GAnimationDefintions['boss'], GBossDefinition)
    -- set random starting direction
    self.boss.direction    = DIRECTIONS[math.random(1, 8)]
    self.boss.stateMachine = StateMachine {
        ['idle']    = function () return BossIdleState(area, self.boss, self.systemManager) end,
        ['rushing'] = function () return BossRushingState(area, self.boss, self.systemManager) end
    }
    self.boss.stateMachine:change('idle')
end

-- ========================== ENEMY PROXIMITY ==========================

--[[
    Checks the Player's proximity to an enemy Entity object.
    If the Player falls within proximity the enemy goes into
    an attack velocity towards the Player before attacking

    Params:
        entity: table - Entity object to check proximity to Player
    Returns:
        boolean: true if in proximity
]]
function EnemySystem:checkProximity(entity)
    if (self.playerX > entity.x + entity.width + ENTITY_PROXIMITY) or (entity.x - ENTITY_PROXIMITY > self.playerX + ENTITY_WIDTH) then
        return false
    end
    if (self.playerY > entity.y + entity.height + ENTITY_PROXIMITY) or (entity.y - ENTITY_PROXIMITY > self.playerY + ENTITY_HEIGHT) then
        return false
    end
    return true
end
