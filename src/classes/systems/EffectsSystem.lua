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
    for _, explosion in pairs(self.explosions) do
        explosion:update(dt)
    end
    for _, bullet in pairs(self.bullets) do
        bullet:update(dt)
    end
    for _, effect in pairs(self.smokeEffects) do
        effect:update(dt)
    end
    for i = 1, #self.shots do
        -- update the shot animation
        self.shots[i]:update(dt)
        if not self.shots[i].renderShot then
            Remove(self.shots, self.shots[i])
            break
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
    love.graphics.setColor(1, 1, 1, 1)
    -- only Smoke instances are rendered from here
    for i = 1, #self.smokeEffects do
        self.smokeEffects[i]:render()
        if self.smokeEffects[i].animations:getCurrentFrame() == self.smokeEffects[i].finalFrame then
            Remove(self.smokeEffects, self.smokeEffects[i])
            break
        end
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
    for i = 1, #self.explosions do
        self.explosions[i]:render()
        if self.explosions[i].animations:getCurrentFrame() == self.explosions[i].finalFrame then
            Remove(self.explosions, self.explosions[i])
            break
        end
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
        self.playerX       = data.x
        self.playerY       = data.y
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
        Explosion(self.effectIDs.explosionID, GAnimationDefintions['explosion'], object.x, object.y)
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
        bloodStain = nil
        -- pass 1 as the index to always remove the first one rendered
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
        Explosion(self.effectIDs.smokeID, GAnimationDefintions['smoke'], x, y)
    )
    self.effectIDs.smokeID = self.effectIDs.smokeID + 1
end
