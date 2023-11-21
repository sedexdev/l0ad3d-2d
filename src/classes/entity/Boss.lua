--[[
    Boss: class

    Includes: Entity - parent class for entity objects 

    Description:
        Creates, updates, and renders a Boss character object
        using the parent Entity class
]]

Boss = Class{__includes = Entity}

--[[
    Boss constructor

    Params:
        animations: table - Boss animation defnitions
        def:        table - Boss object definition
    Returns:
        nil
]]
function Boss:init(animations, def)
    DebugFile:write(os.date('%A, %B %d %Y at %I:%M:%S %p - ') .. debug.getinfo(2, "S").source .. ':' .. debug.getinfo(1, 'n').name .. '\n')
    Entity.init(self, def)
    self.texture = animations.texture
    self.fireShot = animations.fireShot
    self.animations = animations.animations
    self.direction = def.direction
    self.health = def.health
end

--[[
    Boss update function. Calls Entity parent update function,
    passing <self> and <dt> as arguments

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function Boss:update(dt)
    DebugFile:write(os.date('%A, %B %d %Y at %I:%M:%S %p - ') .. debug.getinfo(2, "S").source .. ':' .. debug.getinfo(1, 'n').name .. '\n')
    Entity.update(self, dt)
end

--[[
    Boss render function. Calls Entity parent render function,
    passing <self> as an arguments

    Params:
        none
    Returns:
        nil
]]
function Boss:render()
    DebugFile:write(os.date('%A, %B %d %Y at %I:%M:%S %p - ') .. debug.getinfo(2, "S").source .. ':' .. debug.getinfo(1, 'n').name .. '\n')
   Entity.render(self)
end
