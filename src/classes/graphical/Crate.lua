--[[
    Crate: class

    Description:
        Intialises a Crate object and renders out the quad
]]

Crate = Class{}

--[[
    Crate constructor

    Params:
        id:     number - key ID
        areaID: number - area ID where the key is spawned
        x:      number - x coordinate
        y:      number - y coordinate
    Returns:
        nil
]]
function Crate:init(id, areaID, x, y)
    self.id     = id
    self.areaID = areaID
    self.x      = x
    self.y      = y
    self.width  = CRATE_WIDTH
    self.height = CRATE_HEIGHT
end

--[[
    Crate render function

    Params:
        none
    Returns:
        nil
]]
function Crate:render()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(GTextures['crate'],
        GQuads['crate'][1],
        self.x, self.y,
        0,
        2.7, 2.7
    )
end
