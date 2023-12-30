--[[
    Smoke: class

    Description:
        Creates Smoke graphics to be rendered over a set interval
        when a Bullet hits a wall
]]

Smoke = Class{}

--[[
    Smoke constructor

    Params:
        id:        number - ID of this animation
        texture:   Image  - Smoke PNG Image file
        x:         number - x cordinate 
        y:         number - y cordinate
        direction: string - direction the Player is facing 
    Returns:
        nil
]]
function Smoke:init(id, texture, x, y, direction)
    self.id         = id
    self.texture    = texture
    self.x          = x
    self.y          = y
    self.direction  = direction
    self.animations = Animation({1, 2, 3, 4, 5, 6, 7, 8}, SMOKE_INTERVAL)
    self.remove     = false
end

--[[
    Smoke update function. Updates the animations to render
    each phase of the smoke in order

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function Smoke:update(dt)
    self.animations:update(dt)
    if self.animations:getCurrentFrame() == 8 then
        self.remove = true
    end
end

--[[
    Smoke render function

    Params:
        none
    Returns:
        nil
]]
function Smoke:render()
    local currentFrame = self.animations:getCurrentFrame()
    local xOffset = 0
    local yOffset = 0
    if self.direction == "east" or self.direction == "west" then
        yOffset = SMOKE_OFFSET
    end
    if self.direction == "north" or self.direction == "south" then
        xOffset = SMOKE_OFFSET
    end
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.texture, GQuads['smoke'][currentFrame], self.x - xOffset, self.y - yOffset, 0, 2, 2)
end
