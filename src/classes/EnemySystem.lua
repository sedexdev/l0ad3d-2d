--[[
    EnemySystem: class

    Description:
        An enemy system is responsible for spawning and removing
        enemy (Entity) objects from the Map. As enemies are killed
        they are replaced with blood splatter effects which fade
        over time, and enemies are replaced as the Player moves around
        the Map
]]

EnemySystem = Class{}

--[[
    EnemySystem constructor. Creates a store for the doors in the
    system, tracks locked doors, and knows which door the Player
    is currently interacting with 

    Params:
        none
    Returns:
        nil
]]
function EnemySystem:init()
    -- tracks all Grunt Entity objects 
    self.grunts = {}
    self.Boss = nil
end

--[[
    EnemySystem update function. 

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function EnemySystem:update(dt)

end

--[[
    EnemySystem render function.

    Params:
        none
    Returns:
        none
]]
function EnemySystem:render()

end