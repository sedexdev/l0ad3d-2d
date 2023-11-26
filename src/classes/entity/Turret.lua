--[[
    Turret: class

    Includes: Entity - parent class for entity objects 

    Description:
        Creates, updates, and renders a Turret object
        using the parent Entity class
]]

Turret = Class{__includes = Entity}

--[[
    Turret constructor

    Params:
        id:         number - ID of this turret type Entity object
        animations: table  - Turret animation defnitions
        def:        table  - Turret object definition
    Returns:
        nil
]]
function Turret:init(id, animations, def)
    Entity.init(self, def)
    self.id = id
    self.texture = animations.texture
    self.fireShot = animations.fireShot
    self.direction = def.direction
    self.health = def.health
    self.rotateFrequency = def.rotateFrequency
    -- boolean flag to detect if the Turret is dead
    self.isDead = false
end

--[[
    Turret update function. Calls Entity parent update function,
    passing <self> and <dt> as arguments

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function Turret:update(dt)
    Entity.update(self, dt)
end

--[[
    Turret render function. Calls Entity parent render function,
    passing <self> as an arguments

    Params:
        none
    Returns:
        nil
]]
function Turret:render()
   Entity.render(self)
end

--[[
    Handles damage dealt from the Player

    Params:
        none
    Returns:
        nil
]]
function Turret:takeDamage()
    self.health = self.health - PLAYER_DAMAGE
    if self.health <= 0 then
        self.isDead = true
    end
end