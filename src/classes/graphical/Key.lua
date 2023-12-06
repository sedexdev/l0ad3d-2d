--[[
    Key: class

    Description:
        Intialises a Key object and renders out the quad to display
        it in the location defined in GKeyDefinitions
]]

Key = Class{}

--[[
    Key constructor

    Params:
        id:     number - key ID
        areaID: number - area ID where the key is spawned
        x:      number - x coordinate
        y:      number - y coordinate
    Returns:
        nil
]]
function Key:init(id, areaID, x, y)
    self.id     = id
    self.areaID = areaID
    self.x      = x
    self.y      = y
    self.width  = KEY_WIDTH
    self.height = KEY_HEIGHT
    self.remove = false
end

--[[
    Key render function

    Params:
        none
    Returns:
        nil
]]
function Key:render()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(GTextures['keys'],
        GQuads['keys'][self.id],
        self.x, self.y,
        0,
        2.5, 2.5
    )
end
