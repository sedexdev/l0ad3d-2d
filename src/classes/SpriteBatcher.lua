--[[
    SpriteBatcher: class

    Description:
        Creates a customisable instance of LOVE2D's SpriteBatch class
        for rendering out multiple version of the same quad while 
        limiting costly calls to love.graphics.draw() for each quad
]]

SpriteBatcher = Class{}

--[[
    SpriteBatcher constructor

    Params:
        texture: Image - image used to render quads
    Returns:
        nil
]]
function SpriteBatcher:init(texture)
    self.spriteBatch = love.graphics.newSpriteBatch(texture, 1000, 'dynamic')
end

--[[
    Adds a new quad to <self.spriteBatch> at the given
    (x, y) coordinates

    Params:
        quad: Quad - the quad to send to the Spritebatch draw function
        x: number - x coordinate of quad
        y: number - y coordinate of quad
    Returns:
            nil
]]
function SpriteBatcher:add(quad, x, y, s1, s2)
    self.spriteBatch:add(quad, x, y, 0, s1, s2)
end

--[[
    Draws the contents of <self.spriteBatch>

    Params:
        s1: number - scale factor 1
        s2: number - scale factor 2
    Returns:
        nil
]]
function SpriteBatcher:draw()
    love.graphics.draw(self.spriteBatch)
end

--[[
    Clears the contents of <self.spriteBatch>

    Params:
        none
    Returns:
        nil
]]
function SpriteBatcher:clear()
    self.spriteBatch:clear()
end
