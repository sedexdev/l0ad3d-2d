--[[
    TurretAttackingState: class

    Includes: BaseState - provides base functions for state classes

    Description:
        Renders and updates a turret type Entity object in
        the attacking state while the Player is in the same
        area as the turret. Goes back into an idle state 
        when the Player leaves the area
]]

TurretAttackingState = Class{__includes = BaseState}

--[[
    TurretAttackingState constructor

    Params:
        turret: table - Turret object
        player: table - Player object
    Returns:
        nil
]]
function TurretAttackingState:init(turret, player)
    self.turret = turret
    self.player = player
    -- rotation data
    -- rotational values
    self.degrees = math.random(1, 359)
    self.angle = 0
end

--[[
    TurretAttackingState update function.

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function TurretAttackingState:update(dt)
    if self.player.currentArea.id ~= self.turret.areaID then
        self.turret.stateMachine:change('idle')
    end
    -- handle rotation
    self.degrees = self.degrees + 1
    self.angle = self.degrees * DEGREES_TO_RADIANS
    if self.degrees > 360 then
        self.degrees = 1
        self.angle = 0
    end
end

--[[
    TurretAttackingState render function.

    Params:
        none
    Returns:
        nil
]]
function TurretAttackingState:render()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.turret.texture,
        GQuads['turret'][1],
        self.turret.x, self.turret.y,
        self.angle,
        2.5, 2.5,
        TURRET_WIDTH / 2, TURRET_HEIGHT / 2
    )
end
