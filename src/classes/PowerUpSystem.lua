--[[
    PowerUpSystem: class

    Description:
        A powerup system is responsible for spawning powerups and
        handling collision detection with the Player so they can 
        be collected
]]

PowerUpSystem = Class{}

--[[
    PowerUpSystem constructor. Creates a store for the doors in the
    system, tracks locked doors, and knows which door the Player
    is currently interacting with. Tables are used to store currently
    available powerups which are then removed from memory once collected

    Params:
        none
    Returns:
        nil
]]
function PowerUpSystem:init()
    self.invicible = {}
    self.doubleSpeed = {}
    self.oneShotBossKill = {}
end

--[[
    PowerUpSystem update function. 

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function PowerUpSystem:update(dt)

end

--[[
    PowerUpSystem render function.

    Params:
        none
    Returns:
        none
]]
function PowerUpSystem:render()

end