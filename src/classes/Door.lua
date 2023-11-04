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
        id: number - ID of this door pair
        colour: string - colour of the doors
        orientation: string - orientation of these doors
        playerLocation: string - side of this door the Player is on
        leftX: number - x coordinate of the left door in the pair 
        rightX: number - x coordinate of the right door in the pair
        leftY: number - y coordinate of the left door in the pair
        rightY: number - y coordinate of the right door in the pair
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

    TODO: fix tweening bug that causes Player to able to pass over the door after its been tweened open
            - use boolean flag to declare 'isOpen' status
            - if the door is open change the proximity check by an offset of H_DOOR_WIDTH or V_DOOR_HEIGHT

    Params:
        player: table - the Player object
    Returns:
        nil
]]
function Door:proximity(player)
    local playerCorrection = 120
    local doorProximity = 250
    if self.orientation == 'horizontal' then
        -- x proximity is the same no matter which side the Player object is on
        local xProximity = player.x + playerCorrection > self.leftX and (player.x + player.width) - playerCorrection < self.rightX + H_DOOR_WIDTH
        if self.playerLocation == 'above' then
            if (self.leftY - (player.y + player.height) <= doorProximity or self.rightY - (player.y + player.height) <= doorProximity) and xProximity then
                return true
            end
            return false
        end
        if self.playerLocation == 'below' then
            if (player.y - (self.leftY + H_DOOR_HEIGHT) <= doorProximity or player.y - (self.rightY + H_DOOR_HEIGHT) <= doorProximity) and xProximity then
                return true
            end
            return false
        end
    else
        -- y proximity is the same no matter which side the Player object is on
        local yProximity = player.y + playerCorrection > self.rightY and (player.y + player.height) - playerCorrection < self.leftY + V_DOOR_HEIGHT
        if self.playerLocation == 'left' then
            if (self.leftX - (player.x + player.width) <= doorProximity or self.rightX - (player.x + player.width) <= doorProximity) and yProximity then
                return true
            end
            return false
        end
        if self.playerLocation == 'right' then
            if (player.x - (self.leftX + H_DOOR_WIDTH) <= doorProximity or player.x - (self.rightX + H_DOOR_WIDTH) <= doorProximity) and yProximity then
                return true
            end
            return false
        end
    end
end
