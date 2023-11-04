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
        player: table - Player object
        doorSystem: table - DoorSystem object
    Returns:
        nil
]]
function CollisionSystem:init(player, doorSystem)
    self.player = player
    self.doorSystem = doorSystem
end

--[[
    CollisionSystem update function. 

    TODO - review if this is needed

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function CollisionSystem:update(dt)

end

-- ====================== WALL COLLISIONS ======================

--[[
    Check if an Entity has hit the wall and detect a wall collision
    if they have. A wall collision is defined as the (x, y) Entity object
    coordinates exceeding the boundary of the current area they are in

    TODO: only check for collisions with walls
          if the area has doors, omit those (x, y) coordinates from the check

    Params:
        area: table - MapArea object
        entity: table - Entity object (Player | Grunt | Boss)
    Returns:
        table: true if a collision is detected, false if not, along with the edge
]]
function CollisionSystem:checkWallCollision(area, entity)
    -- booleans for stating whether Player object has hit the area boundary
    local conditions = {
        leftCollision = entity.x < area.x - WALL_OFFSET,
        rightCollision = entity.x + entity.width > area.x + (area.width * FLOOR_TILE_WIDTH + WALL_OFFSET),
        topCollision = entity.y < area.y - WALL_OFFSET,
        bottomCollision = entity.y + entity.height > area.y + (area.height * FLOOR_TILE_HEIGHT + WALL_OFFSET),
    }
    -- if the area is a corridor then allow the player to pass through each end
    if area.type == 'corridor' then
        return self:corridorBoundary(area, conditions)
    else
        return self:areaBoundary(area, conditions)
    end
end

--[[
    Detect a collision on the walls of a corridor type MapArea object.
    If the Player runs off either end this does not count as a collision
    to allow the Player to pass between areas

    TODO: handle allowing Player to move round corners on bends
          move bend checks to separate functions

    Params:
        area: table - MapArea object for the corridor 
        conditions: table - collision detection conditions
    Returns:
        table: collision status update - collision detected and where 
]]
function CollisionSystem:corridorBoundary(area, conditions)
    -- default values for detection - no collision
    local collisionDef = {detected = false, edge = nil}
    -- return collisions detections for the walls on each side of the corridor, not the ends
    if area.orientation == 'horizontal' then
        if conditions.topCollision then
            collisionDef =  {detected = true, edge = 'T'}
        end
        if conditions.bottomCollision then
            collisionDef =  {detected = true, edge = 'B'}
        end
        -- check for bends to stop Player running off the end of the corridor
        if area.bends then
            for _, bend in pairs(area.bends) do
                if bend == 'RT' or bend == 'RB' then
                    if conditions.rightCollision then
                        collisionDef = {detected = true, edge = 'R'}
                    end
                end
                if bend == 'LT' or bend == 'LB' then
                    if conditions.leftCollision then
                        collisionDef = {detected = true, edge = 'L'}
                    end
                end
            end
        end
        -- if left or right collision allow through
        return collisionDef
    else
        if conditions.leftCollision then
            collisionDef =  {detected = true, edge = 'L'}
        end
        if conditions.rightCollision then
            collisionDef =  {detected = true, edge = 'R'}
        end
        if area.bends then
            for _, bend in pairs(area.bends) do
                if bend == 'RT' or bend == 'LT' then
                    if conditions.topCollision then
                        collisionDef = {detected = true, edge = 'T'}
                    end
                end
                if bend == 'RB' or bend == 'LB' then
                    if conditions.bottomCollision then
                        collisionDef = {detected = true, edge = 'B'}
                    end
                end
            end
        end
        -- if top or bottom collision allow through
        return collisionDef
    end
end

--[[
    Detect a collision on the walls of an area type MapArea object.
    Collisions can occur on all 4 walls and on multiple walls at the
    same time when running into a corner

    Params:
    area: table - MapArea object for the corridor
        conditions: table - collision detection conditions
    Returns:
        table: collision status update - collision detected and where 
]]
function CollisionSystem:areaBoundary(area, conditions)
    -- default values for detection - no collision
    local collisionDef = {detected = false, edge = nil}

    -- set doorway cooridinates to allow Player to pass through a gap if there is a Door
    local leftHorizontal = area.x + (area.width * FLOOR_TILE_WIDTH / 2) - H_DOOR_WIDTH
    local rightHorizontal = area.x + (area.width * FLOOR_TILE_WIDTH / 2) + H_DOOR_WIDTH
    local topVertical = area.y + (area.height * FLOOR_TILE_HEIGHT / 2) - V_DOOR_HEIGHT
    local bottomVertical = area.y + (area.height * FLOOR_TILE_HEIGHT / 2) + V_DOOR_HEIGHT
    -- set Player (x, y) comparison
    local horizontalDoorway = self.player.x + 120 > leftHorizontal and (self.player.x + self.player.width) - 120 < rightHorizontal
    local verticalDoorway = self.player.y + 120 > topVertical and (self.player.y + self.player.height) - 120 < bottomVertical
    -- check for door proximity to allow the Player object to pass through the wall at that point
    for _, door in pairs(self.doorSystem:getAreaDoors(area.id)) do
        if door.id == 1 and door:proximity(self.player) and verticalDoorway then
            goto returnFalse
        end
        if door.id == 3 and door:proximity(self.player) and verticalDoorway then
            goto returnFalse
        end
        if door.id == 2 and door:proximity(self.player) and horizontalDoorway then
            goto returnFalse
        end
        if door.id == 4 and door:proximity(self.player) and horizontalDoorway then
            goto returnFalse
        end
    end

    -- check for single wall collisions first
    if conditions.leftCollision then
        -- check for doorways on single wall collisions only
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

--[[
   Update the Player (x, y) based on the edge of the area they have
   collided with so they cannot pass the area boundary

    Params:
        area: table - MapArea object
        edge: string - edge location of the area
    Returns:
        table: true if a collision is detected, false if not, along with the edge
]]
function CollisionSystem:handlePlayerWallCollision(area, edge)
    -- declare corrections for readability of the if/elseif statements below
    local correctionOffset = 18
    local leftCorrection = area.x - WALL_OFFSET + correctionOffset
    local rightCorrection = area.x + (area.width * FLOOR_TILE_WIDTH) - CHARACTER_WIDTH + WALL_OFFSET - correctionOffset
    local topCorrection = area.y - WALL_OFFSET + correctionOffset
    local bottomCorrection = area.y + (area.height * FLOOR_TILE_HEIGHT) - CHARACTER_HEIGHT + WALL_OFFSET - correctionOffset

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

-- ====================== DOOR COLLISIONS ======================

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
            end
        end
    end
end

--[[
    Checks for collisions with the Door objects themselves to stop
    the Player from passing through the doors while they are in the
    process of opening

    Param:
        door: table - Door object Player is interacting with
    Returns:
        boolean: detection status and edge door is on
]]
function CollisionSystem:checkDoorCollsion(door)
    local playerCorrection = 120
    -- AABB collision detection for the left and right doors
    if (self.player.x + playerCorrection > door.leftX + H_DOOR_WIDTH) or (door.leftX > self.player.x + self.player.width + playerCorrection) then
        return {detected = false, edge = AREA_DOOR_IDS[door.id]}
    end
    if (self.player.y + playerCorrection > door.leftY + H_DOOR_HEIGHT) or (door.leftY > self.player.y + self.player.height + playerCorrection) then
        return {detected = false, edge = AREA_DOOR_IDS[door.id]}
    end
    if (self.player.x + playerCorrection > door.rightX + H_DOOR_WIDTH) or (door.rightX > self.player.x + self.player.width + playerCorrection) then
        return {detected = false, edge = AREA_DOOR_IDS[door.id]}
    end
    if (self.player.y + playerCorrection > door.rightY + H_DOOR_HEIGHT) or (door.rightY > self.player.y + self.player.height + playerCorrection) then
        return {detected = false, edge = AREA_DOOR_IDS[door.id]}
    end
    -- return true detection if the Player is overlapping any part of any door
    return {detected = true, edge = AREA_DOOR_IDS[door.id]}
end

--[[
    Handles a collision with a pair of Door objects to reposition
    the Player object until they can correctly pass through the 
    door

    Params:
        door: table - Door object Player is interacting with
    Returns:
        nil
]]
function CollisionSystem:handlePlayerDoorCollision(door, edge)
    -- set corrections to fix Player position after collision
    local correctionOffset = 18
    -- check door location to apply appropriate correction
    if edge == 'L' or edge == 'R' then
        if door.playerLocation == 'left' then
            self.player.x = door.leftX - CHARACTER_WIDTH + V_DOOR_WIDTH - correctionOffset
        elseif door.playerLocation == 'right' then
            self.player.x = door.leftX + correctionOffset
        end
    end
    if edge == 'T' or edge == 'B' then
        if door.playerLocation == 'below' then
            self.player.y = door.leftY + correctionOffset
        elseif door.playerLocation == 'above' then
            self.player.y = door.leftY - CHARACTER_HEIGHT + H_DOOR_HEIGHT - correctionOffset
        end
    end
end
