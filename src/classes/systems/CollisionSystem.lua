--[[
    CollisionSystem: class

    Includes: Observer - parent class for observers

    Description:
        The collision system checks for and handles collisions for Entity
        objects (Player, Grunt, Boss) and also PowerUp objects within 
        the Map. Having a separate system for checking collisions reduces 
        bulk in individual classes and centralises collision behaviour to 
        make it more managable
]]

CollisionSystem = Class{__includes = Observer}

--[[
    CollisionSystem constructor

    Params:
        systemManager: table - SystemManager object
    Returns:
        nil
]]
function CollisionSystem:init(systemManager)
    self.systemManager = systemManager
    self.playerX       = PLAYER_STARTING_X
    self.playerY       = PLAYER_STARTING_Y
    self.currentAreaID = START_AREA_ID
end

--[[
    Observer message function implementation. Updates the current
    (x, y) coordinates of the Player

    Params:
        data: table - Player object current state
    Returns;
        nil
]]
function CollisionSystem:message(data)
    if data.source == 'PlayerWalkingState' then
        self.playerX       = data.x
        self.playerY       = data.y
        self.currentAreaID = data.areaID
    end
end

-- ========================== WALL COLLISIONS ==========================

--[[
    Check if an Entity has hit the wall and detect a wall collision
    if they have. A wall collision is defined as the (x, y) Entity object
    coordinates exceeding the boundary of the current area they are in

    Params:
        area:   table - MapArea object
        entity: table - Entity object (Player | Grunt | Boss)
    Returns:
        table: true if a collision is detected, false if not, along with the edge
]]
function CollisionSystem:checkWallCollision(area, entity)
    -- booleans for stating whether Player object has hit the area boundary
    local conditions = {
        leftCollision   = entity.x < area.x - WALL_OFFSET,
        rightCollision  = entity.x + ENTITY_WIDTH > area.x + (area.width * FLOOR_TILE_WIDTH) + WALL_OFFSET,
        topCollision    = entity.y < area.y - WALL_OFFSET,
        bottomCollision = entity.y + ENTITY_HEIGHT > area.y + (area.height * FLOOR_TILE_HEIGHT) + WALL_OFFSET,
        leftHorizontal  = area.x + (area.width * FLOOR_TILE_WIDTH / 2) - H_DOOR_WIDTH,
        rightHorizontal = area.x + (area.width * FLOOR_TILE_WIDTH / 2) + H_DOOR_WIDTH,
        topVertical     = area.y + (area.height * FLOOR_TILE_HEIGHT / 2) - V_DOOR_HEIGHT,
        bottomVertical  = area.y + (area.height * FLOOR_TILE_HEIGHT / 2) + V_DOOR_HEIGHT
    }
    -- set Player (x, y) comparison
    conditions['horizontalDoorway'] = self.playerX + ENTITY_CORRECTION > conditions.leftHorizontal and (self.playerX + ENTITY_WIDTH) - ENTITY_CORRECTION < conditions.rightHorizontal
    conditions['verticalDoorway']   = self.playerY + ENTITY_CORRECTION > conditions.topVertical and (self.playerY + ENTITY_HEIGHT) - ENTITY_CORRECTION < conditions.bottomVertical
    -- if the area is a corridor then allow the player to pass through each end
    if area.type == 'corridor' then
        return self:corridorBoundary(area, conditions)
    else
        return self:areaBoundary(area, conditions, entity)
    end
end

-- ========================== AREAS ==========================

