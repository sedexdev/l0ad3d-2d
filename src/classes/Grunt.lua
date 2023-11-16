--[[
    Grunt: class

    Includes: Entity - parent class for entity objects 

    Description:
        Creates, updates, and renders a Grunt character object
        using the parent Entity class
]]

Grunt = Class{__includes = Entity}

--[[
    Grunt constructor

    Params:
        id: number - ID of this Grunt Entity object
        animations: table - the grunt sprite sheet indices for drawing
                            this Entity
        def: table - the definition of a Grunt object as defined in 
                     src/utils/definitions.lua as GGruntDefinition
    Returns:
        nil
]]
function Grunt:init(id, animations, def)
    Entity.init(self, def)
    self.id = id
    self.texture = animations.texture
    self.animations = animations.animations
    self.direction = def.direction
    self.health = def.health
    self.powerUpChance = def.powerUpChance
end

--[[
    Grunt update function. Calls Entity parent update function,
    passing <self> and <dt> as arguments

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function Grunt:update(dt)
    Entity.update(self, dt)
end

--[[
    Grunt render function. Calls Entity parent render function,
    passing <self> as an arguments

    Params:
        none
    Returns:
        nil
]]
function Grunt:render()
    Entity.render(self)
end
