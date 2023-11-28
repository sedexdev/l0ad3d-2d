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
        texture:    Image  - Smoke PNG Image file
        animations: table  - animation idices for rendering
        x:          number - x cordinate 
        y:          number - y cordinate
    Returns:
        nil
]]
function Smoke:init(texture, animations, x, y)
    self.texture = texture
    self.animations = animations
    self.x = x
    self.y = y
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

--[[
    Creates and returns an Animation instance for rendering
    an Smoke

    Params:
        x: number - x coordinate
        y: number - y coordinate
    Returns:
        table: Animation instance
]]
function Smoke:factory(x, y)
    local frames = {}
    for i = 1, 8 do table.insert(frames, i) end
    return Smoke(GTextures['smoke'],
        Animation(frames, SMOKE_INTERVAL),
        x, y
    )
end