--[[
    Detect a collision on the walls of an area type MapArea object.
    Collisions can occur on all 4 walls and on multiple walls at the
    same time when running into a corner    

    Params:
        area:       table - MapArea object for the corridor
        conditions: table - collision detection conditions
        entity:     table - Entity object to check collision for
    Returns:
        table: collision status update - collision detected and where 
]]
function CollisionSystem:areaBoundary(area, conditions, entity)
    -- default values for detection - no collision
    local collisionDef = {detected = false, edge = nil}
    -- check if the entity is going to pass through an area doorway
    if entity.type == 'character' then
        for _, door in pairs(self.systemManager.doorSystem:getAreaDoors(area.id)) do
            if self:detectAreaDoorway(area, door, conditions) then
                goto returnFalse
            end
        end
    end
    -- check for single wall collisions first
    if conditions.leftCollision then
        collisionDef = {detected = true, edge = 'L'}
    end
    if conditions.rightCollision then
        collisionDef = {detected = true, edge = 'R'}
    end
    if conditions.topCollision then
        collisionDef = {detected = true, edge = 'T'}
    end
    if conditions.bottomCollision then
        collisionDef = {detected = true, edge = 'B'}
    end
    -- then check for collisions with 2 walls at once to avoid corner escape bug
    if conditions.leftCollision and conditions.topCollision then
        collisionDef = {detected = true, edge = 'LT'}
    end
    if conditions.rightCollision and conditions.topCollision then
        collisionDef = {detected = true, edge = 'RT'}
    end
    if conditions.leftCollision and conditions.bottomCollision then
        collisionDef = {detected = true, edge = 'LB'}
    end
    if conditions.rightCollision and conditions.bottomCollision then
        collisionDef = {detected = true, edge = 'RB'}
    end
    ::returnFalse::
    return collisionDef
end

-- ========================== CORRIDORS ==========================

--[[
    Detect a collision on the walls of a corridor type MapArea object.
    If the Entity runs off either end this does not count as a collision
    to allow the Player to pass between areas

    Params:
        area:       table - MapArea object for the corridor 
        conditions: table - collision detection conditions
    Returns:
        table: collision status update - collision detected and where 
]]
function CollisionSystem:corridorBoundary(area, conditions)
    -- default values for detection - no collision
    local collisionDef = {detected = false, edge = nil}
    -- check for any doors in the corridor
    if area.doors then
        if self:detectCorridorDoorways(area, conditions) then
            return collisionDef
        end
    end
    -- perform corridor specific checks
    if area.orientation == 'horizontal' then
        -- check for bends to stop Player running off the end of the corridor
        if area.bends then
            for _, bend in pairs(area.bends) do
                if bend == 'RT' then
                    collisionDef = self:detectBend(
                        area.orientation, bend, area,
                        conditions.rightCollision, conditions.bottomCollision, conditions.topCollision,
                        {'R', 'B', 'RB', 'T'}
                    )
                end
                if bend == 'RB' then
                    collisionDef = self:detectBend(
                        area.orientation, bend, area,
                        conditions.rightCollision, conditions.topCollision, conditions.bottomCollision,
                        {'R', 'T', 'RT', 'B'}
                    )
                end
                if bend == 'LT' then
                    collisionDef = self:detectBend(
                        area.orientation, bend, area,
                        conditions.leftCollision, conditions.bottomCollision, conditions.topCollision,
                        {'L', 'B', 'LB', 'T'}
                    )
                end
                if bend == 'LB' then
                    collisionDef = self:detectBend(
                        area.orientation, bend, area,
                        conditions.leftCollision, conditions.topCollision, conditions.bottomCollision,
                        {'L', 'T', 'LT', 'B'}
                    )
                end
            end
        else
            if conditions.topCollision then
                collisionDef =  {detected = true, edge = 'T'}
            end
            if conditions.bottomCollision then
                collisionDef =  {detected = true, edge = 'B'}
            end
        end
        -- if left or right collision allow through
        return collisionDef
    else
        if area.bends then
            for _, bend in pairs(area.bends) do
                if bend == 'RT' then
                    collisionDef = self:detectBend(
                        area.orientation, bend, area,
                        conditions.topCollision, conditions.leftCollision, conditions.rightCollision,
                        {'T', 'L', 'LT', 'R'}
                    )
                end
                if bend == 'LT' then
                    collisionDef = self:detectBend(
                        area.orientation, bend, area,
                        conditions.topCollision, conditions.rightCollision, conditions.leftCollision,
                        {'T', 'R', 'RT', 'L'}
                    )
                end
                if bend == 'RB' then
                    collisionDef = self:detectBend(
                        area.orientation, bend, area,
                        conditions.bottomCollision, conditions.leftCollision, conditions.rightCollision,
                        {'B', 'L', 'LB', 'R'}
                    )
                end
                if bend == 'LB' then
                    collisionDef = self:detectBend(
                        area.orientation, bend, area,
                        conditions.bottomCollision, conditions.rightCollision, conditions.leftCollision,
                        {'B', 'R', 'RB', 'L'}
                    )
                end
            end
        else
            if conditions.leftCollision then
                collisionDef =  {detected = true, edge = 'L'}
            end
            if conditions.rightCollision then
                collisionDef =  {detected = true, edge = 'R'}
            end
        end
        -- if top or bottom collision allow through
        return collisionDef
    end
