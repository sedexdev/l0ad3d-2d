--[[
    EffectsSystem: class

    Description:
        The effects system is responsible for updating and rendering out 
        the graphical effects within the game. This includes explosions, 
        shots fired, powerup rotation physics, and particle systems
]]

EffectsSystem = Class{}

--[[
    EffectsSystem constructor

    Params:
        powerupSystem: table - PowerupSystem object
        enemySystem:   table - EnemySystem object
    Returns:
        nil
]]
function EffectsSystem:init(powerupSystem, enemySystem)
    self.powerupSystem = powerupSystem
    self.enemySystem = enemySystem
    -- explosions table
    self.explosions = {}
    -- bullet management table
    self.bulletID = 1
    self.bullets = {}
    -- bullet fired event
    self.spawnBullet = Event.on('shotFired', function (entity)
        table.insert(self.bullets, Bullet(self.bulletID, entity))
        self.bulletID = self.bulletID + 1
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
        self:checkBullets(self.powerupSystem.crates, bullet)
        self:checkBullets(self.enemySystem.grunts, bullet)
        self:checkBullets(self.enemySystem.turrets, bullet)
        if self.enemySystem.boss then
            -- check for Boss damage using Boss class
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
    -- explosions
    for key, explosion in pairs(self.explosions) do
        explosion:render()
        if explosion.animations:getCurrentFrame() == 16 then
            explosion = nil
            table.remove(self.explosions, key)
        end
    end
    -- blood stains
    for _, stain in pairs(self.bloodStains) do
        stain:render()
    end
end



--[[
    Checks for Bullet hits and removes the object it hit 
    from the game

    Params:
        systemTable: table - system objects
        bullet:      table - Bullet object
    Returns:
        nil
]]
function EffectsSystem:checkBullets(systemTable, bullet)
    for key, object in pairs(systemTable) do
        if bullet:hit(object) then
            if object.type == 'crate' then
                table.insert(self.explosions, Explosion:factory(object))
            end
            if object.type == 'grunt' then
                local bloodSplatter = BloodSplatter(GTextures['blood-splatter'], object.x, object.y, object.direction)
                table.insert(self.bloodStains, bloodSplatter)
                Timer.after(180, function ()
                    for i, _ in pairs(self.bloodStains) do
                        table.remove(self.bloodStains, i)
                    end
                end)
            end
            object = nil
            table.remove(systemTable, key)
            bullet = nil
            table.remove(self.bullets, bullet)
            break
        end
    end
end


