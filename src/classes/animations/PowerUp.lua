--[[
    PowerUp: class

    Description:
        Creates, updates, and renders PowerUp objects such as
        ammo, health, one shot boss kill, 2x speed, and invincibility.
        Also renders crates to hide powerups behind
]]

PowerUp = Class{}

--[[
    PowerUp constructor

    Params:
        id:     number - ID number of thsi PowerUp object
        areaID: number - area ID the powerup will spawn in
        x:      number - x coordinate
        y:      number - y coordinate
        type:   string - type ( powerup | crate | key )
        quadID: number - ID to index GQuads with
    Returns:
        nil
]]
function PowerUp:init(id, areaID, x, y, type, quadID)
    self.id = id
    self.areaID = areaID
    self.x = x
    self.y = y
    self.type = type
    self.quadID = quadID
    self.width = POWERUP_WIDTH
    self.height = POWERUP_HEIGHT
end

--[[
    PowerUp render function

    Params:
        none
    Returns:
        nil
]]
function PowerUp:render()
    love.graphics.setColor(1, 1, 1, 1)
    local quad = self.type == 'powerup' and GQuads['powerups'][self.id] or GQuads[self.type..'s'][self.quadID]
    love.graphics.draw(GTextures[self.type..'s'],
        quad,
        self.x, self.y,
        0,
        2.5, 2.5
    )
end
