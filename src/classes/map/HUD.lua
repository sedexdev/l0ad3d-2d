--[[
    HUD: class

    Description:
        Initialises, updates, and renders out the Heads-up
        Display (HUD) for relaying game information to the
        end user such as ammo count, current health, and keys
        possessed
]]

HUD = Class{}

--[[
    HUD constructor

    Params:
        player:  table - Player object
        miniMap: table - MiniMap object
    Returns:
        nil
]]
function HUD:init(player, miniMap)
    self.player = player
    -- positional data for bars
    self.barStart = 64 * 0.8
    -- key colours
    self.keyColours = {
        ['red'] = {
            r = 1,
            g = 0/255,
            b = 0/255
        },
        ['green'] = {
            r = 41/255,
            g = 181/255,
            b = 5/255
        },
        ['blue'] = {
            r = 95/255,
            g = 209/255,
            b = 232/255
        },
    }
    self.miniMap      = miniMap
    self.hideMiniMap  = true
end

--[[
    HUD update function

    Key bindings:
        "m" - display / hide minimap 
    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function HUD:update(dt)
    if love.keyboard.wasPressed("m") then
        self.hideMiniMap = self.hideMiniMap == false and true or false
    end
    self.miniMap:update(dt)
end

--[[
    HUD render function

    Params:
        cameraX: number - x location of game camera
        cameraY: number - y location of game camera
    Returns:
        nil
]]
function HUD:render(cameraX, cameraY)
    -- render minimap if not hidden
    if not self.hideMiniMap then
        self.miniMap:render(cameraX, cameraY)
    end
    -- render key colours first so they are beind the HUD
    if self.player.keys.red then
        self:renderKeyColour(cameraX, cameraY, 'red', 130)
    end
    if self.player.keys.green then
        self:renderKeyColour(cameraX, cameraY, 'green', 180)
    end
    if self.player.keys.blue then
        self:renderKeyColour(cameraX, cameraY, 'blue', 230)
    end
    -- render life indicators behind HUD
    self:renderLives(cameraX, cameraY)
    local cornerOffset = 75
    -- render HUD display with shadow
    love.graphics.setColor(20/255, 20/255, 20/255, 200/255)
    love.graphics.draw(GTextures['hud'], GQuads['hud'][1], cameraX + cornerOffset + 2, cameraY + cornerOffset + 2)
    love.graphics.draw(GTextures['hud'], GQuads['hud'][1], cameraX + cornerOffset + 2, cameraY + cornerOffset + 2)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(GTextures['hud'], GQuads['hud'][1], cameraX + cornerOffset, cameraY + cornerOffset)
    love.graphics.draw(GTextures['hud'], GQuads['hud'][1], cameraX + cornerOffset, cameraY + cornerOffset)
    -- render health
    love.graphics.setFont(GFonts['funkrocker-smaller'])
    -- render health and ammo if the minimap is hidden 
    if self.hideMiniMap then
        self:renderStatBar(cameraX, cameraY, self.player.health, 4, 150, 165, 130)
        -- render ammo
        self:renderStatBar(cameraX, cameraY, self.player.ammo, 3, 210, 225, 190)
    end
end

--[[
    Renders out different colour blocks that represent
    which keys the Player has collected

    Params:
        cameraX: number - x location of game camera
        cameraY: number - y location of game camera
        colour:  string - colour of this key
        yOffset: number - y coordinate
    Returns:
        nil
]]
function HUD:renderKeyColour(cameraX, cameraY, colour, yOffset)
    local x = 310
    love.graphics.setColor(self.keyColours[colour].r, self.keyColours[colour].g, self.keyColours[colour].b, 1)
    love.graphics.rectangle('fill', cameraX + x, cameraY + yOffset, 20, 50)
end

--[[
    Renders out the health and ammo bars in the HUD

    Params:
        cameraX: number - x location of game camera
        cameraY: number - y location of game camera
        stat:    number - value of stat
        quadID:  number - ID to use to ref GQuads['powerups']
        quadY:   number - y coordinate of the stat quad image
        barY:    number - y coordinate of the stat bar
        valueY:  number - y coordinate of the stat value
    Returns:
        nil
]]
function HUD:renderStatBar(cameraX, cameraY, stat, quadID, quadY, barY, valueY)
    local x         = 125
    local xOffset   = quadID == 4 and 60 or 35
    local ammoCount = (self.player.ammo * 100) / MAX_AMMO
    if quadID == 4 then
        -- health = red
        love.graphics.setColor(1, 0/255, 0/255, 1)
    else
        -- ammo = blue
        love.graphics.setColor(0/255, 0/255, 1, 1)
    end
    -- stat bar - width set by quadID
    love.graphics.rectangle('fill', cameraX + 125 + self.barStart, cameraY + barY, (quadID == 3 and ammoCount or self.player.health), 20)
    love.graphics.setColor(20/255, 20/255, 20/255, 200/255)
    -- stat value
    love.graphics.print(tostring(stat), cameraX + x + self.barStart + xOffset + 2, cameraY + valueY + 2)
    love.graphics.print(tostring(stat), cameraX + x + self.barStart + xOffset + 2, cameraY + valueY + 2)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(tostring(stat), cameraX + x + self.barStart + xOffset, cameraY + valueY)
    -- powerup icon
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(GTextures['powerups'], GQuads['powerups'][quadID], cameraX + x, cameraY + quadY, 0, 0.8, 0.8)
end

--[[
    Renders Player objects remaining lives as red bars around the 
    HUD display

    Params:
        cameraX: number - x location of game camera
        cameraY: number - y location of game camera
    Returns:
        nil
]]
function HUD:renderLives(cameraX, cameraY)
    love.graphics.setColor(155/255, 23/255, 23/255, 200/255)
    if self.player.lives == 3 then
        love.graphics.rectangle('fill', cameraX + 110, cameraY + 90, 180, 20)  -- top
        love.graphics.rectangle('fill', cameraX + 80, cameraY + 120, 20, 170)  -- left
        love.graphics.rectangle('fill', cameraX + 120, cameraY + 300, 170, 20) -- bottom
    end
    if self.player.lives == 2 then
        love.graphics.rectangle('fill', cameraX + 80, cameraY + 120, 20, 170)  -- left
        love.graphics.rectangle('fill', cameraX + 120, cameraY + 300, 170, 20) -- bottom
    end
    if self.player.lives == 1 then
        love.graphics.rectangle('fill', cameraX + 120, cameraY + 300, 170, 20) -- bottom
    end
end
