--[[
    Doors: class

    Description:
        Represents a pair of doors, a left and right, that have
        have an id, orientation, colour, and (x, y) coordinates.
        They also have collision detection relative to the
        Player object and have tweening functionality to give
        the effect of opening with the Player is in close proximity
]]

Doors = Class{}

--[[
    Doors constructor

    Params:
        id: number - ID of this door pair
        area: number - areaID the doors are located in
        colour: string - colour of the doors
        orientation: string - orientation of these doors
        leftX: number - x coordinate of the left door in the pair 
        rightX: number - x coordinate of the right door in the pair
        leftY: number - y coordinate of the left door in the pair
        rightY: number - y coordinate of the right door in the pair
    Returns:
        nil
]]
function Doors:init(id, area, colour, orientation, leftX, rightX, leftY, rightY)
    self.id = id
    self.area = area
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
    -- boolean flag to check if the door is open
    self.isOpen = false
end

--[[
    Doors update function. Manages tweening the doors open and
    closed as the Player object gets closer and further away

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function Doors:update(dt)
    Timer.update(dt)
end

--[[
    Doors render function. Renders out the 2 doors that form this
    door pair
    
    TODO: fix under door (x, y) so they stay in place when doors open

    Params:
        none
    Returns:
        none
]]
function Doors:render()
    -- draw out the under doors
    love.graphics.draw(GTextures[self.orientation..'-doors'], GQuads[self.orientation..'-doors'][DOOR_IDS['under']], self.underLeftX, self.underLeftY, 0, 5, 5)
    love.graphics.draw(GTextures[self.orientation..'-doors'], GQuads[self.orientation..'-doors'][DOOR_IDS['under']], self.underRightX, self.underRightY, 0, 5, 5)
    -- draw out both coloured doors
    love.graphics.draw(GTextures[self.orientation..'-doors'], GQuads[self.orientation..'-doors'][DOOR_IDS[self.colour]], self.leftX, self.leftY, 0, 5, 5)
    love.graphics.draw(GTextures[self.orientation..'-doors'], GQuads[self.orientation..'-doors'][DOOR_IDS[self.colour]], self.rightX, self.rightY, 0, 5, 5)
end

--[[
    Tweening function for reducing the pixel size of the doors
    to 0 based on their orientation. This will give the effect
    that the doors have opened

    Params:
        none
    Returns:
        nil
]]
function Doors:open()
    if not self.isOpen then
        if self.orientation == 'horizontal' then
            -- tween callback function for opening/closing doors
            Timer.tween(0.2, {
                [self] = {leftX = self.leftX - H_DOOR_WIDTH, rightX = self.rightX + H_DOOR_WIDTH}
            })
            self.isOpen = true
        else
            Timer.tween(0.2, {
                [self] = {leftY = self.leftY + V_DOOR_HEIGHT, rightY = self.rightY - V_DOOR_HEIGHT}
            })
            self.isOpen = true
        end
    end
end

--[[
    Tweening function for increasing the pixel size of the doors
    to 32 based on their orientation. This will give the effect
    that the doors have closed

    Params:
        none
    Returns:
        nil
]]
function Doors:close()
    if self.isOpen then
        if self.orientation == 'horizontal' then
            -- tween callback function for opening/closing doors
            Timer.tween(0.2, {
                [self] = {leftX = self.leftX + H_DOOR_WIDTH, rightX = self.rightX - H_DOOR_WIDTH}
            })
            self.isOpen = false
        else
            Timer.tween(0.2, {
                [self] = {leftY = self.leftY - V_DOOR_HEIGHT, rightY = self.rightY + V_DOOR_HEIGHT}
            })
            self.isOpen = false
        end
    end
end