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
    DebugFile:write(os.date('%A, %B %d %Y at %I:%M:%S %p - ') .. debug.getinfo(2, "S").source .. ':' .. debug.getinfo(1, 'n').name .. '\n')
    self.texture = texture
    self.x = x + (ENTITY_WIDTH / 2)
    self.y = y + (ENTITY_HEIGHT / 2)
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
    DebugFile:write(os.date('%A, %B %d %Y at %I:%M:%S %p - ') .. debug.getinfo(2, "S").source .. ':' .. debug.getinfo(1, 'n').name .. '\n')
    love.graphics.draw(self.texture,
        GQuads['blood-splatter'][1],
        self.x, self.y,
        self.angle,
        1.2, 1.2
    )
end
