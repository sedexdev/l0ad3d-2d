--[[
    DoorSystem: class

    Description:
        A door system is an independent mechanism for handling how
        doors behave when the Player object interacts wth them. The
        door system controls opening and closing doors, and unlocking
        doors
]]

DoorSystem = Class{}

--[[
    DoorSystem constructor. Creates a store for the doors in the
    system and knows which door the Player is currently interacting with 

    Params:
        player: table - Player object
        map:    table - Map object used to get door references for adjacent areas
    Returns:
        nil
]]
function DoorSystem:init(player, map)
    self.player = player
    self.map = map
    self.doors = {}
    self.currentDoor = nil
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
    -- close any doors that the Player is no longer in proximity with
    for _, door in pairs(self.doors) do
        if not door:proximity(self.player) then
            self:close(door)
        end
    end
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
            local areaWidth = area.width * FLOOR_TILE_WIDTH
            local areaHeight = area.height * FLOOR_TILE_HEIGHT
            -- offsets for vertical doors
            local verticalTopDoorOffset = (areaHeight / 2) - V_DOOR_HEIGHT
            local verticalBottomDoorOffset = areaHeight / 2
            -- offsets for horizontal doors
            local horizontalLeftDoorOffset = (areaWidth / 2) - H_DOOR_WIDTH
            local horizontalRightDoorOffset = areaWidth / 2
            -- create Doors objects based on location in area
            if area.doors.L then
                table.insert(self.doors, Door(
                    -- doorID, areaID, door colour, orientation
                    1, area.id, area.doors.L, 'vertical',
                    -- leftX, rightX
                    area.x - WALL_OFFSET, area.x - WALL_OFFSET,
                    -- leftY, rightY
                    area.y + verticalBottomDoorOffset, area.y + verticalTopDoorOffset
                ))
            end
            if area.doors.T then
                table.insert(self.doors, Door(
                    2, area.id, area.doors.T, 'horizontal',
                    area.x + horizontalLeftDoorOffset, area.x + horizontalRightDoorOffset,
                    area.y - WALL_OFFSET, area.y - WALL_OFFSET
                ))
            end
            if area.doors.R then
                table.insert(self.doors, Door(
                    3, area.id, area.doors.R, 'vertical',
                    area.x + areaWidth, area.x + areaWidth,
                    area.y + verticalBottomDoorOffset, area.y + verticalTopDoorOffset
                ))
            end
            if area.doors.B then
                table.insert(self.doors, Door(
                    4, area.id, area.doors.B, 'horizontal',
                    area.x + horizontalLeftDoorOffset, area.x + horizontalRightDoorOffset,
                    area.y + areaHeight, area.y + areaHeight
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
    local areaID = self.player.currentArea.id
    local type = GMapAreaDefinitions[areaID].type
    if type == 'area' then
        -- set Player location to the side WITHIN the area
        for _, door in pairs(self:getAreaDoors(areaID)) do
            -- if the area IDs do not match then this door is in an adjacent area
            if door.areaID ~= areaID then
                -- set Player on the current area side of the door
                self:setMatchingLocation(door)
            else
                self:setOppositeLocation(door)
            end
        end
    else
        -- use area.joins to get door adjacencies for corridors
        local joins = GMapAreaDefinitions[areaID].joins
        -- set Player location to the side OUTSIDE the joined areas
        for _, join in pairs(joins) do
            self:setJoinLocation(join)
        end
        -- check if this corridor has door defined
        local doors = GMapAreaDefinitions[areaID].doors
        if doors then
            for _, door in pairs(self:getAreaDoors(areaID)) do
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
    if areaDef.adjacentAreas then
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

-- ========================== TWEEN DOORS OPEN/CLOSED ==========================

--[[
    Tweening function for reducing the pixel size of the doors
    to 0 based on their orientation. This will give the effect
    that the doors have opened

    Params:
        door: table - Door object for the door being opened
    Returns:
        nil
]]
function DoorSystem:open(door)
    if not door.isOpen then
        if door.orientation == 'horizontal' then
            -- tween callback function for opening/closing doors
            Timer.tween(0.2, {
                [door] = {leftX = door.leftX - H_DOOR_WIDTH, rightX = door.rightX + H_DOOR_WIDTH}
            })
            door.isOpen = true
        else
            Timer.tween(0.2, {
                [door] = {leftY = door.leftY + V_DOOR_HEIGHT, rightY = door.rightY - V_DOOR_HEIGHT}
            })
            door.isOpen = true
        end
    end
end

--[[
    Tweening function for increasing the pixel size of the doors
    to 32 based on their orientation. This will give the effect
    that the doors have closed

    Params:
        door: table - Door object for the door being closed
    Returns:
        nil
]]
function DoorSystem:close(door)
    if door.isOpen then
        if door.orientation == 'horizontal' then
            -- tween callback function for opening/closing doors
            Timer.tween(0.2, {
                [door] = {leftX = door.leftX + H_DOOR_WIDTH, rightX = door.rightX - H_DOOR_WIDTH}
            })
            door.isOpen = false
        else
            Timer.tween(0.2, {
                [door] = {leftY = door.leftY - V_DOOR_HEIGHT, rightY = door.rightY + V_DOOR_HEIGHT}
            })
            door.isOpen = false
        end
    end
end