end

--[[
    Handles the collision detection for corridor type MapArea objects
    that have bends. The Player should not be able to escape off the
    end of the corridor the bend is located at, and they should be
    able to move freely between the 2 corridor type MapArea objects
    when the bends meet

    Params:
        orientation: string  - corridor type mapArea orientation 
        bendLabel:   string  - the location of the bend in the corridor
        area:        table   - the current mapArea object the Player is within 
        condition1:  boolean - edge collision condition 
        condition2:  boolean - edge collision condition
        condition3:  boolean - edge collision condition
        edgeTable:   table   - possible edge locations dependant on the conditions
    Returns:
        table: collision status and edge location
]]
function CollisionSystem:detectBend(orientation, bendLabel, area, condition1, condition2, condition3, edgeTable)
    local collisionDef = {detected = false, edge = nil}
    local offset
    -- set the offset based on the orientation and location of the bend
    if orientation == 'horizontal' then
        if bendLabel == 'RT' or bendLabel == 'RB' then
            offset = (self.playerX + ENTITY_WIDTH) < area.x + (area.width * FLOOR_TILE_WIDTH) - WALL_OFFSET * 2
        else
            offset = self.playerX > area.x + WALL_OFFSET * 2
        end
    else
        if bendLabel == 'LT' or bendLabel == 'RT' then
            offset = self.playerY > area.y + WALL_OFFSET * 1
        else
            offset = (self.playerY + ENTITY_HEIGHT) < area.y + (area.height * FLOOR_TILE_HEIGHT) - WALL_OFFSET * 1
        end
    end
    -- check the conditions to match collisions with the corners of the bend
    if condition1 then
        collisionDef = {detected = true, edge = edgeTable[1]}
    end
    if condition2 then
        collisionDef = {detected = true, edge = edgeTable[2]}
    end
    if condition1 and condition2 then
        collisionDef = {detected = true, edge = edgeTable[3]}
    end
    if condition3 and offset then
        collisionDef = {detected = true, edge = edgeTable[4]}
    end
    return collisionDef
end

--[[
    Update the Player (x, y) based on the edge of the area they have
    collided with so they cannot pass the area boundary

    Params:
        area: table  - MapArea object
        edge: string - edge location of the area
    Returns:
        table: true if a collision is detected, false if not, along with the edge
]]
function CollisionSystem:handlePlayerWallCollision(area, edge)
    -- declare corrections for readability of the if/elseif statements below
    local leftCorrection   = area.x - WALL_OFFSET
    local rightCorrection  = area.x + (area.width * FLOOR_TILE_WIDTH) - ENTITY_WIDTH + WALL_OFFSET
    local topCorrection    = area.y - WALL_OFFSET
    local bottomCorrection = area.y + (area.height * FLOOR_TILE_HEIGHT) - ENTITY_HEIGHT + WALL_OFFSET
    -- for single wall collisions just update x or y
    if edge == 'L' then
        self.systemManager.player.x = leftCorrection
    elseif edge == 'R' then
        self.systemManager.player.x = rightCorrection
    elseif edge == 'T' then
        self.systemManager.player.y = topCorrection
    elseif edge == 'B' then
        self.systemManager.player.y = bottomCorrection
    -- for multi-wall collisions update x and y
    elseif edge == 'LT' then
        self.systemManager.player.x = leftCorrection
        self.systemManager.player.y = topCorrection
    elseif edge == 'RT' then
        self.systemManager.player.x = rightCorrection
        self.systemManager.player.y = topCorrection
    elseif edge == 'LB' then
        self.systemManager.player.x = leftCorrection
        self.systemManager.player.y = bottomCorrection
    elseif edge == 'RB' then
        self.systemManager.player.x = rightCorrection
        self.systemManager.player.y = bottomCorrection
    end
end


