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
        player: table - the Player object
    Returns:
        nil
]]
function Door:proximity(player)
    if self.orientation == 'horizontal' then
        -- x proximity is the same no matter which side the Player object is on
        local xProximity = player.x + 64 > self.leftX and (player.x + player.width) - 64 < self.rightX + H_DOOR_WIDTH
        if self.playerLocation == 'above' then
            if (self.leftY - (player.y + player.height) <= 200 or self.rightY - (player.y + player.height) <= 200) and xProximity then
                return true
            end
            return false
        end
        if self.playerLocation == 'below' then
            if (player.y - (self.leftY + H_DOOR_HEIGHT) <= 200 or player.y - (self.rightY + H_DOOR_HEIGHT) <= 200) and xProximity then
                return true
            end
            return false
        end
    else
        -- y proximity is the same no matter which side the Player object is on
        local yProximity = player.y + 64 > self.rightY and (player.y + player.height) - 64 < self.leftY + V_DOOR_HEIGHT
        if self.playerLocation == 'left' then
            if (self.leftX - (player.x + player.width) <= 200 or self.rightX - (player.x + player.width) <= 200) and yProximity then
                return true
            end
            return false
        end
        if self.playerLocation == 'right' then
            if (player.x - (self.leftX + H_DOOR_WIDTH) <= 200 or player.x - (self.rightX + H_DOOR_WIDTH) <= 200) and yProximity then
                return true
            end
            return false
        end
    end
end
