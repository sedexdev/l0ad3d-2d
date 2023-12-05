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
        id:         number - ID of this animation
        texture:    Image  - Smoke PNG Image file
        animations: table  - animation idices for rendering
        x:          number - x cordinate 
        y:          number - y cordinate
    Returns:
        nil
]]
function Smoke:init(id, animations, x, y)
    self.id         = id
    self.texture    = animations.texture
    self.animations = animations.animations
    self.x          = x
    self.y          = y
    self.finalFrame = 8
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
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.texture, GQuads['smoke'][currentFrame], self.x, self.y, 0, 2, 2)
end