--[[
    Handles enemy collisions with an area boundary. This needs to
    be separated from the HandlePlayerWallCollision function as the 
    corrections are different from how the Player correction is 
    implmented

    Params:
        entity: table  - Entity object to correct
        edge:   string - edge location of the area
    Returns:
        nil
]]
function CollisionSystem:handleEnemyWallCollision(entity, edge)
    if edge == 'T' then entity.direction = 'south'
    elseif edge == 'R' then entity.direction = 'west'
    elseif edge == 'B' then entity.direction = 'north'
    elseif edge == 'L' then entity.direction = 'east'
    elseif edge == 'TL' then entity.direction = 'south-east'
    elseif edge == 'BL' then entity.direction = 'north-east'
    elseif edge == 'TR' then entity.direction = 'south-west'
    elseif edge == 'BR' then entity.direction = 'north-west'
    end
end

-- ========================== DOORWAY DETECTION HELPER FUNCTIONS ==========================

--[[
    Helper function for ascertaining if the Player is within a doorway
    leading to a corridor type MapArea object from an area

    Params:
        area:       table - the current area type MapArea object
        door:       table - Door object in area definition
        conditions: table - collision detection conditions
    Returns:
        boolean: true if doorway detected
]]
function CollisionSystem:detectAreaDoorway(area, door, conditions)
    -- check if this door is in an adjacent area
    if door.areaID ~= area.id then
        -- if Player is in the doorway and the door is not locked then allow through
        local detectionCondition, doorID = self:detectAdjacentDoorway(area, door.areaID)
        if detectionCondition then
            local leftCondition   = self.playerX > area.x - V_DOOR_WIDTH
            local rightCondition  = (self.playerX + ENTITY_WIDTH) < area.x + (area.width * FLOOR_TILE_WIDTH) + V_DOOR_WIDTH
            local topCondition    = self.playerY > area.y - H_DOOR_HEIGHT
            local bottomCondition = (self.playerY + ENTITY_HEIGHT) < area.y + (area.height * FLOOR_TILE_HEIGHT) + H_DOOR_HEIGHT
            -- door ID required to fix bug allowing Player to pass through wall opposite adjacent doorway 
            if doorID == 1 then return leftCondition end
            if doorID == 2 then return topCondition end
            if doorID == 3 then return rightCondition end
            if doorID == 4 then return bottomCondition end
        end
    end
    -- detect standard area doorways and Player object proximity
    if door.id == 1 and door:proximity(self.playerX, self.playerY) and conditions.verticalDoorway then
        return true
    end
    if door.id == 3 and door:proximity(self.playerX, self.playerY) and conditions.verticalDoorway then
        return true
    end
    if door.id == 2 and door:proximity(self.playerX, self.playerY) and conditions.horizontalDoorway then
        return true
    end
    if door.id == 4 and door:proximity(self.playerX, self.playerY) and conditions.horizontalDoorway then
        return true
    end
    -- end
end

--[[
    Helper function for ascertaining if the Player is within a doorway
    leading to an adjacent area. These doorways are not centered and are
    not detected as part of the standard wall collision checks

    Params:
        area:           table  - MapArea object of the current area
        adjacentAreaID: number - ID of the area adjacent to the currnt area
    Returns:
        boolean: true if Player is in the doorway, false if not
]]
function CollisionSystem:detectAdjacentDoorway(area, adjacentAreaID)
    for _, adjacentArea in pairs(area.adjacentAreas) do
        if adjacentArea.doorID == 1 or adjacentArea.doorID == 3 then -- left or right
            -- use area y coordinates to find doorway
            local adjacentAreaDef    = GMapAreaDefinitions[adjacentAreaID]
            local yDiff              = area.y - adjacentAreaDef.y
            local adjacentAreaCenter = adjacentAreaDef.height * FLOOR_TILE_HEIGHT / 2
            local topDoorOffset      = area.y - yDiff + (adjacentAreaCenter - V_DOOR_HEIGHT)
            local bottomDoorOffset   = area.y - yDiff + (adjacentAreaCenter + V_DOOR_HEIGHT)
            -- doorway condition
            local detectionCondition = self.playerY + ENTITY_CORRECTION > topDoorOffset and (self.playerY + ENTITY_HEIGHT) - ENTITY_CORRECTION < bottomDoorOffset
            return detectionCondition, adjacentArea.doorID
        end
        if adjacentArea.doorID == 2 or adjacentArea.doorID == 4 then -- top or bottom
            -- use area x coordinates to find doorway
            local adjacentAreaDef    = GMapAreaDefinitions[adjacentAreaID]
            local xDiff              = area.x - adjacentAreaDef.x
            local adjacentAreaCenter = adjacentAreaDef.width * FLOOR_TILE_WIDTH / 2
            local leftDoorOffset     = area.x - xDiff + (adjacentAreaCenter - H_DOOR_WIDTH)
            local rightDoorOffset    = area.x - xDiff + (adjacentAreaCenter + H_DOOR_WIDTH)
            -- doorway condition
            local detectionCondition = self.playerX + ENTITY_CORRECTION > leftDoorOffset and (self.playerX + ENTITY_WIDTH) - ENTITY_CORRECTION < rightDoorOffset
            return detectionCondition, adjacentArea.doorID
        end
    end
