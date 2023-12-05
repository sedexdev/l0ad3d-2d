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
        id:      number - ID of this animation
        texture: Image  - texture of this animation
        x:       number - x cordinate 
        y:       number - y cordinate
    Returns:
        nil
]]
function Explosion:init(id, texture, x, y)
    self.id         = id
    self.texture    = texture
    self.x          = x
    self.y          = y
    self.animations = Animation({1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16}, EXPLOSION_INTERVAL)
    self.remove     = false
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
    if self.animations:getCurrentFrame() == 16 then
        self.remove = true
    end
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
        self.x - EXPLOSION_OFFSET, self.y - EXPLOSION_OFFSET,
        0,
        5, 5
    )
end
