--[[
    EnemySystem: class

    TODO: respawn enemies as the game goes on
          implement enemy proximity to only move towards Player in a certain range

    Description:
        An enemy system is responsible for spawning and removing
        enemy (Entity) objects from the Map. As enemies are killed
        they are replaced with blood splatter effects which fade
        over time, and enemies are replaced as the Player moves around
        the Map
]]

EnemySystem = Class{}

--[[
    EnemySystem constructor. Creates a store for the doors in the
    system, tracks locked doors, and knows which door the Player
    is currently interacting with 

    Params:
        player: table - Player object
        gruntSpriteBatch: SpriteBatch - collection of Grunt Entity quads
        collisionSystem: table - collisionSystem object
        doorSystem: table - DoorSystem object
    Returns:
        nil
]]
function EnemySystem:init(player, gruntSpriteBatch, collisionSystem, doorSystem)
    self.player = player
    self.gruntSpriteBatch = gruntSpriteBatch
    self.collisionSystem = collisionSystem
    self.doorSystem = doorSystem
    self.grunts = {}
    self.turrets = {}
    self.boss = nil
    self.gruntID = 1
end

--[[
    EnemySystem update function. Only updates Grunt Entity
    objects in the current and adjacent areas as defined in
    <definitions.lua:GAreaAdjacencyDefinitions>

    TODO: fix rendering issue when multiple Grunts update at once

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function EnemySystem:update(dt)
    local areaID = self.player.currentArea.id
    for _, grunt in pairs(self.grunts) do
        for _, adjacentID in pairs(GAreaAdjacencyDefinitions[areaID]) do
            if grunt.areaID == areaID or grunt.areaID == adjacentID then
                grunt:update(dt)
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
    local areaID = self.player.currentArea.id
    for _, grunt in pairs(self.grunts) do
        for _, adjacentID in pairs(GAreaAdjacencyDefinitions[areaID]) do
            if grunt.areaID == areaID or grunt.areaID == adjacentID then
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

-- ========================== GET ENEMY OBJECTS ==========================

--[[
    Gets all Grunt Entity objects in the current and adjacent 
    areas as defined in <definitions.lua:GAreaAdjacencyDefinitions>

    Params:
        areaID: number - ID of th current area
    Returns:
        table: Grunt Entity object list
]]
function EnemySystem:getGrunts(areaID)
    local gruntObjects = {}
    for _, grunt in pairs(self.grunts) do
        for _, adjacentID in pairs(GAreaAdjacencyDefinitions[areaID]) do
            if grunt.areaID == areaID or grunt.areaID == adjacentID then
                table.insert(gruntObjects, grunt)
            end
        end
    end
    return gruntObjects
end

-- ========================== SPAWNING ==========================

--[[
    Spawns all enemy objects that are present at the beginning
    of the game. Enemy objects include Grunt and Boss Entity
    objects and gun turrets

    Params:
        areas: table - MapArea objects table
    Returns:
        nil
]]
function EnemySystem:spawn(areas)
    for _, area in pairs(areas) do
        local roomArea = area.width * area.height
        local startCount, endCount, numGrunts
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
        numGrunts = math.random(startCount, endCount)
        self:spawnGrunts(numGrunts, area)
    end
end

--[[
    Spawns Grunt Entity objects and inserts them into the 
    <self.grunts> table

    Params:
        numGrunts: number - number of Grunt Entity objects to spawn
        area: table - MapArea object the Grunts will be spawned in
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
            ['idle'] = function () return GruntIdleState(area, grunt, self.player, self.gruntSpriteBatch, self.collisionSystem, self) end,
            ['rushing'] = function () return GruntRushingState(area, grunt, self.player, self.gruntSpriteBatch, self.collisionSystem, self) end,
            ['attacking'] = function () return GruntAttackingState(grunt, self.player, self.gruntSpriteBatch) end,
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
        ['idle'] = function () return BossIdleState(area, self.boss, self.player, self.collisionSystem, self) end,
        ['rushing'] = function () return BossRushingState(area, self.boss, self.player, self.collisionSystem, self) end
    }
    self.boss.stateMachine:change('idle')
end

--[[
    Spawns new enemy objects across the Map as enemies are 
    killed

    Params:
        none
    Returns:
        nil
]]
function EnemySystem:respawn()
    
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
    if (self.player.x > entity.x + entity.width + ENTITY_PROXIMITY) or (entity.x - ENTITY_PROXIMITY > self.player.x + CHARACTER_WIDTH) then
        return false
    end
    if (self.player.y > entity.y + entity.height + ENTITY_PROXIMITY) or (entity.y - ENTITY_PROXIMITY > self.player.y + CHARACTER_HEIGHT) then
        return false
    end
    return true
end