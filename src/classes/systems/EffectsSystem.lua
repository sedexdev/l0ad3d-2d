--[[
    EffectsSystem: class

    Description:
        The effects system is responsible for updating and rendering out 
        the graphical effects within the game. This includes explosions, 
        shots fired, and rotation physics
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
    self.playerX       = PLAYER_STARTING_X
    self.playerY       = PLAYER_STARTING_Y
    self.currentAreaID = START_AREA_ID
    self.shots         = {}
    self.explosions    = {}
    self.bullets       = {}
    self.bloodStains   = {}
    self.smokeEffects  = {}
    -- effect ID tracker
    self.effectIDs     = {
        bulletID = 1,
        bloodID = 1,
        smokeID = 1,
        explosionID = 1,
    }
    -- bullet fired event
    Event.on('shotFired', function (entity)
        table.insert(self.shots, Shot(entity))
        if entity.type == 'character' then
            Audio_PlayerShot()
        end
        if entity.type == 'turret' then
            Audio_TurretShot()
        end
        if entity.type == 'boss' then
            Audio_BossShot()
        end
        self:insertBullet(entity)
    end)
end

--[[
    EffectsSystem update function

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function EffectsSystem:update(dt)
    for _, shot in pairs(self.shots) do
        shot:update(dt)
        if shot.remove then
            Remove(self.shots, shot)
        end
    end
    for _, bullet in pairs(self.bullets) do
        bullet:update(dt)
    end
    for _, explosion in pairs(self.explosions) do
        explosion:update(dt)
        if explosion.remove then
            Remove(self.explosions, explosion)
        end
    end
    for _, smoke in pairs(self.smokeEffects) do
        smoke:update(dt)
        if smoke.remove then
            Remove(self.smokeEffects, smoke)
        end
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
    -- only Smoke instances are rendered from here
    for _, smoke in pairs(self.smokeEffects) do
        smoke:render()
    end
end

--[[
    Renders explosions

    Params:
        none
    Returns:
        nil
]]
function EffectsSystem:renderExplosions()
    for _, explosion in pairs(self.explosions) do
        explosion:render()
    end
end

--[[
    Renders blood stains

    Params:
        none
    Returns:
        nil
]]
function EffectsSystem:renderBloodStains()
    for _, stain in pairs(self.bloodStains) do
        stain:render()
    end
end

--[[
    Renders shots

    Params:
        none
    Returns:
        nil
]]
function EffectsSystem:renderShots()
    for _, shot in pairs(self.shots) do
        if not shot.remove then
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
        self.playerX       = data.x
        self.playerY       = data.y
        self.currentAreaID = data.areaID
    end
end

-- ======================== INSERTION FUNCTIONS ========================

--[[
    Inserts an Explosion object into the <self.explosions> table

    Params:
        object: table - object that has exploded
    Returns:
        nil
]]
function EffectsSystem:insertExplosion(object)
    table.insert(
        self.explosions,
        Explosion(self.effectIDs.explosionID, GTextures['explosion'], object.x, object.y)
    )
    self.effectIDs.explosionID = self.effectIDs.explosionID + 1
end

--[[
    Inserts a Bullet object into the <self.bullets> table

    Params:
        entity: table - Entity object that fired the Bullet
    Returns:
        nil
]]
function EffectsSystem:insertBullet(entity)
    local bullet = Bullet(self.effectIDs.bulletID, entity)
    bullet:subscribe(self.systemManager)
    table.insert(self.bullets, bullet)
    self.effectIDs.bulletID = self.effectIDs.bulletID + 1
end

--[[
    Inserts a BloodSplatter object into the <self.bloodStains> table

    Params:
        object: table - object that has exploded
    Returns:
        nil
]]
function EffectsSystem:insertBlood(grunt)
    local bloodStain = BloodSplatter(self.effectIDs.bloodID, grunt.x, grunt.y, grunt.direction)
    table.insert(self.bloodStains, bloodStain)
    self.effectIDs.bloodID = self.effectIDs.bloodID + 1
    Timer.after(BLOOD_STAIN_INTERVAL, function ()
        Remove(self.bloodStains, bloodStain)
    end)
end

--[[
    Inserts a Smoke object into the <self.smokeEffects> table

    Params:
        x: number - x coordinate
        y: number - y coordinate
    Returns:
        nil
]]
function EffectsSystem:insertSmoke(x, y)
    table.insert(
        self.smokeEffects,
        Smoke(self.effectIDs.smokeID, GTextures['smoke'], x, y)
    )
    self.effectIDs.smokeID = self.effectIDs.smokeID + 1
end
