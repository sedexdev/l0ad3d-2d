--[[
    SystemManager: class

    Description:
        The system manager initialises, updates and renders 
        all game systems
]]

SystemManager = Class{}

--[[
    SystemManager constructor 

    Params:
        player: table - Player object
    Returns:
        nil
]]
function SystemManager:init(player, map)
    self.player = player
    self.map = map
    -- create a DoorSystem
    self.doorSystem = DoorSystem(self.player, self.map)
    -- create a CollisionSystem
    self.collisionSystem = CollisionSystem(self.player, self.doorSystem)
    -- create a PowerUpSystem
    self.powerupSystem = PowerUpSystem(self.player, self.doorSystem)
    -- create an instance of SpriteBatch for Grunt Entity objects
    self.gruntSpriteBatch = SpriteBatcher(GTextures['grunt'])
    -- create an EnemySystem
    self.enemySystem = EnemySystem(self.player, self.gruntSpriteBatch, self.collisionSystem, self.doorSystem)
end

--[[
    SystemManager update functio 

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function SystemManager:update(dt)
    self.doorSystem:update(dt)
    self.powerupSystem:update(dt)
    self.enemySystem:update(dt)
end

--[[
    SystemManager constructor 

    Params:
        none
    Returns:
        nil
]]
function SystemManager:render()
    self.doorSystem:render()
    self.powerupSystem:render()
    self.enemySystem:render()
end
