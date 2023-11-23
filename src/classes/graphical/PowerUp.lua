--[[
    PowerUp: class

    Description:
        Creates, updates, and renders PowerUp objects such as
        ammo, health, one shot boss kill, 2x speed, and invincibility
]]

PowerUp = Class{}

--[[
    PowerUp constructor

    Params:
        id:     number - ID number of thsi PowerUp object
        areaID: number - area ID the powerup will spawn in
        x:      number - x coordinate
        y:      number - y coordinate
    Returns:
        nil
]]
function PowerUp:init(id, areaID, x, y)
    self.id = id
    self.areaID = areaID
    self.x = x
    self.y = y
    self.type = 'powerup'
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
    love.graphics.draw(GTextures['powerups'],
        GQuads['powerups'][self.id],
        self.x, self.y,
        0,
        2.5, 2.5
    )
end

--[[
    Factory method for returning instances of PowerUp

    Params:
        id:     number - crate ID
        areaID: number - area ID
        x:      number - x coordinate
        y:      number - y coordinate
    Returns:
        table: PowerUp instance
]]
function PowerUp:factory(id, areaID, x, y)
    return PowerUp(
        id, areaID,
        -- center the powerup underneath a crate
        x + (CRATE_WIDTH / 2) - (POWERUP_WIDTH / 2), y + (CRATE_WIDTH / 2) - (POWERUP_HEIGHT / 2)
    )
end
