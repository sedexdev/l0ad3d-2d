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
        id:         number - ID of this Grunt Entity object
        animations: table  - Grunt object animation definitions
        def:        table  - Grunt object definition as defined in src/utils/definitions.lua
    Returns:
        nil
]]
function Grunt:init(id, animations, def)
    Entity.init(self, def)
    self.id            = id
    self.texture       = animations.texture
    self.animations    = animations.animations
    self.direction     = def.direction
    self.health        = def.health
    self.powerUpChance = def.powerUpChance
    self.damage        = def.damage
    -- boolean flag to detect if this Grunt is dead
    self.isDead        = false
end

--[[
    Grunt update function

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function Grunt:update(dt)
    Entity.update(self, dt)
end

--[[
    Grunt render function

    Params:
        none
    Returns:
        nil
]]
function Grunt:render()
    Entity.render(self)
end

--[[
    Handles damage dealt from the Player

    Params:
        none
    Returns:
        nil
]]
function Grunt:takeDamage()
    self.health = self.health - PLAYER_DAMAGE
    if self.health <= 0 then
        self.isDead = true
    end
end
