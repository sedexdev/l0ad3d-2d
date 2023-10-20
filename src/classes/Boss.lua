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
        animations: table - the boss sprite sheet indices for drawing
                            this Entity
        def: table - the definition of a Boss object as defined in 
                     src/utils/definitions.lua as GBossDefinition
    Returns:
        nil
]]
function Boss:init(animations, def)
    Entity.init(self, def)
    self.texture = animations.texture
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
   Entity.render(self)
end
