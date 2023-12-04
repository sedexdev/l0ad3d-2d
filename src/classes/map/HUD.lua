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
        player: table - Player object
    Returns:
        nil
]]
function HUD:init(player)
    self.player = player
    -- positional data for bars
    self.barStart = 64 * 0.8
end

--[[
    HUD update function

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function HUD:update(dt)
    
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
    local cornerOffset = 75
    -- render HUD display with shadow
    love.graphics.setColor(20/255, 20/255, 20/255, 200/255)
    love.graphics.draw(GTextures['hud'], GQuads['hud'][1], cameraX + cornerOffset + 5, cameraY + cornerOffset + 5)
    love.graphics.draw(GTextures['hud'], GQuads['hud'][1], cameraX + cornerOffset + 5, cameraY + cornerOffset + 5)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(GTextures['hud'], GQuads['hud'][1], cameraX + cornerOffset, cameraY + cornerOffset)
    love.graphics.draw(GTextures['hud'], GQuads['hud'][1], cameraX + cornerOffset, cameraY + cornerOffset)
    -- render health
    love.graphics.setFont(GFonts['funkrocker-smaller'])
    self:renderStatBar(cameraX, cameraY, self.player.health, 4, 150, 165, 130)
    -- render ammo
    self:renderStatBar(cameraX, cameraY, self.player.ammo, 3, 210, 225, 190)
end

--[[
    Renders out the health and ammo bars in the HUD

    Params:
        ...
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
