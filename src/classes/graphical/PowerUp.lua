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
        id:     number - ID number of this PowerUp object
        type:   string - powerup type
        areaID: number - area ID the powerup will spawn in
        x:      number - x coordinate
        y:      number - y coordinate
    Returns:
        nil
]]
function PowerUp:init(id, type, areaID, x, y)
    self.id      = id
    self.type    = type
    self.areaID  = areaID
    self.x       = x
    self.y       = y
    self.width   = POWERUP_WIDTH
    self.height  = POWERUP_HEIGHT
    self.remove  = false
    -- rotational values
    self.degrees = math.random(1, 359)
    self.angle   = 0
    -- quadID table
    self.quadIDs = {
        ['doubleSpeed']     = 1,
        ['oneShotBossKill'] = 2,
        ['ammo']            = 3,
        ['health']          = 4,
        ['invincible']      = 5,
    }
end

--[[
    PowerUp update function. Updates the (x, y) of the powerup
    so it rotates in a circle

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function PowerUp:update(dt)
    self.degrees = self.degrees + 1
    self.angle = self.degrees * DEGREES_TO_RADIANS
    if self.degrees > 360 then
        self.degrees = 1
        self.angle = 0
    end
end

--[[
    PowerUp render function

    == Notes on LOVE2D draw order == 

    Now LÖVE performs a series of transformations to the image: 

    First a displacement by -ox,-oy (which will be in image coordinates 
    because it's the first one), then skew, then scale, then rotation and
    finally a displacement by (x, y) (the draw coordinates, which will be in 
    screen coordinates because it's the last one).

    Params:
        none
    Returns:
        nil
]]
function PowerUp:render()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(GTextures['powerups'],
        GQuads['powerups'][self.quadIDs[self.type]],
        self.x + (self.width / 2), self.y + (self.height / 2),
        self.angle,
        2.5, 2.5,
        (self.width / 4) - 8, (self.height / 4) - 8
    )
end
