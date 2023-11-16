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
    for _, adjacentID in pairs(GAreaAdjacencyDefinitions[areaID]) do
        for _, grunt in pairs(self.grunts) do
            if grunt.areaID == areaID or grunt.areaID == adjacentID then
                grunt:update(dt)
            end
        end
    end
    for _, turret in pairs(self.turrets) do
        turret:update(dt)
    end
    self.boss:update(dt)
    -- set enemy door locations
    self:setGruntLocation()
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
    for _, adjacentID in pairs(GAreaAdjacencyDefinitions[areaID]) do
        for _, grunt in pairs(self.grunts) do
            if grunt.areaID == areaID or grunt.areaID == adjacentID then
                grunt:render()
            end
        end
    end
    for _, turret in pairs(self.turrets) do
        turret:render()
    end
    self.boss:render()
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
    for _, adjacentID in pairs(GAreaAdjacencyDefinitions[areaID]) do
        for _, grunt in pairs(self.grunts) do
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
        local startCount, endCount, numGrunts
        if area.type == 'corridor' then
            startCount = 0
            endCount = 1
        else
            local roomArea = area.width * area.height
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
        end
        numGrunts = math.random(startCount, endCount)
        -- self:spawnGrunts(numGrunts, area)
        -- spawn the boss in area 27
        if area.id == 27 then
            self.boss = Boss(GAnimationDefintions['boss'], GBossDefinition)
            -- set random starting direction
            self.boss.direction = DIRECTIONS[math.random(1, 8)]
            self:setInitialVelocity(self.boss)
            self.boss.stateMachine = StateMachine {
                ['walking'] = function () return BossWalkingState(area, self.boss, self.player, self.collisionSystem, self) end
            }
            self.boss.stateMachine:change('walking')
        end
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
        grunt.x = math.random(area.x, area.x + (area.width * FLOOR_TILE_WIDTH) - GRUNT_WIDTH)
        grunt.y = math.random(area.y, area.y + (area.height * FLOOR_TILE_HEIGHT) - GRUNT_HEIGHT)
        -- give Grunts different speeds
        grunt.dx = math.random(15, 25)
        grunt.dy = grunt.dx
        -- set random starting direction
        grunt.direction = DIRECTIONS[math.random(1, 8)]
        self:setInitialVelocity(grunt)
        grunt.areaID = area.id
        grunt.stateMachine = StateMachine {
            ['walking'] = function () return GruntWalkingState(area, grunt, self.player, self.gruntSpriteBatch, self.collisionSystem, self) end,
            ['attacking'] = function () return GruntAttackingState(grunt, self.player, self.gruntSpriteBatch) end,
        }
        grunt.stateMachine:change('walking')
        table.insert(self.grunts, grunt)
        self.gruntID = self.gruntID + 1
    end
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

-- ========================== ENEMY VELOCITY ==========================

--[[
    Moves any Entity in a random direction while the Player
    is not in the same area

    Params:
        entity: table - Entity object to update
    Returns:
        nil
]]
function EnemySystem:setInitialVelocity(entity)
    if entity.direction == 'north' then
        entity.y = entity.y - entity.dy * TEMP_DT
    elseif entity.direction == 'east' then
        entity.x = entity.x + entity.dx * TEMP_DT
    elseif entity.direction == 'south' then
        entity.y = entity.y + entity.dy * TEMP_DT
    elseif entity.direction == 'west' then
        entity.x = entity.x - entity.dx * TEMP_DT
    elseif entity.direction == 'north-east' then
        entity.y = entity.y - entity.dy * TEMP_DT
        entity.x = entity.x + entity.dx * TEMP_DT
    elseif entity.direction == 'south-east' then
        entity.y = entity.y + entity.dy * TEMP_DT
        entity.x = entity.x + entity.dx * TEMP_DT
    elseif entity.direction == 'south-west' then
        entity.y = entity.y + entity.dy * TEMP_DT
        entity.x = entity.x - entity.dx * TEMP_DT
    elseif entity.direction == 'north-west' then
        entity.y = entity.y - entity.dy * TEMP_DT
        entity.x = entity.x - entity.dx * TEMP_DT
    end
end

