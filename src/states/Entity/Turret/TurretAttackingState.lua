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
    -- rotational values
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
    io.write('Turret ID: '..tostring(self.turret.id)..', direction: '..self.turret.direction..'\n')
    if self.player.currentArea.id ~= self.turret.areaID then
        self.turret.stateMachine:change('idle')
    end
    -- handle rotation
    self.turret.degrees = self.turret.degrees + 1
    if self.turret.degrees % 45 == 0 then
        self.direction = DIRECTIONS[(self.turret.degrees % 45) + 1]
    end
    self.angle = self.turret.degrees * DEGREES_TO_RADIANS
    if self.turret.degrees > 360 then
        self.turret.degrees = 1
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
