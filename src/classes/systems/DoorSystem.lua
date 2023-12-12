--[[
    DoorSystem: class

    Includes: Observer - parent class for observers

    Description:
        The door system is an independent mechanism for handling how
        doors behave when the Player object interacts wth them. The
        door system controls opening and closing doors, and unlocking
        doors
]]

DoorSystem = Class{__includes = Observer}

--[[
    DoorSystem constructor. Creates a store for the doors in the
    system and knows which door the Player is currently interacting with 

    Params:
        map:    table - Map object used to get door references for adjacent areas
        player: table - Player object
    Returns:
        nil
]]
function DoorSystem:init(map, player)
    self.map           = map
    self.player        = player
    self.playerX       = PLAYER_STARTING_X
    self.playerY       = PLAYER_STARTING_Y
    self.currentAreaID = START_AREA_ID
    self.doors         = {}
end

--[[
    DoorSystem update function. Updates Door objects so they can tween
    open and closed

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function DoorSystem:update(dt)
    Timer.update(dt)
    -- update Player location relative to doors in the current location
    self:setPlayerLocation()
end

--[[
    DoorSystem render function. Renders out the 2 doors that form this
    door pair

    Params:
        none
    Returns:
        none
]]
function DoorSystem:render()
    for _, door in pairs(self.doors) do
        door:render()
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
function DoorSystem:message(data)
    if data.source == 'PlayerWalkingState' then
        self.playerX       = data.x
        self.playerY       = data.y
        self.currentAreaID = data.areaID
    end
end

--[[
    Creates all the Door objects based of the location they are 
    placed relative to the various MapArea objects that form the Map

    Params:
        areas: table - table of MapArea objects to get door (x, y) from
    Returns:
        nil
]]
function DoorSystem:initialiseDoors(areas)
    for _, area in pairs(areas) do
        if area.doors then
            -- area dimensions in px
            local areaWidth  = area.width * FLOOR_TILE_WIDTH
            local areaHeight = area.height * FLOOR_TILE_HEIGHT
            -- offsets for vertical doors
            local verticalTopDoorOffset    = (areaHeight / 2) - V_DOOR_HEIGHT
            local verticalBottomDoorOffset = areaHeight / 2
            -- offsets for horizontal doors
            local horizontalLeftDoorOffset  = (areaWidth / 2) - H_DOOR_WIDTH
            local horizontalRightDoorOffset = areaWidth / 2
            -- create Doors objects based on location in area
            if area.doors.L then
                table.insert(self.doors, Door(
                    -- doorID, areaID, door colour, orientation
                    1, area.id, area.doors.L, 'vertical',
                    {
                        leftX      = area.x - WALL_OFFSET,
                        rightX     = area.x - WALL_OFFSET,
                        leftY      = area.y + verticalBottomDoorOffset,
                        rightY     = area.y + verticalTopDoorOffset,
                        openLeftX  = area.x - WALL_OFFSET,
                        openRightX = area.x - WALL_OFFSET,
                        openLeftY  = area.y + verticalBottomDoorOffset + V_DOOR_HEIGHT,
                        openRightY = area.y + verticalTopDoorOffset - V_DOOR_HEIGHT
                    },
                    -- width and height
                    V_DOOR_WIDTH, V_DOOR_HEIGHT
                ))
            end
            if area.doors.T then
                table.insert(self.doors, Door(
                    2, area.id, area.doors.T, 'horizontal',
                    {
                        leftX      = area.x + horizontalLeftDoorOffset,
                        rightX     = area.x + horizontalRightDoorOffset,
                        leftY      = area.y - WALL_OFFSET,
                        rightY     = area.y - WALL_OFFSET,
                        openLeftX  = area.x + horizontalLeftDoorOffset - H_DOOR_WIDTH,
                        openRightX = area.x + horizontalRightDoorOffset + H_DOOR_WIDTH,
                        openLeftY  = area.y - WALL_OFFSET,
                        openRightY = area.y - WALL_OFFSET
                    },
                    H_DOOR_WIDTH, H_DOOR_HEIGHT
                ))
            end
            if area.doors.R then
                table.insert(self.doors, Door(
                    3, area.id, area.doors.R, 'vertical',
                    {
                        leftX      = area.x + areaWidth,
                        rightX     = area.x + areaWidth,
                        leftY      = area.y + verticalBottomDoorOffset,
                        rightY     = area.y + verticalTopDoorOffset,
                        openLeftX  = area.x + areaWidth,
                        openRightX = area.x + areaWidth,
                        openLeftY  = area.y + verticalBottomDoorOffset + V_DOOR_HEIGHT,
                        openRightY = area.y + verticalTopDoorOffset - V_DOOR_HEIGHT
                    },
                    V_DOOR_WIDTH, V_DOOR_HEIGHT
                ))
            end
            if area.doors.B then
                table.insert(self.doors, Door(
                    4, area.id, area.doors.B, 'horizontal',
                    {
                        leftX      = area.x + horizontalLeftDoorOffset,
                        rightX     = area.x + horizontalRightDoorOffset,
                        leftY      = area.y + areaHeight,
                        rightY     = area.y + areaHeight,
                        openLeftX  = area.x + horizontalLeftDoorOffset - H_DOOR_WIDTH,
                        openRightX = area.x + horizontalRightDoorOffset + H_DOOR_WIDTH,
                        openLeftY  = area.y + areaHeight,
                        openRightY = area.y + areaHeight
                    },
                    H_DOOR_WIDTH, H_DOOR_HEIGHT
                ))
            end
        end
    end
end

--[[
    Updates the (x, y) location of <self.player> in relation to all 
    doors nearby as defined in GMapAreaDefinitions

    Params:
        none
    Returns:
        nil
]]
function DoorSystem:setPlayerLocation()
    local type = GMapAreaDefinitions[self.currentAreaID].type
    if type == 'area' then
        -- set Player location to the side WITHIN the area
        for _, door in pairs(self:getAreaDoors(self.currentAreaID)) do
            -- if the area IDs do not match then this door is in an adjacent area
            if door.areaID ~= self.currentAreaID then
                -- set Player on the current area side of the door
                self:setMatchingLocation(door)
            else
                self:setOppositeLocation(door)
            end
        end
    else
        -- use area.joins to get door adjacencies for corridors
        local joins = GMapAreaDefinitions[self.currentAreaID].joins
        -- set Player location to the side OUTSIDE the joined areas
        for _, join in pairs(joins) do
            self:setJoinLocation(join)
        end
        -- check if this corridor has door defined
        local doors = GMapAreaDefinitions[self.currentAreaID].doors
        if doors then
            for _, door in pairs(self:getAreaDoors(self.currentAreaID)) do
                self:setOppositeLocation(door)
            end
        end
    end
end

-- ========================== SET PLAYER LOCATION HELPERS ==========================

--[[
    Sets the Player object on the side of the door matching
    the door ID. E.g. door ID == 1 (L) so set the Entity on
    the left of this door

    Params:
        door: table - Door object we are setting Player location on
    Returns:
        nil 
]]
function DoorSystem:setMatchingLocation(door)
    if door.id == 1 then
        door.playerLocation = 'left'
    elseif door.id == 2 then
        door.playerLocation = 'above'
    elseif door.id == 3 then
        door.playerLocation = 'right'
    elseif door.id == 4 then
        door.playerLocation = 'below'
    end
end

--[[
    Sets the Player object on the side of the door opposite
    the door ID. E.g. door ID == 1 (L) so set the Entity on
    the right of this door

    Params:
        door: table - Door object we are setting Player location on
    Returns:
        nil
]]
function DoorSystem:setOppositeLocation(door)
    if door.id == 1 then --left
        door.playerLocation = 'right'
    elseif door.id == 2 then --top
        door.playerLocation = 'below'
    elseif door.id == 3 then --right
        door.playerLocation = 'left'
    elseif door.id == 4 then --bottom
        door.playerLocation = 'above'
    end
end

--[[
    Sets the Player object on the side of the door matching
    the door ID. E.g. door ID == 1 (L) so set the Player on
    the left of this door. Must query the <self.doors> table
    to find the correct door for the join being checked

    Params:
        join: table - corridor join definition door being updated
    Returns:
        nil
]]
function DoorSystem:setJoinLocation(join)
    -- join[1] == areaID as defined in GMapAreaDefinitions
    -- join[2] == location of this door in that area
    if join[2] == 'L' then
        local door = self:getAreaDoor(join[1], 1)
        door.playerLocation = 'left'
    elseif join[2] == 'T' then
        local door = self:getAreaDoor(join[1], 2)
        door.playerLocation = 'above'
    elseif join[2] == 'R' then
        local door = self:getAreaDoor(join[1], 3)
        door.playerLocation = 'right'
    elseif join[2] == 'B' then
        local door = self:getAreaDoor(join[1], 4)
        door.playerLocation = 'below'
    end
end

-- ========================== GET DOOR HELPERS ==========================

--[[
    Returns the area door defined by the door ID

    Params:
        areaID: number - ID of the area whose doors are being checked
        doorID: number - ID of the door 
    Returns:
        table: Door object
]]
function DoorSystem:getAreaDoor(areaID, doorID)
    for _, door in pairs(self.doors) do
        if door.areaID == areaID and door.id == doorID then
            return door
        end
    end
end

--[[
    Returns all the doors associated with the area defined by
    the area ID

    Params:
        areaID: number - ID of the area whose doors are being checked
    Returns:
        table: Door objects linked to the area
]]
function DoorSystem:getAreaDoors(areaID)
    local areaDoors = {}
    -- check if the area has any doors to return
    if not self.doors then
        return areaDoors
    end
    for _, door in pairs(self.doors) do
        if door.areaID == areaID then
            table.insert(areaDoors, door)
        end
    end
    -- get MapArea definition of the current area
    local areaDef = self.map:getAreaDefinition(areaID)
    -- check if the area has adjacent areas
    if areaDef.adjacentAreas ~= nil then
        -- check each adjacent area
        for _, area in pairs(areaDef.adjacentAreas) do
            -- and find the right door from the door system
            for _, door in pairs(self.doors) do
                if door.areaID == area.areaID and door.id == area.doorID then
                    table.insert(areaDoors, door)
                end
            end
        end
    end
    return areaDoors
end

--[[
    Returns all the doors associated with the areas joined by the
    corridor defined by the area ID

    Params:
        areaID: number - ID of the area whose doors are being checked
    Returns:
        table: Door objects linked to the area
]]
function DoorSystem:getCorridorDoors(areaID)
    local areaDoors = {}
    -- get the joins for this corridor
    local joins = GMapAreaDefinitions[areaID].joins
    -- for each joining area
    for _, join in pairs(joins) do
        -- join[1] == areaID to get doors from
        local doors = self:getAreaDoors(join[1])
        -- for each door in the joining area
        for _, door in pairs(doors) do
            -- join[2] == location to get door ID from
            if AREA_DOOR_IDS[door.id] == join[2] then
                table.insert(areaDoors, door)
            end
        end
    end
    -- check if this corridor also has doors
    local doors = GMapAreaDefinitions[areaID].doors
    if doors then
        for _, door in pairs(self.doors) do
            if door.areaID == areaID then
                table.insert(areaDoors, door)
            end
        end
    end
    return areaDoors
end

-- ========================== DOOR PROXIMITY ==========================

--[[
    Checks the doors in the given area for proximity using the
    helper functions within the door system. If the Player is
    in proximity and the door is locked this is also handled

    Params:
        area: table - MapArea object
    Returns:
        nil
]]
function DoorSystem:checkDoors(area)
    local doors = nil
    if area.type == 'area' then
        doors = self:getAreaDoors(area.id)
    else
        doors = self:getCorridorDoors(area.id)
    end
    if doors then
        for _, door in pairs(doors) do
            local proximity = self:checkDoorProximity(door)
            if proximity and door.isLocked then
                self:handleLockedDoor(door)
            end
        end
    end
end

--[[
    Checks for Player proximity to a Door object and opens
    the door if it is not locked. If it is locked it checks
    if the Player as the key

    Params:
        door: table - Door object the Player is in proximity to
    Returns:
        nil
]]
function DoorSystem:checkDoorProximity(door)
    if door:proximity(self.playerX, self.playerY) then
        -- check if door is locked
        if not door.isLocked then
            self:open(door)
        else
            if self.player.keys[door.colour] then
                -- if locked and has key open the door
                door.isLocked = false
                self:open(door)
                if DOOR_IDS[door.colour] == 3 then self.player.keys['blue']  = false end
                if DOOR_IDS[door.colour] == 4 then self.player.keys['red']   = false end
                if DOOR_IDS[door.colour] == 5 then self.player.keys['green'] = false end
            end
        end
        return true
    else
        self:close(door)
        return false
    end
end

--[[
    Corrects Player object (x, y) if the door is locked

    Params:
        door: table - door object
    Returns:
        nil
]]
function DoorSystem:handleLockedDoor(door)
    if door.playerLocation == 'left' then
        if self.player.x > door.leftX + V_DOOR_WIDTH - ENTITY_WIDTH then
            self.player.x = door.leftX + V_DOOR_WIDTH - ENTITY_WIDTH
        end
    end
    if door.playerLocation == 'above' then
        if self.player.y > door.leftY + H_DOOR_HEIGHT - ENTITY_HEIGHT then
            self.player.y = door.leftY + H_DOOR_HEIGHT - ENTITY_HEIGHT
        end
    end
    if door.playerLocation == 'right' then
        if self.player.x < door.leftX then
            self.player.x = door.leftX
        end
    end
    if door.playerLocation == 'below' then
        if self.player.y < door.leftY then
            self.player.y = door.lefty
        end
    end
end

-- ========================== TWEEN DOORS OPEN/CLOSED ==========================

--[[
    Tweening function for moving the Door objects either up, down,
    left, or right depending on the orientation and location of the
    doors. This will give the effect of the doors opening

    Params:
        door: table - Door object for the door being opened
    Returns:
        nil
]]
function DoorSystem:open(door)
    if not door.isOpen then
        door.isOpen = true
        Audio_Door()
        if door.orientation == 'horizontal' then
            -- tween callback function for opening/closing doors
            Timer.tween(0.1, {
                [door] = {leftX = door.openLeftX, rightX = door.openRightX}
            })
        else
            Timer.tween(0.1, {
                [door] = {leftY = door.openLeftY, rightY = door.openRightY}
            })
        end
    end
end

--[[
    Tweening function for moving the Door objects either up, down,
    left, or right depending on the orientation and location of the
    doors. This will give the effect of the doors closing

    Params:
        door: table - Door object for the door being closed
    Returns:
        nil
]]
function DoorSystem:close(door)
    if door.isOpen then
        door.isOpen = false
        Audio_Door()
        if door.orientation == 'horizontal' then
            -- tween callback function for opening/closing doors - reuse under door values
            Timer.tween(0.1, {
                [door] = {leftX = door.underLeftX, rightX = door.underRightX}
            })
        else
            Timer.tween(0.1, {
                [door] = {leftY = door.underLeftY, rightY = door.underRightY}
            })
        end
    end
end
