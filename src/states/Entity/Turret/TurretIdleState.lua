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
        turret: table - turret type Entity object
    Returns:
        nil
]]
function TurretIdleState:init(turret)
    self.turret = turret
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
        0,
        2.5, 2.5
    )
end
