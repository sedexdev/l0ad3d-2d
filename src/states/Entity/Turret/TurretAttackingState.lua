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
    self.timer = 0
    self.interval = self.turret.rotateFrequency
    io.write(tostring(self.interval)..'\n')
    self.directionIndex = 2
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
    self.timer = self.timer + dt
    -- check if timer exceeds interval
    if self.timer > self.interval then
        -- change direction/angle
        self.turret.direction = DIRECTIONS[self.directionIndex]
        -- incrememnt the index for querying DIRECTIONS
        self.directionIndex = self.directionIndex + 1
        -- if over 8 then reset to 1 (north)
        if self.directionIndex > 8 then
            self.directionIndex = 1
        end
        -- reset timer
        self.timer = 0
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
        ENTITY_ANGLES[self.turret.direction],
        2.5, 2.5,
        TURRET_WIDTH / 2, TURRET_HEIGHT / 2
    )
end
