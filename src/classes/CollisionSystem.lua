--[[
    CollisionSystem: class

    Description:
        A collision system checks for an handle collisions for Entity
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

--[[
    Check if an Entity has hit the wall and detect a wall collision
    if they have. A wall collision is defined as the (x, y) Entity object
    coordinates exceeding the boundary of the current area they are in

    Params:
        area: table - MapArea object
        entity: table - Entity object (Player | Grunt | Boss)
    Returns:
        table: true if a collision is detected, false if not, along with the edge
]]
function CollisionSystem:checkWallCollision(area, entity)
    -- default values for detection - no collision
    local collisionDef = {detected = false, edge = nil}

    -- check for door collision and return false so we can pass through the door
    if area.type == 'area' then
        -- open the door in the area is th Player's proximity is close enough
        for _, door in pairs(self.doorSystem:getAreaDoors(area.id)) do
            if door:proximity(self.player) then
                -- check if door is locked
                if not door.isLocked then
                    self.doorSystem:open(door)
                    return collisionDef
                else
                    -- TODO: check if Player has key
                end
            end
        end
    else
        -- if this area is a corridor find the joining doors
        for _, door in pairs(self.doorSystem:getCorridorDoors(area.id)) do
            if door:proximity(self.player) then
                self.doorSystem:open(door)
            end
        end
    end

    -- booleans for detecting pixel overlaps on each edge
    local leftCollision = entity.x < area.x - WALL_OFFSET
    local rightCollision = entity.x + entity.width > area.x + (area.width * FLOOR_TILE_WIDTH + WALL_OFFSET)
    local topCollision = entity.y < area.y - WALL_OFFSET
    local bottomCollision = entity.y + entity.height > area.y + (area.height * FLOOR_TILE_HEIGHT + WALL_OFFSET)

    -- if the area is a corridor then allow the player to pass through each end
    if area.type == 'corridor' then
        if area.orientation == 'horizontal' then
            if topCollision then
                collisionDef =  {detected = true, edge = 'T'}
            end
            if bottomCollision then
                collisionDef =  {detected = true, edge = 'B'}
            end
            -- if left or right collision allow through
            return collisionDef
        else
            if leftCollision then
                collisionDef =  {detected = true, edge = 'L'}
            end
            if rightCollision then
                collisionDef =  {detected = true, edge = 'R'}
            end
            -- if top or bottom collision allow through
            return collisionDef
        end
    end

    -- for areas check for single wall collisions first
    if leftCollision then
        collisionDef = {detected = true, edge = 'L'}
    end
    if rightCollision then
        collisionDef = {detected = true, edge = 'R'}
    end
    if topCollision then
        collisionDef = {detected = true, edge = 'T'}
    end
    if bottomCollision then
        collisionDef = {detected = true, edge = 'B'}
    end
    -- then check for collisions with 2 walls at once to avoid corner escape bug
    if leftCollision and topCollision then
        collisionDef = {detected = true, edge = 'LT'}
    end
    if rightCollision and topCollision then
        collisionDef = {detected = true, edge = 'RT'}
    end
    if leftCollision and bottomCollision then
        collisionDef = {detected = true, edge = 'LB'}
    end
    if rightCollision and bottomCollision then
        collisionDef = {detected = true, edge = 'RB'}
    end

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