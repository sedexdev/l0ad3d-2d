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
    self.id             = id
    self.texture        = animations.texture
    self.fireShot       = animations.fireShot
    self.direction      = def.direction
    self.health         = def.health
    self.damage         = def.damage
    -- random angle in degrees to draw turret
    self.startDirection = math.random(1, 8)
    self.direction      = DIRECTIONS[self.startDirection]
    -- starting degrees - if equal to 0 set as North (360)
    self.degrees        = (self.startDirection - 1) * 45 == 0 and 360 or (self.startDirection - 1) * 45
    -- angle in radians
    self.angle          = 0
    -- boolean flag to detect if the Turret is dead
    self.isDead         = false
end

--[[
    Turret update function

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function Turret:update(dt)
    Entity.update(self, dt)
end

--[[
    Turret render function

    Params:
        none
    Returns:
        nil
]]
function Turret:render()
    Entity.render(self)
end

--[[
    Fires a shot from the turret by dispatching a shotFired event

    Params:
        none
    Returns:
        nil
]]
function Turret:fire()
    Event.dispatch('shotFired', self)
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