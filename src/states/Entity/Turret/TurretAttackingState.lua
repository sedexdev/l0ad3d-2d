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
end

--[[
    TurretAttackingState update function.

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function TurretAttackingState:update(dt)
    -- update angle in degree
    self.turret.degrees = self.turret.degrees + 1
    -- update direction when degrees hits a multiple of 45 and fire weapon
    if self.turret.degrees % 45 == 0 then
        -- update the direction
        if self.turret.degrees == 360 then
            self.turret.direction = DIRECTIONS[1] -- north
        else
            self.turret.direction = DIRECTIONS[(self.turret.degrees / 45) + 1]
        end
        self.turret:fire()
    end
    -- convert to radians to get angle
    self.turret.angle = self.turret.degrees * DEGREES_TO_RADIANS
    -- reset at 360 to do another revolution
    if self.turret.degrees > 360 then
        self.turret.degrees = 1
        self.turret.angle = 0
    end
    -- change state if Player leaves area
    if self.player.currentArea.id ~= self.turret.areaID then
        self.turret.stateMachine:change('idle')
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
        self.turret.angle,
        2.5, 2.5,
        TURRET_WIDTH / 2, TURRET_HEIGHT / 2
    )
end
