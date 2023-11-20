--[[
    CollisionSystem: class

    Description:
        A collision system checks for and handles collisions for Entity
        objects (Player, Grunt, Boss) and also PowerUp objects within 
        the Map. Having a separate system for checking collisions reduces 
        bulk in individual classes and centralises collision behaviour to 
        make it more managable
]]

CollisionSystem = Class{}

--[[
    CollisionSystem constructor. Requires the Player object to
    run checks against and the DoorSystem to allow the Player
    to pass through wall segments in areas with doors defined 

    Params:
        player:     table - Player object
        doorSystem: table - DoorSystem object
    Returns:
        nil
]]
function CollisionSystem:init(player, doorSystem)
    self.player = player
    self.doorSystem = doorSystem
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
        leftCollision = entity.x < area.x - WALL_OFFSET,
        rightCollision = entity.x + entity.width > area.x + (area.width * FLOOR_TILE_WIDTH) + WALL_OFFSET,
        topCollision = entity.y < area.y - WALL_OFFSET,
        bottomCollision = entity.y + entity.height > area.y + (area.height * FLOOR_TILE_HEIGHT) + WALL_OFFSET,
        leftHorizontal = area.x + (area.width * FLOOR_TILE_WIDTH / 2) - H_DOOR_WIDTH,
        rightHorizontal = area.x + (area.width * FLOOR_TILE_WIDTH / 2) + H_DOOR_WIDTH,
        topVertical = area.y + (area.height * FLOOR_TILE_HEIGHT / 2) - V_DOOR_HEIGHT,
        bottomVertical = area.y + (area.height * FLOOR_TILE_HEIGHT / 2) + V_DOOR_HEIGHT
    }
    -- set Player (x, y) comparison
    conditions['horizontalDoorway'] = self.player.x + ENTITY_CORRECTION > conditions.leftHorizontal and (self.player.x + ENTITY_WIDTH) - ENTITY_CORRECTION < conditions.rightHorizontal
    conditions['verticalDoorway'] = self.player.y + ENTITY_CORRECTION > conditions.topVertical and (self.player.y + ENTITY_HEIGHT) - ENTITY_CORRECTION < conditions.bottomVertical
    -- if the area is a corridor then allow the player to pass through each end
    if area.type == 'corridor'then
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
        for _, door in pairs(self.doorSystem:getAreaDoors(area.id)) do
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
    when the bend meets

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
            offset = (self.player.x + self.player.width) < area.x + (area.width * FLOOR_TILE_WIDTH) - WALL_OFFSET * 2
        else
            offset = self.player.x > area.x + WALL_OFFSET * 2
        end
    else
        if bendLabel == 'LT' or bendLabel == 'RT' then
            offset = self.player.y > area.y + WALL_OFFSET * 1
        else
            offset = (self.player.y + self.player.height) < area.y + (area.height * FLOOR_TILE_HEIGHT) - WALL_OFFSET * 1
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
    local leftCorrection = area.x - WALL_OFFSET
    local rightCorrection = area.x + (area.width * FLOOR_TILE_WIDTH) - ENTITY_WIDTH + WALL_OFFSET
    local topCorrection = area.y - WALL_OFFSET
    local bottomCorrection = area.y + (area.height * FLOOR_TILE_HEIGHT) - ENTITY_HEIGHT + WALL_OFFSET
    -- for single wall collisions just update x or y
    if edge == 'L' then
        self.player.x = leftCorrection
    elseif edge == 'R' then
        self.player.x = rightCorrection
    elseif edge == 'T' then
        self.player.y = topCorrection
    elseif edge == 'B' then
        self.player.y = bottomCorrection
    -- for multi-wall collisions update x and y
    elseif edge == 'LT' then
        self.player.x = leftCorrection
        self.player.y = topCorrection
    elseif edge == 'RT' then
        self.player.x = rightCorrection
        self.player.y = topCorrection
    elseif edge == 'LB' then
        self.player.x = leftCorrection
        self.player.y = bottomCorrection
    elseif edge == 'RB' then
        self.player.x = rightCorrection
        self.player.y = bottomCorrection
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

-- ========================== DOOR COLLISIONS ==========================

