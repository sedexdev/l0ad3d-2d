--[[
    Player: class

    Includes: Entity - parent class for entity objects 

    Description:
        Creates, updates, and renders a Player character object
        using the parent Entity class
]]

Player = Class{__includes = Entity}

--[[
    Boss constructor

    Params:
        id: number - defines which character animations will be used
        animations: table - the character sprite sheet indices for drawing
                            this Entity
        def: table - the definition of a Player object as defined in 
                     src/utils/definitions.lua as GCharacterDefinition
    Returns:
        nil
]]
function Player:init(id, animations, def)
    Entity.init(self, def)
    self.id = id
    self.texture = animations.texture
    self.fireShot = animations.fireShot
    self.animations = animations.animations
    self.health = def.health
    self.ammo = def.ammo
    self.shotFired = def.shotFired
    self.weapons = def['character'..tostring(self.id)].weapons
    self.currentWeapon = def['character'..tostring(self.id)].currentWeapon
    self.direction = def.direction
    self.lastDirection = def.lastDirection
    self.powerups = def.powerups
    -- defines the current area of the player: {id = areaID, type = 'area' | 'corridor'}
    -- 17 is the starting area 
    self.currentArea = {id = 17, type = 'area'}
    -- shots table keeps track of Shot objects so they can be 
    -- instantiated and removed after the assigned interval
    self.shots = {}
end

--[[
    Player update function. Calls Entity parent update function,
    passing <self> and <dt> as arguments. Also defines user interaction
    keys and renders out shots as the player fires their weapon.

    Key bindings:
        space: fire weapon - self:fire() called
    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function Player:update(dt)
    Entity.update(self, dt)

    if love.keyboard.wasPressed('space') then
        self:fire()
    end

    for _, shot in pairs(self.shots) do
        -- update the shot animation
        shot:update(dt)
        if not shot.renderShot then
            shot = nil
            -- remove shots once their interval has passed
            table.remove(self.shots, shot)
        end
    end
end

--[[
    Player render function. Calls Entity parent render function,
    passing <self> as an arguments. Also renders each Shot object
    inserted into the <self.shots> table

    Params:
        none
    Returns:
        nil
]]
function Player:render()
    Entity.render(self)

    love.graphics.setColor(1, 1, 1, 1)
    for _, shot in pairs(self.shots) do
        if shot.renderShot then
            shot:render()
        end
    end
end

--[[
    Check if the Player has hit the wall and detect a wall collision
    if they have. A wall collision is defined as the (x, y) Player object
    coordinates exceeding the boundary of the current area they are in

    Params:
        areaID: number - area ID to index GMapAreaDefinitions with
    Returns:
        table: true if a collision is detected, false if not, along with the edge
]]
function Player:checkWallCollision(areaID)
    local area = GMapAreaDefinitions[areaID]
    -- default values for detection - no collision
    local collisionDef = {detected = false, edge = nil}
    -- booleans for detecting pixel overlaps on each edge
    local leftCollision = self.x < area.x - WALL_OFFSET
    local rightCollision = self.x + self.width > area.x + (area.width * (64 * 5) + WALL_OFFSET)
    local topCollision = self.y < area.y - WALL_OFFSET
    local bottomCollision = self.y + self.height > area.y + (area.height * (32 * 5) + WALL_OFFSET)

    -- check for single wall collisions first
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
    Called when an end user fires the Players weapon using
    the space key. A new instance of Shot is inserted into
    <self.shots> and the GAudio['gunshot'] is played. Also
    checks if the character has more than one weapon and updates
    the <self.currentWeapon> attribute so shots can be rendered
    from alternating weapons

    Params:
        none
    Returns:
        nil
]]
function Player:fire()
    table.insert(self.shots, Shot(self))
    GAudio['gunshot']:stop()
    GAudio['gunshot']:play()
    if self.weapons > 1 then
        self.currentWeapon = self.currentWeapon == 'right' and 'left' or 'right'
    end
end

--[[
    Updates the location of the player so proper collision detection
    can be implemented in the location the Player is currently in

    TODO: review how this will be used

    Params:
        areas: table - list of MapArea objects to compare
                       Players (x, y) coordinates to 
        type: string - 'area' | 'corridor' ; used to know how to handle doors
    Returns:
        table: value stored in <self.currentArea>
]]
function Player:setCurrentArea(areas)
    -- <areas> includes both areas and corridors
    for _, area in pairs(areas) do
        -- if player within area/corridor x coordinate boundary
        if (self.x > area.x - WALL_OFFSET) and (self.x + self.width < (area.x + area.width * (64 * 5)) + WALL_OFFSET) then
            -- if player within area/corridor y coordinate boundary
            if (self.y > area.y - WALL_OFFSET) and (self.y + self.height < (area.y + area.height * (32 * 5)) + WALL_OFFSET) then
                -- player current area updated
                self.currentArea.id = area.id
                self.currentArea.type = area.type
            end
        end
    end
end
