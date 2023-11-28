--[[
    EffectsSystem: class

    Description:
        The effects system is responsible for updating and rendering out 
        the graphical effects within the game. This includes explosions, 
        shots fired, powerup rotation physics, and particle systems
]]

EffectsSystem = Class{__includes = Observer}

--[[
    EffectsSystem constructor

    Params:
        player:        table - Player object
        systemManager: table - SystemManager object
    Returns:
        nil
]]
function EffectsSystem:init(systemManager)
    self.systemManager = systemManager
    self.playerX = PLAYER_STARTING_X
    self.playerY = PLAYER_STARTING_Y
    self.currentAreaID = START_AREA_ID
    -- explosions table
    self.explosions = {}
    -- shots table keeps track of Shot objects so they can be 
    -- instantiated and removed after the assigned interval
    self.shots = {}
    -- bullet management table
    self.bulletID = 1
    self.bullets = {}
    -- bullet fired event
    self.spawnBullet = Event.on('shotFired', function (entity)
        table.insert(self.shots, Shot(entity))
        if entity.type == 'character' then
            GAudio['gunshot']:stop()
            GAudio['gunshot']:play()
        end
        if entity.type == 'turret' then
            GAudio['canon']:stop()
            GAudio['canon']:play()
        end
        local bullet =  Bullet(self.bulletID, entity)
        table.insert(self.bullets, bullet)
        self.bulletID = self.bulletID + 1
        bullet:subscribe(self.systemManager)
    end)
    -- blood stains
    self.bloodStains = {}
end

--[[
    EffectsSystem update function

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function EffectsSystem:update(dt)
    for _, explosion in pairs(self.explosions) do
        explosion:update(dt)
    end
    for _, bullet in pairs(self.bullets) do
        bullet:update(dt)
    end
    local index
    for i = 1, #self.shots do
        -- update the shot animation
        self.shots[i]:update(dt)
        if not self.shots[i].renderShot then
            index = i
            break
        end
    end
    if index ~= nil then
        self.shots[index] = nil
        -- remove shots once their interval has passed
        table.remove(self.shots, index)
    end
end

--[[
    EffectsSystem render function

    Params:
        none
    Returns:
        none
]]
function EffectsSystem:render()
    love.graphics.setColor(1, 1, 1, 1)
    -- explosions
    local index
    for i = 1, #self.explosions do
        self.explosions[i]:render()
        if self.explosions[i].animations:getCurrentFrame() == 16 then
            index = i
            break
        end
    end
    if index ~= nil then
        self.explosions[index] = nil
        table.remove(self.explosions, index)
    end
    -- blood stains
    for _, stain in pairs(self.bloodStains) do
        stain:render()
    end
    -- shots
    for _, shot in pairs(self.shots) do
        if shot.renderShot then
            shot:render()
        end
    end
end

--[[
    Observer message function implementation. Updates the current
    (x, y) coordinates of the Player

    Params:
        data: table - Player object current state
    Returns;
        nil
]]
function EffectsSystem:message(data)
    if data.source == 'PlayerWalkingState' then
        self.playerX = data.x
        self.playerY = data.y
        self.currentAreaID = data.areaID
    end
end

--[[
    Removes a Bullet from <self.bullets>

    Params:
        id: number - Bullet object ID
    Returns:
        nil
]]
function EffectsSystem:removeBullet(id)
    local index
    for i = 1, #self.bullets do
        if self.bullets[i].id == id then
            index = i
            break
        end
    end
    if index ~= nil then
        self.bullets[index] = nil
        table.remove(self.bullets, index)
    end
end

--[[
    Emits a particle system effect on amn area boundary wall
    when a Bullet object overlaps the boundary

    TODO: implement wall hit particle system effect

    Params:
        x: number - x coordinate
        y: number - y coordinate
    Returns:
        nil
]]
function EffectsSystem:emitWallParticleEffect(x, y)

end