--[[
    Checks for Player proximity to a Door object and opens
    the door if it is not locked. If it is locked it checks
    if the Player as the key

    Params:
        door: table - Door object the Player is in proximity to
    Returns:
        nil
]]
function CollisionSystem:checkDoorProximity(door)
    if door:proximity(self.player) then
        -- check if door is locked
        if not door.isLocked then
            self.doorSystem:open(door)
        else
            if self.player.keys[door.colour] then
                -- if locked and has key open the door
                door.isLocked = false
                self.doorSystem:open(door)
                if DOOR_IDS[door.colour] == 3 then self.player.keys['blue'] = false end
                if DOOR_IDS[door.colour] == 4 then self.player.keys['red'] = false end
                if DOOR_IDS[door.colour] == 5 then self.player.keys['green'] = false end
            end
        end
        return true
    end
    return false
end

--[[
    Checks for collisions with the Door objects themselves to stop
    the Player from passing through the doors while they are in the
    process of opening

    Param:
        door: table - Door object Entity is interacting with
    Returns:
        boolean: detection status and edge door is on
]]
function CollisionSystem:checkDoorCollsion(door)
    -- return true if the door is locked to block the Entity
    if door.isLocked then
        goto returnTrue
    end
    -- AABB collision detection for the left and right doors
    if self.player.x > door.leftX or door.leftX > (self.player.x + self.player.width) then
        return {detected = false, edge = AREA_DOOR_IDS[door.id]}
    end
    if self.player.y > door.leftY or door.leftY > (self.player.y + self.player.height) then
        return {detected = false, edge = AREA_DOOR_IDS[door.id]}
    end
    if self.player.x > door.rightX or door.rightX > (self.player.x + self.player.width) then
        return {detected = false, edge = AREA_DOOR_IDS[door.id]}
    end
    if self.player.y > door.rightY or door.rightY > (self.player.y + self.player.height) then
        return {detected = false, edge = AREA_DOOR_IDS[door.id]}
    end
    ::returnTrue::
    -- return true detection if the Player is overlapping any part of any door
    return {detected = true, edge = AREA_DOOR_IDS[door.id]}
end

--[[
    Handles a collision with a pair of Door objects to reposition
    the Player object until they can correctly pass through the 
    door

    Params:
        door: table  - Door object Player is interacting with
        edge: string - edge the Player has collisded with
    Returns:
        nil
]]
function CollisionSystem:handleDoorCollision(door, edge)
    -- check door location to apply appropriate correction
    if edge == 'L' or edge == 'R' then
        if door.playerLocation == 'left' then
            self.player.x = (door.leftX + V_DOOR_WIDTH) - ENTITY_WIDTH
        elseif door.playerLocation == 'right' then
            self.player.x = door.leftX - V_DOOR_WIDTH
        end
    end
    if edge == 'T' or edge == 'B' then
        if door.playerLocation == 'below' then
            self.player.y = door.leftY - H_DOOR_HEIGHT
        elseif door.playerLocation == 'above' then
            self.player.y = (door.leftY + H_DOOR_HEIGHT) - ENTITY_HEIGHT
        end
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
            local leftCondition = self.player.x > area.x - V_DOOR_WIDTH
            local rightCondition = (self.player.x + self.player.width) < area.x + (area.width * FLOOR_TILE_WIDTH) + V_DOOR_WIDTH
            local topCondition = self.player.y > area.y - H_DOOR_HEIGHT
            local bottomCondition = (self.player.y + self.player.height) < area.y + (area.height * FLOOR_TILE_HEIGHT) + H_DOOR_HEIGHT
            -- door ID required to fix bug allowing Player to pass through wall opposite adjacent doorway 
            if doorID == 1 then
                return leftCondition
            end
            if doorID == 2 then
                return topCondition
            end
            if doorID == 3 then
                return rightCondition
            end
            if doorID == 4 then
                return bottomCondition
            end
        end
    end
    -- detect standard area doorways and Player object proximity
    if door.id == 1 and door:proximity(self.player) and conditions.verticalDoorway then
        return true
    end
    if door.id == 3 and door:proximity(self.player) and conditions.verticalDoorway then
        return true
    end
    if door.id == 2 and door:proximity(self.player) and conditions.horizontalDoorway then
        return true
    end
    if door.id == 4 and door:proximity(self.player) and conditions.horizontalDoorway then
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
            local adjacentAreaDef = GMapAreaDefinitions[adjacentAreaID]
            local yDiff = area.y - adjacentAreaDef.y
            local adjacentAreaCenter = adjacentAreaDef.height * FLOOR_TILE_HEIGHT / 2
            local topDoorOffset = area.y - yDiff + (adjacentAreaCenter - V_DOOR_HEIGHT)
            local bottomDoorOffset = area.y - yDiff + (adjacentAreaCenter + V_DOOR_HEIGHT)
            -- doorway condition
            local detectionCondition = self.player.y + ENTITY_CORRECTION > topDoorOffset and (self.player.y + self.player.height) - ENTITY_CORRECTION < bottomDoorOffset
            return detectionCondition, adjacentArea.doorID
        end
        if adjacentArea.doorID == 2 or adjacentArea.doorID == 4 then -- top or bottom
            -- use area x coordinates to find doorway
            local adjacentAreaDef = GMapAreaDefinitions[adjacentAreaID]
            local xDiff = area.x - adjacentAreaDef.x
            local adjacentAreaCenter = adjacentAreaDef.width * FLOOR_TILE_WIDTH / 2
            local leftDoorOffset = area.x - xDiff + (adjacentAreaCenter - H_DOOR_WIDTH)
            local rightDoorOffset = area.x - xDiff + (adjacentAreaCenter + H_DOOR_WIDTH)
            -- doorway condition
            local detectionCondition = self.player.x + ENTITY_CORRECTION > leftDoorOffset and (self.player.x + self.player.width) - ENTITY_CORRECTION < rightDoorOffset
            return detectionCondition, adjacentArea.doorID
        end
    end
