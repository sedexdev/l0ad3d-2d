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
    self.id = id
    self.areaID = areaID
    self.x = x
    self.y = y
    self.type = 'crate'
    self.width = CRATE_WIDTH
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
        2.5, 2.5
    )
end

--[[
    Factory method for returning instances of Crate

    Params:
        id:     number - crate ID
        areaID: number - area ID
        x:      number - x coordinate
        y:      number - y coordinate
    Returns:
        table: PowerUp instance
]]
function Crate:factory(id, areaID, x, y)
    return Crate(id, areaID, x, y)
end
