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
        x:         number - x coordinate of texture
        y:         number - y coordinate of texture
        direction: string - direction of object
    Returns:
        nil
]]
function BloodSplatter:init(x, y, direction)
    self.x = x + (ENTITY_WIDTH / 2)
    self.y = y + (ENTITY_HEIGHT / 2)
    self.texture = GTextures['blood-splatter']
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
        1.2, 1.2,
        ENTITY_WIDTH / 2,
        ENTITY_HEIGHT / 2
    )
end

--[[
    Factory method for returning instances of BloodSplatter

    Params:
        x:         number - x coordinate of texture
        y:         number - y coordinate of texture
        direction: string - direction of object
    Returns:
        table: PowerUp instance
]]
function BloodSplatter:factory(x, y, direction)
    return BloodSplatter(x, y, direction)
end