end

--[[
    Helper function for ascertaining if the Player is within a doorway
    leading to an area type MapArea object from a corridor

    Params:
        area:       table - the current area type MapArea object
        conditions: table - collision detection conditions
    Returns:
        boolean: true if doorway detected
]]
function CollisionSystem:detectCorridorDoorways(area, conditions)
    -- check for door proximity to allow the Player object to pass through the wall at that point
    for _, door in pairs(self.doorSystem:getCorridorDoors(area.id)) do
        if door.id == 1 and door:proximity(self.player) and conditions.verticalDoorway then
            if not conditions.rightCollision then
                return true
            end
        elseif door.id == 3 and door:proximity(self.player) and conditions.verticalDoorway then
            if not conditions.leftCollision then
                return true
            end
        elseif door.id == 2 and door:proximity(self.player) and conditions.horizontalDoorway then
            if not conditions.bottomCollision then
                return true
            end
        elseif door.id == 4 and door:proximity(self.player) and conditions.horizontalDoorway then
            if not conditions.topCollision then
                return true
            end
        end
    end
end

-- ========================== CRATE/KEY/POWERUP COLLISIONS ==========================

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
    if (self.player.x > object.x + object.width) or (object.x > self.player.x + ENTITY_WIDTH) then
        return false
    end
    if (self.player.y > object.y + object.height) or (object.y > self.player.y + ENTITY_HEIGHT) then
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
    local verticalGap = (entity.y + CRATE_CORRECTION > crate.y) and (entity.y + ENTITY_HEIGHT - CRATE_CORRECTION) < crate.y + CRATE_HEIGHT
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
        self.player.x = crate.x - ENTITY_WIDTH + ENTITY_CORRECTION
    elseif edge == 'T' then
        self.player.y = crate.y - ENTITY_HEIGHT + ENTITY_CORRECTION
    elseif edge == 'R' then
        self.player.x = crate.x + CRATE_WIDTH - ENTITY_CORRECTION
    elseif edge == 'B' then
        self.player.y = crate.y + CRATE_HEIGHT - ENTITY_CORRECTION
    end
end

-- ========================== ENEMY COLLISIONS ==========================

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

--[[
    Detects collisions between entity objects so they do not pass
    through each other

    Params:
        entity1: table - Entity object
        entity2: table - Entity object
    Returns:
        boolean: true if collision detected
]]
function CollisionSystem:entityCollision(entity1, entity2)
    if (entity1.x > entity2.x + entity2.width + ENTITY_PROXIMITY) or (entity2.x - ENTITY_PROXIMITY > entity1.x + ENTITY_WIDTH) then
        return false
    end
    if (entity1.y > entity2.y + entity2.height + ENTITY_PROXIMITY) or (entity2.y - ENTITY_PROXIMITY > entity1.y + ENTITY_HEIGHT) then
        return false
    end
    return true
end

--[[
    Handles a collision between 2 Entity objects

    TODO

    Params:
        entity: table - Entity object
    Returns:
        nil
]]
function CollisionSystem:handleEntityCollision(entity)

end