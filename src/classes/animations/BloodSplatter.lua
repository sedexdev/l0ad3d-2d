--[[
    BloodSplatter: class

    Description:
        Creates an object that renders out a blood stain after
        a grunt type Entity object has been killed
]]

BloodSplatter = Class{}

--[[
    BloodSplatter constructor

    Params:
        texture:   Image  - image used to render quads
        x:         number - x coordinate of texture
        y:         number - y coordinate of texture
        direction: string - direction of object
    Returns:
        nil
]]
function BloodSplatter:init(texture, x, y, direction)
    self.texture = texture
    self.x = x
    self.y = y
    self.angle = ENTITY_ANGLES[direction]
end

--[[
    BloodSplatter render function

    Params:
        none
    Returns:
        nil
]]
function BloodSplatter:render()
    love.graphics.draw(self.texture,
        GQuads['blood-splatter'][1],
        self.x, self.y,
        self.angle,
        1.2, 1.2
    )
end