end

--[[
    Helper function for ascertaining if the Player is within a doorway
    situated within a corridor type MapArea object. This does not include
    the doors at either end of the corridor

    Params:
        area:       table - the current area type MapArea object
        conditions: table - collision detection conditions
    Returns:
        boolean: true if doorway detected
]]
function CollisionSystem:detectCorridorDoorways(area, conditions)
    local door
    -- get the door in the centre of the corridor
    for _, d in pairs(self.systemManager.doorSystem:getCorridorDoors(area.id)) do
        if GMapAreaDefinitions[area.id].doors.L and d.id == 1 then door = d break end
        if GMapAreaDefinitions[area.id].doors.T and d.id == 2 then door = d break end
        if GMapAreaDefinitions[area.id].doors.R and d.id == 3 then door = d break end
        if GMapAreaDefinitions[area.id].doors.B and d.id == 4 then door = d break end
    end
    -- set the condition to stop Player from passing through opposite wall
    local oppositeConditions = {
        [1] = conditions.rightCollision,
        [2] = conditions.bottomCollision,
        [3] = conditions.leftCollision,
        [4] = conditions.topCollision
    }
    -- set condition for vertical or horizontal doorway
    local orientationCondition = (door.id == 1 or door.id == 3) and conditions.verticalDoorway or conditions.horizontalDoorway
    -- check proximity with door to allow through
    if door:proximity(self.playerX, self.playerY) and orientationCondition then
        if not oppositeConditions[door.id] then
            return true
        end
    end
    return false
end

-- ========================== CRATE/KEY/POWERUP/ENTITY COLLISIONS ==========================

--[[
    Detects a collision with key/powerup type PowerUp object. Uses
    AABB collision detection to see if the Player object is
    overlapping the game object

    Params:
        object: table - key/powerup type PowerUp object to detect
    Returns:
        boolean: true if collision detected
]]
function CollisionSystem:objectCollision(object)
    if (self.playerX + ENTITY_CORRECTION > object.x + object.width) or (object.x > self.playerX + ENTITY_WIDTH - ENTITY_CORRECTION) then
        return false
    end
    if (self.playerY + ENTITY_CORRECTION > object.y + object.height) or (object.y > self.playerY + ENTITY_HEIGHT - ENTITY_CORRECTION) then
        return false
    end
    return true
end

