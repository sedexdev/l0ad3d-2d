--[[
    TurretIdleState: class

    Includes: BaseState - provides base functions for state classes

    Description:
        Renders a turret type Entity object in its idle state
        when the Player object is not in the same area as the
        turret object. State changes to attacking when the
        Player enters the area
]]

TurretIdleState = Class{__includes = BaseState}

--[[
    TurretIdleState constructor

    Params:
        turret: table - Turret object
        player: table - Player object
    Returns:
        nil
]]
function TurretIdleState:init(turret, player)
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
function TurretIdleState:update(dt)
    -- change to attack state when Player enters the area
    if self.player.currentArea.id == self.turret.areaID then
        self.turret.stateMachine:change('attacking')
    end
end


--[[
    TurretIdleState render function.

    Params:
        none
    Returns:
        nil
]]
function TurretIdleState:render()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.turret.texture,
        GQuads['turret'][1],
        self.turret.x, self.turret.y,
        ENTITY_ANGLES[self.turret.direction],
        2.5, 2.5,
        TURRET_WIDTH / 2, TURRET_HEIGHT / 2
    )
end
