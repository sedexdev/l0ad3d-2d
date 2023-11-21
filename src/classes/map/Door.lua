--[[
    Door: class

    Description:
        Represents a pair of doors, a left and right, that have
        have an id, orientation, colour, and (x, y) coordinates.
        They also have collision detection relative to the
        Player object and have tweening functionality to give
        the effect of opening with the Player is in close proximity
]]

Door = Class{}

--[[
    Doors constructor

    Params:
        id:             number - ID of this door pair
        colour:         string - colour of the doors
        orientation:    string - orientation of these doors
        playerLocation: string - side of this door the Player is on
        leftX:          number - x coordinate of the left door in the pair 
        rightX:         number - x coordinate of the right door in the pair
        leftY:          number - y coordinate of the left door in the pair
        rightY:         number - y coordinate of the right door in the pair
    Returns:
        nil
]]
function Door:init(id, areaID, colour, orientation, leftX, rightX, leftY, rightY)
    self.id = id
    self.areaID = areaID
    self.colour = colour
    self.orientation = orientation
    -- set left and right (x, y) for under doors so they aren't effected by tweening
    self.underLeftX = leftX
    self.underRightX = rightX
    self.underLeftY = leftY
    self.underRightY = rightY
    -- set left and right (x, y) for coloured doors
    self.leftX = leftX
    self.rightX = rightX
    self.leftY = leftY
    self.rightY = rightY
    -- flag to check if the door is open
    self.isOpen = false
    -- boolean flag to check if door is locked
    self.isLocked = DOOR_IDS[self.colour] > 2 and true or false
    -- side of this door the player is on. Nil at initilasation and updated as Player enters a new area
    self.playerLocation = nil
end

--[[
    Doors render function. Renders out the 2 doors that form this
    door pair

    Params:
        none
    Returns:
        none
]]
function Door:render()
    -- draw out the under doors
    love.graphics.draw(GTextures[self.orientation..'-doors'], GQuads[self.orientation..'-doors'][DOOR_IDS['under']], self.underLeftX, self.underLeftY, 0, 5, 5)
    love.graphics.draw(GTextures[self.orientation..'-doors'], GQuads[self.orientation..'-doors'][DOOR_IDS['under']], self.underRightX, self.underRightY, 0, 5, 5)
    -- draw out both coloured doors
    love.graphics.draw(GTextures[self.orientation..'-doors'], GQuads[self.orientation..'-doors'][DOOR_IDS[self.colour]], self.leftX, self.leftY, 0, 5, 5)
    love.graphics.draw(GTextures[self.orientation..'-doors'], GQuads[self.orientation..'-doors'][DOOR_IDS[self.colour]], self.rightX, self.rightY, 0, 5, 5)
end

--[[
    Checks the proximity of the Player object to the door
    and calls Doors:open() or Doors:close() depending on
    which side the Player is on defined by <self.playerLocation>

    Params:
        player: table - Player object
    Returns:
        nil
]]
function Door:proximity(player)
    -- locked door conditions
    local aboveLocked = (player.y + player.height) > self.leftY + H_DOOR_HEIGHT and (player.y + player.height) > (self.rightY + H_DOOR_HEIGHT)
    local belowLocked = player.y < (self.leftY - H_DOOR_HEIGHT) and player.y < (self.rightY - H_DOOR_HEIGHT)
    local leftLocked = (player.x + player.width) > self.leftX + V_DOOR_WIDTH and (player.x + player.width) > (self.rightX + V_DOOR_WIDTH)
    local rightLocked = player.x < (self.leftX - V_DOOR_WIDTH) and player.x < (self.rightX - V_DOOR_WIDTH)
    if self.orientation == 'horizontal' then
        -- x proximity is the same no matter which side the Player object is on
        local xProximity = (player.x + ENTITY_CORRECTION) > self.leftX and (player.x + player.width) - ENTITY_CORRECTION < (self.rightX + H_DOOR_WIDTH)
        -- proximity conditions
        local aboveYProximity = (self.leftY - (player.y + player.height) <= DOOR_PROXIMITY and self.rightY - (player.y + player.height) <= DOOR_PROXIMITY) and xProximity
        local belowYProximity = (player.y - (self.leftY + H_DOOR_HEIGHT) <= DOOR_PROXIMITY and player.y - (self.rightY + H_DOOR_HEIGHT) <= DOOR_PROXIMITY) and xProximity
        if self.playerLocation == 'above' then
            return self:proximityHelper(aboveLocked, aboveYProximity)
        end
        if self.playerLocation == 'below' then
            return self:proximityHelper(belowLocked, belowYProximity)
        end
    else
        -- y proximity is the same no matter which side the Player object is on
        local yProximity = player.y + ENTITY_CORRECTION > self.rightY and (player.y + player.height) - ENTITY_CORRECTION < (self.leftY + V_DOOR_HEIGHT)
        -- proximity conditions
        local leftXProximity = (self.leftX - (player.x + player.width) <= DOOR_PROXIMITY and self.rightX - (player.x + player.width) <= DOOR_PROXIMITY) and yProximity
        local rightXProximity = (player.x - (self.leftX + H_DOOR_WIDTH) <= DOOR_PROXIMITY and player.x - (self.rightX + H_DOOR_WIDTH) <= DOOR_PROXIMITY) and yProximity
        if self.playerLocation == 'left' then
            return self:proximityHelper(leftLocked, leftXProximity)
        end
        if self.playerLocation == 'right' then
            return self:proximityHelper(rightLocked, rightXProximity)
        end
    end
end

--[[
    Reduces bulk in the <self:proximity> function by evaluating
    the arguments for doors in a locked state and then checking
    the appropriate condition for which side of the door the 
    Entity object is currently on
    
    Params:
        lockedCondition:   boolean - condition to evaluate if the door is locked
        locationCondition: boolean - Entity location dependent condition 
    Returns:
        boolean: true if either of the arguments are true, false otherwise 
]]
function Door:proximityHelper(lockedCondition, locationCondition)
    if self.isLocked then
        return lockedCondition
    end
    if locationCondition then
        return true
    end
    return false
end
