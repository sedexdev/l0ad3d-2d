--[[
    EnemySystem: class

    Description:
        An enemy system is responsible for spawning and removing
        enemy (Entity) objects from the Map. As enemies are killed
        they are replaced with blood splatter effects which fade
        over time, and enemies are replaced as the Player moves around
        the Map
]]

EnemySystem = Class{__includes = Observer}

--[[
    EnemySystem constructor. Creates a store for the doors in the
    system, tracks locked doors, and knows which door the Player
    is currently interacting with 

    Params:
        player:           table       - Player object
        gruntSpriteBatch: SpriteBatch - collection of Grunt Entity quads
        systemManager:  table         - SystemManager object
    Returns:
        nil
]]
function EnemySystem:init(gruntSpriteBatch, systemManager)
    self.gruntSpriteBatch = gruntSpriteBatch
    self.systemManager = systemManager
    self.playerX = PLAYER_STARTING_X
    self.playerY = PLAYER_STARTING_Y
    self.currentAreaID = START_AREA_ID
    self.grunts = {}
    self.turrets = {}
    self.boss = nil
    self.gruntID = 1
end

--[[
    EnemySystem update function. Only updates Grunt Entity
    objects in the current and adjacent areas as defined in
    <definitions.lua:GAreaAdjacencyDefinitions>

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function EnemySystem:update(dt)
    for _, grunt in pairs(self.grunts) do
        for _, adjacentID in pairs(GAreaAdjacencyDefinitions[self.currentAreaID]) do
            if grunt.areaID == self.currentAreaID or grunt.areaID == adjacentID then
                grunt:update(dt)
                -- jump out of loop to save processing further areas
                goto continue
            end
        end
        ::continue::
    end
    for _, turret in pairs(self.turrets) do
        turret:update(dt)
    end
    if self.boss then
        self.boss:update(dt)
    end
end

--[[
    EnemySystem render function. Only renders Grunt Entity
    objects in the current and adjacent areas as defined in
    <definitions.lua:GAreaAdjacencyDefinitions>

    Params:
        none
    Returns:
        none
]]
function EnemySystem:render()
    for _, grunt in pairs(self.grunts) do
        for _, adjacentID in pairs(GAreaAdjacencyDefinitions[self.currentAreaID]) do
            if grunt.areaID == self.currentAreaID or grunt.areaID == adjacentID then
                grunt:render()
                goto continue
            end
        end
        ::continue::
    end
    for _, turret in pairs(self.turrets) do
        turret:render()
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
        self.playerX = data.x
        self.playerY = data.y
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
function EnemySystem:spawn(areas)
    for _, area in pairs(areas) do
        if self:getGruntCount(area.id) == 0 then
            local startCount, endCount = self:getGruntLimits(area)
            local numGrunts = math.random(startCount, endCount)
            self:spawnGrunts(numGrunts, area)
        end
    end
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
        local grunt = Grunt(self.gruntID, GAnimationDefintions['grunt'], GGruntDefinition)
        -- set ID
        -- set random (x, y) within the area
        grunt.x = math.random(area.x, area.x + (area.width * FLOOR_TILE_WIDTH) - ENTITY_WIDTH)
        grunt.y = math.random(area.y, area.y + (area.height * FLOOR_TILE_HEIGHT) - ENTITY_HEIGHT)
        -- give Grunts different speeds
        grunt.dx = math.random(200, 300)
        grunt.dy = grunt.dx
        -- set random starting direction
        grunt.direction = DIRECTIONS[math.random(1, 8)]
        grunt.areaID = area.id
        grunt.stateMachine = StateMachine {
            ['idle'] = function () return GruntIdleState(area, grunt, self.gruntSpriteBatch, self.systemManager.collisionSystem, self) end,
            ['rushing'] = function () return GruntRushingState(area, grunt, self.gruntSpriteBatch, self.systemManager.player, self.systemManager.collisionSystem, self) end,
            ['attacking'] = function () return GruntAttackingState(grunt, self.gruntSpriteBatch, self.systemManager.player) end,
        }
        grunt.stateMachine:change('idle')
        table.insert(self.grunts, grunt)
        self.gruntID = self.gruntID + 1
    end
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
    self.boss = Boss(GAnimationDefintions['boss'], GBossDefinition)
    -- set random starting direction
    self.boss.direction = DIRECTIONS[math.random(1, 8)]
    self.boss.stateMachine = StateMachine {
        ['idle'] = function () return BossIdleState(area, self.boss, self.systemManager.collisionSystem, self) end,
        ['rushing'] = function () return BossRushingState(area, self.boss, self.systemManager.player, self.systemManager.collisionSystem, self) end
    }
    self.boss.stateMachine:change('idle')
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

-- ========================== GET ENEMY OBJECTS ==========================

--[[
    Gets a count of the number of grunt type Entity in
    an area

    Params:
        areaID: number - ID of th current area
    Returns:
        number: number of grunts in the area
]]
function EnemySystem:getGruntCount(areaID)
    local count = 0
    for _, grunt in pairs(self.grunts) do
        if grunt.areaID == areaID then
            count = count + 1
        end
    end
    return count
end

--[[
    Gets all the grunt type Entity objects in the
    current area

    Params:
        none
    Returns:
        nil
]]
function EnemySystem:getAreaGrunts()
    local grunts = {}
    for _, grunt in pairs(self.grunts) do
        if grunt.areaID == self.currentAreaID then
            table.insert(grunts, grunt)
        end
    end
    return grunts
end

-- ========================== REMOVE ENEMY OBJECTS ==========================

--[[
    Removes a grunt after its <isDead> attribute is set to true

    Params:
        gruntID
    Returns:
        nil
]]
function EnemySystem:removeGrunt(gruntID)
    local index
    for i = 1, #self.grunts do
        if self.grunts[i].id == gruntID then
            index = i
        end
    end
    if index then table.remove(self.grunts, index) end
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