--[[
    Updates the velocity and direction of the Boss
    Entity object

    TODO: make the boss circle the player, not run directly up to them

    Params:
        boss: table - Boss Entity object 
        player: table - Player Entity object
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function EnemySystem:updateBossVelocity(boss, player, dt)
    -- determine the direction the player is relative to the boss
    -- make boss walk towards the player
    if (player.x < boss.x) and (player.y < boss.y) then
        -- boss is SOUTH-EAST of player
        boss.direction = 'north-west'
        boss.x = boss.x - boss.dx * dt
        boss.y = boss.y - boss.dy * dt
    end
    if (player.x < boss.x) and (player.y > boss.y) then
        -- boss is NORTH-EAST of player
        boss.direction = 'south-west'
        boss.x = boss.x - boss.dx * dt
        boss.y = boss.y + boss.dy * dt
    end
    if (player.x > boss.x) and (player.y < boss.y) then
        -- boss is SOUTH-WEST of player
        boss.direction = 'north-east'
        boss.x = boss.x + boss.dx * dt
        boss.y = boss.y - boss.dy * dt
    end
    if (player.x > boss.x) and (player.y > boss.y) then
        -- boss is NORTH-WEST of player
        boss.direction = 'south-east'
        boss.x = boss.x + boss.dx * dt
        boss.y = boss.y + boss.dy * dt
    end
    -- abs the value to find if the player is on the same vertical or horizontal axis
    if (player.x < boss.x) and (math.abs(boss.y - player.y) <= ENTITY_PROXIMITY) then
        -- boss is EAST of player
        boss.direction = 'west'
        boss.x = boss.x - boss.dx * dt
    end
    if (player.x > boss.x) and (math.abs(boss.y - player.y) <= ENTITY_PROXIMITY) then
        -- boss is WEST of player
        boss.direction = 'east'
        boss.x = boss.x + boss.dx * dt
    end
    if (math.abs(boss.x - player.x) <= ENTITY_PROXIMITY) and (player.y < boss.y) then
        -- boss is SOUTH of player
        boss.direction = 'north'
        boss.y = boss.y - boss.dy * dt
    end
    if (math.abs(boss.x - player.x) <= ENTITY_PROXIMITY) and (player.y > boss.y) then
        -- boss is NORTH of player
        boss.direction = 'south'
        boss.y = boss.y + boss.dy * dt
    end
end

--[[
    Updates the velocity and direction of a Grunt
    Entity object

    Params:
        grunt: table - Grunt Entity object 
        player: table - Player Entity object
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function EnemySystem:updateGruntVelocity(grunt, player, dt)
    -- determine the direction the player is relative to the grunt
    if (player.x < grunt.x) and (player.y < grunt.y) then
        -- grunt is SOUTH-EAST of player
        grunt.direction = 'north-west'
        grunt.x = grunt.x - grunt.dx * dt
        grunt.y = grunt.y - grunt.dy * dt
    end
    if (player.x < grunt.x) and (player.y > grunt.y) then
        -- grunt is NORTH-EAST of player
        grunt.direction = 'south-west'
        grunt.x = grunt.x - grunt.dx * dt
        grunt.y = grunt.y + grunt.dy * dt
    end
    if (player.x > grunt.x) and (player.y < grunt.y) then
        -- grunt is SOUTH-WEST of player
        grunt.direction = 'north-east'
        grunt.x = grunt.x + grunt.dx * dt
        grunt.y = grunt.y - grunt.dy * dt
    end
    if (player.x > grunt.x) and (player.y > grunt.y) then
        -- grunt is NORTH-WEST of player
        grunt.direction = 'south-east'
        grunt.x = grunt.x + grunt.dx * dt
        grunt.y = grunt.y + grunt.dy * dt
    end
    -- abs the value to find if the player is on the same vertical or horizontal axis
    if (player.x < grunt.x) and (math.abs(grunt.y - player.y) <= ENTITY_PROXIMITY) then
        -- grunt is EAST of player
        grunt.direction = 'west'
        grunt.x = grunt.x - grunt.dx * dt
    end
    if (player.x > grunt.x) and (math.abs(grunt.y - player.y) <= ENTITY_PROXIMITY) then
        -- grunt is WEST of player
        grunt.direction = 'east'
        grunt.x = grunt.x + grunt.dx * dt
    end
    if (math.abs(grunt.x - player.x) <= ENTITY_PROXIMITY) and (player.y < grunt.y) then
        -- grunt is SOUTH of player
        grunt.direction = 'north'
        grunt.y = grunt.y - grunt.dy * dt
    end
    if (math.abs(grunt.x - player.x) <= ENTITY_PROXIMITY) and (player.y > grunt.y) then
        -- grunt is NORTH of player
        grunt.direction = 'south'
        grunt.y = grunt.y + grunt.dy * dt
    end
end

--[[
    Updates the (x, y) location of grunt type Entity objects in 
    relation to all doors nearby as defined in GMapAreaDefinitions

    Params:
        none
    Returns:
        nil
]]
function EnemySystem:setGruntLocation()
    -- use self.player.currentArea.id for area ID
    local areaID = self.player.currentArea.id
    for _, adjacentID in pairs(GAreaAdjacencyDefinitions[areaID]) do
        for _, grunt in pairs(self.grunts) do
            if grunt.areaID == areaID or grunt.areaID == adjacentID then
                local type = GMapAreaDefinitions[areaID].type
                if type == 'area' then
                    -- set Player location to the side WITHIN the area
                    for _, door in pairs(self.doorSystem:getAreaDoors(areaID)) do
                        -- if the area IDs do not match then this door is in an adjacent area
                        if door.areaID ~= grunt.areaID then
                            -- set Entity on the current area side of the door
                            self.doorSystem:setMatchingLocation(door, grunt)
                        else
                            self.doorSystem:setOppositeLocation(door, grunt)
                        end
                    end
                else
                    -- use area.joins to get door adjacencies for corridors
                    local joins = GMapAreaDefinitions[areaID].joins
                    -- set Player location to the side OUTSIDE the joined areas
                    for _, join in pairs(joins) do
                        self.doorSystem:setJoinLocation(join, grunt)
                    end
                    -- check if this corridor has door defined
                    local doors = GMapAreaDefinitions[areaID].doors
                    if doors then
                        for _, door in pairs(self.doorSystem:getAreaDoors(areaID)) do
                            self.doorSystem:setOppositeLocation(door, grunt)
                        end
                    end
                end
            end
        end
    end
end
