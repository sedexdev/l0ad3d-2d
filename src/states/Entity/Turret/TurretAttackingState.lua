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
        none
    Returns:
        nil
]]
function TurretAttackingState:init()
    
end

--[[
    TurretAttackingState update function.

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function TurretAttackingState:update(dt)
    
end

--[[
    TurretAttackingState render function.

    Params:
        none
    Returns:
        nil
]]
function TurretAttackingState:render()
    
end
