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
    Entity.init(self, def)
    self.texture = animations.texture
    self.fireShot = animations.fireShot
    self.animations = animations.animations
    self.direction = def.direction
    self.health = def.health
    self.damage = def.damage
    -- boolean flag to detect if the Boss is dead
    self.isDead = false
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

--[[
    Fires a shot from the Boss by dispatching a shotFired event

    Params:
        none
    Returns:
        nil
]]
function Boss:fire()
    Event.dispatch('shotFired', self)
end

--[[
    Handles damage dealt from the Player

    Params:
        none
    Returns:
        nil
]]
function Boss:takeDamage()
    self.health = self.health - PLAYER_DAMAGE
    if self.health <= 0 then
        self.isDead = true
    end
end