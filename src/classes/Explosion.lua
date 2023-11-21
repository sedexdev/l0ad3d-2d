--[[
    Explosion: class

    Description:
        Creates Explosion graphics to be rendered over a set interval
        when a crate or turret is destroyed
]]

Explosion = Class{}

--[[
    Explosion constructor

    Params:
        texture:    Image  - explosion PNG Image file
        animations: table  - animation idices for rendering
        x:          number - x cordinate 
        y:          number - y cordinate
    Returns:
        nil
]]
function Explosion:init(texture, animations, x, y)
    self.texture = texture
    self.animations = animations
    self.x = x
    self.y = y
end

--[[
    Explosion update function. Updates the animations to render
    each phase of the explosion in order

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function Explosion:update(dt)
    self.animations:update(dt)
end

--[[
    Explosion render function

    Params:
        none
    Returns:
        nil
]]
function Explosion:render()
    local currentFrame = self.animations:getCurrentFrame()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.texture,
        GQuads['explosion'][currentFrame],
        self.x, self.y,
        0,
        5, 5
    )
end