--[[
    Detects a collision with a crate type PowerUp object. Uses
    AABB collision detection to see if the Player object is
    overlapping the crate

    Params:
        key:    table - key type PowerUp object to detect
        entity: table - Entity object to collisio for
    Returns:
        boolean: true if collision detected
]]
function CollisionSystem:crateCollision(crate, entity)
    -- false collision conditions
    if (entity.x > crate.x + CRATE_WIDTH) or (crate.x > entity.x + ENTITY_WIDTH) then
        return {detected = false, edge = nil}
    end
    if (entity.y > crate.y + CRATE_HEIGHT) or (crate.y > entity.y + ENTITY_HEIGHT) then
        return {detected = false, edge = nil}
    end
    -- true collision conditions
    local edge
    local horizontalGap = (entity.x + CRATE_CORRECTION > crate.x) and (entity.x + ENTITY_WIDTH - CRATE_CORRECTION) < crate.x + CRATE_WIDTH
    local verticalGap   = (entity.y + CRATE_CORRECTION > crate.y) and (entity.y + ENTITY_HEIGHT - CRATE_CORRECTION) < crate.y + CRATE_HEIGHT
    if (entity.x + ENTITY_WIDTH - ENTITY_CORRECTION > crate.x) and (entity.x + ENTITY_WIDTH < crate.x + CRATE_WIDTH) and verticalGap then
        edge = 'L'
    end
    if (entity.y + ENTITY_HEIGHT - ENTITY_CORRECTION > crate.y) and (entity.y + ENTITY_HEIGHT < crate.y + CRATE_HEIGHT) and horizontalGap then
        edge = 'T'
    end
    if (entity.x + ENTITY_CORRECTION < crate.x + CRATE_WIDTH) and (entity.x > crate.x) and verticalGap then
        edge = 'R'
    end
    if (entity.y + ENTITY_CORRECTION < crate.y + CRATE_HEIGHT) and (entity.y > crate.y) and horizontalGap then
        edge = 'B'
    end
    return {detected = true, edge = edge}
end

--[[
    Detects a collision with a subject and a Bullet object using
    AABB collision detection

    Params:
        bullet:  table - Bullet object
        subject: table - object to check collision with
    Returns:
        boolean: true if collision detected
]]
function CollisionSystem:bulletCollision(bullet, subject)
    if (bullet.x > subject.x + subject.width) or (subject.x > bullet.x + 10) then
        return false
    end
    if (bullet.y > subject.y + subject.height) or (subject.y > bullet.y + 10) then
        return false
    end
    return true
end

--[[
    Detects if a Bullet object has gone past the area boundary

    Params;
        x: number - x coordinate of Bullet
        y: number - y coordinate of Bullet
    Returns:
        boolean: true if collision detected
]]
function CollisionSystem:bulletHitBoundary(x, y)
    local offset = 20
    if x < GMapAreaDefinitions[self.currentAreaID].x - WALL_OFFSET - offset then
        return true
    end
    if x > (GMapAreaDefinitions[self.currentAreaID].x + GMapAreaDefinitions[self.currentAreaID].width * FLOOR_TILE_WIDTH) - WALL_OFFSET - offset then
        return true
    end
    if y < GMapAreaDefinitions[self.currentAreaID].y - WALL_OFFSET - offset then
        return true
    end
    if y > (GMapAreaDefinitions[self.currentAreaID].y + GMapAreaDefinitions[self.currentAreaID].height * FLOOR_TILE_HEIGHT) - WALL_OFFSET - offset then
        return true
    end
    return false
end

-- ========================== COLLISION HANDLERS ==========================


--[[
    Handles the crate collision by setting the Player (x, y) so
    they cannot run over the crate

    Params:
        crate: table  - crate type PowerUp object the Player has collided with
        egde:  string - edge the collision was detected on
    Returns:
        nil
]]
function CollisionSystem:handlePlayerCrateCollision(crate, edge)
    if edge == 'L' then
        self.systemManager.player.x = crate.x - ENTITY_WIDTH + ENTITY_CORRECTION
    elseif edge == 'T' then
        self.systemManager.player.y = crate.y - ENTITY_HEIGHT + ENTITY_CORRECTION
    elseif edge == 'R' then
        self.systemManager.player.x = crate.x + CRATE_WIDTH - ENTITY_CORRECTION
    elseif edge == 'B' then
        self.systemManager.player.y = crate.y + CRATE_HEIGHT - ENTITY_CORRECTION
    end
end

--[[
    Handles the crate collision by changing the direction of
    the Entity so they cannot run over the crate

    Params:
        entity: table  - Entity object to update
        egde:   string - edge the collision was detected on
    Returns:
        nil
]]
function CollisionSystem:handleEnemyCrateCollision(entity, edge)
    if edge == 'L' then
        entity.direction = 'west'
    elseif edge == 'T' then
        entity.direction = 'north'
    elseif edge == 'R' then
        entity.direction = 'east'
    elseif edge == 'B' then
        entity.direction = 'south'
    end
end
