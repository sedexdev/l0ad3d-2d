--[[
    Door: class

    Description:
        Represents a pair of doors, a left and right, that have
        have an id, orientation, colour, and (x, y) coordinates
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
        width:          number - y coordinate of the left door in the pair
        heigt:          number - y coordinate of the right door in the pair
    Returns:
        nil
]]
function Door:init(id, areaID, colour, orientation, leftX, rightX, leftY, rightY, width, height)
    self.id             = id
    self.areaID         = areaID
    self.colour         = colour
    self.orientation    = orientation
    -- set left and right (x, y) for under doors so they aren't effected by tweening
    self.underLeftX     = leftX
    self.underRightX    = rightX
    self.underLeftY     = leftY
    self.underRightY    = rightY
    -- set left and right (x, y) for coloured doors
    self.leftX          = leftX
    self.rightX         = rightX
    self.leftY          = leftY
    self.rightY         = rightY
    self.width          = width
    self.height         = height
    -- flag to check if the door is open
    self.isOpen         = false
    -- boolean flag to check if door is locked
    self.isLocked       = DOOR_IDS[self.colour] > 2 and true or false
    -- side of this door the player is on. Nil at initilasation and updated as Player enters a new area
    self.playerLocation = nil
end

--[[
    Doors render function. Renders out the 2 doors that form this
    door pair, along with the under door graphic

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
    depending on which side the Player is on defined by 
    <self.playerLocation>

    Params:
        x: number - Player x coordinate 
        y: number - Player y coordinate 
    Returns:
        nil
]]
function Door:proximity(x, y)
    if self.orientation == 'horizontal' then
        -- x proximity is the same no matter which side the Player object is on
        local xProximity = (x + ENTITY_CORRECTION) > self.leftX and (x + ENTITY_WIDTH) - ENTITY_CORRECTION < (self.rightX + H_DOOR_WIDTH)
        -- y conditions
        local aboveYProximity = (self.leftY - (y + ENTITY_HEIGHT) <= DOOR_PROXIMITY and self.rightY - (y + ENTITY_HEIGHT) <= DOOR_PROXIMITY) and xProximity
        local belowYProximity = (y - (self.leftY + H_DOOR_HEIGHT) <= DOOR_PROXIMITY and y - (self.rightY + H_DOOR_HEIGHT) <= DOOR_PROXIMITY) and xProximity
        if self.playerLocation == 'above' then
            return aboveYProximity
        end
        if self.playerLocation == 'below' then
            return belowYProximity
        end
    else
        -- y proximity is the same no matter which side the Player object is on
        local yProximity = y + ENTITY_CORRECTION > self.rightY and (y + ENTITY_HEIGHT) - ENTITY_CORRECTION < (self.leftY + V_DOOR_HEIGHT)
        -- x conditions
        local leftXProximity = (self.leftX - (x + ENTITY_WIDTH) <= DOOR_PROXIMITY and self.rightX - (x + ENTITY_WIDTH) <= DOOR_PROXIMITY) and yProximity
        local rightXProximity = (x - (self.leftX + H_DOOR_WIDTH) <= DOOR_PROXIMITY and x - (self.rightX + H_DOOR_WIDTH) <= DOOR_PROXIMITY) and yProximity
        if self.playerLocation == 'left' then
            return leftXProximity
        end
        if self.playerLocation == 'right' then
            return rightXProximity
        end
    end
end
