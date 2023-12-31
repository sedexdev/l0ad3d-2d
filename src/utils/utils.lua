--[[
    Creates quads of a specific width/height from a given 
    sprite sheet and returns a table of quads

    Params:
        atlas:      Image  - sprite sheet to make quads from 
        tileWidth:  number - width of the quads
        tileHeight: number - height of the quads
    Returns:
        table: quads - a table of generated quads 
]]
function GenerateQuads(atlas, tileWidth, tileHeight)
    local sheetWidth, sheetHeight = atlas:getDimensions()
    local cols = sheetWidth / tileWidth
    local rows = math.floor(sheetHeight / tileHeight)
    local quads = {}
    local counter = 1
    for y = 1, rows do
        for x = 1, cols do
            quads[counter] = love.graphics.newQuad(
                (x - 1) * tileWidth,
                (y - 1) * tileHeight,
                tileWidth,
                tileHeight,
                atlas:getDimensions()
            )
            counter = counter + 1
        end
    end
    return quads
end

--[[
    Makes a copy of a game Entity definition so the original
    definitions are not updated as the game progresses

    Disclaimer: non-original code sourced from 
    
        - http://lua-users.org/wiki/CopyTable

    Params:
        orig: table - table to copy data from
    Returns:
        table: copy of the given table
]]
function Copy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[Copy(orig_key)] = Copy(orig_value)
        end
        setmetatable(copy, Copy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

--[[
    Removes an element from a table once its flag has been
    set to true 

    Params:
        t:      table - the table to remove from
        object: table - the object to remove
    Returns:
        nil
]]
function Remove(t, object)
    local last = false
    local n = #t
    -- set element being removed to nil
    for i = 1, n do
        if t[i].id == object.id then
            if i == n then
                last = true
            end
            t[i] = nil
            break
        end
    end
    -- shift all elements towards the front to fill gaps
    local j = 0
    for i = 1, n do
        if t[i] ~= nil then
            j = j + 1
            t[j] = t[i]
        end
    end
    if not last then
        -- set last element to nil
        t[#t] = nil
    end
end

--[[
    Gets the length of a given table and returns it
    
    Params:
        t: table - table to check
    Returns:
        number: length of the table
]]
function Length(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end


-- ========================== ON LEVEL COMPLETE ==========================

--[[
    Raises the stats of enemy type Entity objects when the 
    Player completes a level

    Params:
        none
    Returns:
        nil
]]
function IncreaseStats()
    -- grunts
    GGruntDefinition.health  = GGruntDefinition.health + 5
    GGruntDefinition.damage  = GGruntDefinition.damage + 2
    -- turrets
    GTurretDefinition.health = GTurretDefinition.health + 25
    GTurretDefinition.damage = GTurretDefinition.damage + 2
    -- boss
    GBossDefinition.health   = GBossDefinition.health + 50
    GBossDefinition.damage   = GBossDefinition.damage + 2
end

--[[
    Resets the stats of enemy type Entity objects when the 
    Player dies and the game is over

    Params:
        none
    Returns:
        nil
]]
function ResetStats()
    -- grunts
    GGruntDefinition.health  = 50
    GGruntDefinition.damage  = 5
    -- turrets
    GTurretDefinition.health = 200
    GTurretDefinition.damage = 15
    -- boss
    GBossDefinition.health   = 1000
    GBossDefinition.damage   = 10
end

-- ========================= SOUND EFFECTS =========================

--[[
    Plays the sound clip for the theme music 
    
    Params:
        none
    Returns:
        nil
]]
function Audio_PlayTheme()
    GAudio['theme']:play()
    GAudio['theme']:setLooping(true)
end

--[[
    Plays the sound clip for menu option selection 
    
    Params:
        none
    Returns:
        nil
]]
function Audio_MenuOption()
    GAudio['select']:stop()
    GAudio['select']:play()
end

--[[
    Plays the sound clip for menu error - used during
    character selection 
    
    Params:
        none
    Returns:
        nil
]]
function Audio_MenuError()
    GAudio['error']:play()
end

--[[
    Plays the sound clip of the Players weapon being
    fired
    
    Params:
        none
    Returns:
        nil
]]
function Audio_PlayerShot()
    GAudio['gunshot']:stop()
    GAudio['gunshot']:play()
end

--[[
    Plays the sound clip of the Turrets weapon being
    fired
    
    Params:
        none
    Returns:
        nil
]]
function Audio_TurretShot()
    GAudio['canon']:stop()
    GAudio['canon']:play()
end

--[[
    Plays the sound clip of the Boss' weapon being
    fired
    
    Params:
        none
    Returns:
        nil
]]
function Audio_BossShot()
    GAudio['laser']:stop()
    GAudio['laser']:play()
end

--[[
    Plays the sound clip of an explosion
    
    Params:
        none
    Returns:
        nil
]]
function Audio_Explosion()
    GAudio['explosion']:stop()
    GAudio['explosion']:play()
end

--[[
    Plays the sound clip of blood splatter when a Grunt
    is killed
    
    Params:
        none
    Returns:
        nil
]]
function Audio_GruntDeath()
    GAudio['grunt-death']:stop()
    GAudio['grunt-death']:play()
end

--[[
    Plays the sound clip of a grunts on Boss hit
    
    Params:
        none
    Returns:
        nil
]]
function Audio_BossHit()
    GAudio['boss-hit']:stop()
    GAudio['boss-hit']:play()
end

--[[
    Plays the sound clip of a monster grunting on Boss kill
    
    Params:
        none
    Returns:
        nil
]]
function Audio_BossDeath()
    GAudio['boss-death']:stop()
    GAudio['boss-death']:play()
end

--[[
    Plays the sound clip of Player losing a life or dying
    
    Params:
        none
    Returns:
        nil
]]
function Audio_PlayerDeath()
    GAudio['player-death']:stop()
    GAudio['player-death']:play()
end

--[[
    Plays the sound clip of a bullet hitting a Turret
    
    Params:
        none
    Returns:
        nil
]]
function Audio_TurretHit()
    GAudio['turret-hit']:stop()
    GAudio['turret-hit']:play()
end

--[[
    Plays the sound clip of a bullet hitting a wall
    
    Params:
        none
    Returns:
        nil
]]
function Audio_BulletWallHit()
    GAudio['bullet-wall']:stop()
    GAudio['bullet-wall']:play()
end

--[[
    Plays the sound clip of picking up a Key
    
    Params:
        none
    Returns:
        nil
]]
function Audio_KeyPickup()
    GAudio['key']:stop()
    GAudio['key']:play()
end

--[[
    Plays the sound clip of picking up ammo
    
    Params:
        none
    Returns:
        nil
]]
function Audio_AmmoPickup()
    GAudio['ammo']:stop()
    GAudio['ammo']:play()
end

--[[
    Plays the sound clip of picking up an invicible PowerUp
    
    Params:
        none
    Returns:
        nil
]]
function Audio_InvinciblePickup()
    GAudio['invincible']:stop()
    GAudio['invincible']:play()
end

--[[
    Plays the sound clip of picking up health
    
    Params:
        none
    Returns:
        nil
]]
function Audio_HealthPickup()
    GAudio['health']:stop()
    GAudio['health']:play()
end

--[[
    Plays the sound clip of picking up a one shot boss kill PowerUp
    
    Params:
        none
    Returns:
        nil
]]
function Audio_OneShotBossKillPickup()
    GAudio['oneShotBossKill']:stop()
    GAudio['oneShotBossKill']:play()
end

--[[
    Plays the sound clip of picking up a doubleSpeed Powerup
    
    Params:
        none
    Returns:
        nil
]]
function Audio_DoubleSpeedPickup()
    GAudio['doubleSpeed']:stop()
    GAudio['doubleSpeed']:play()
end

--[[
    Plays the sound clip of a door opening or closing
    
    Params:
        none
    Returns:
        nil
]]
function Audio_Door()
    GAudio['door']:stop()
    GAudio['door']:play()
end

--[[
    Plays the sound clip of level completion
    
    Params:
        none
    Returns:
        nil
]]
function Audio_LevelComplete()
    GAudio['level-complete']:stop()
    GAudio['level-complete']:play()
end

--[[
    Plays the sound clip of game over
    
    Params:
        none
    Returns:
        nil
]]
function Audio_GameOver()
    GAudio['game-over']:stop()
    GAudio['game-over']:play()
end
