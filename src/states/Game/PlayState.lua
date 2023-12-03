--[[
    PlayState: class

    Includes: BaseState - provides base functions for state classes

    Description:
        Handles all events that happen while the game is in play.
        This includes calling functions to update game components,
        render sprites, and track the player with the camera
]]

PlayState = Class{__includes = BaseState}

--[[
    PlayState enter function. Defined in the state machine and
    BaseState this function is called whenever the GStateMachine
    is called with 'playing' as the stateName argument. Initialises 
    the Map and the state machines for the other game Entity objects

    Params:
        params: table - list of state dependent values this state requires
    Returns:
        nil
]]
function PlayState:enter(params)
    self.highScores = params.highScores
    self.player = params.player
    self.map = params.map
    self.systemManager = params.systemManager
    self.level = params.level
    self.score = params.score
    self.map:generateLevel(self.systemManager)
end

--[[
    PlayState constructor. Creates camera coordinate attributes
    for trcking the player in the centre of the screen as they
    move around

    Params:
        none
    Returns:
        nil
]]
function PlayState:init()
    self.cameraX = 0
    self.cameraY = 0
    -- pause gameplay
    self.paused = false
    self.selected = 1
    self.confirm = false
    -- life lost message
    self.fontHeight = GFonts['funkrocker-medium']:getHeight()
    self.messageY = -self.fontHeight
    self.duration = 2
    -- event listeners
    Event.on('levelComplete', function ()
        Event.dispatch('score', 2000 * self.level)
        self.systemManager.enemySystem:increaseStats()
        GStateMachine:change('complete', {
            highScores = self.highScores,
            player = self.player,
            map = self.map,
            systemManager = self.systemManager,
            score = self.score,
            level = self.level
        })
    end)
    Event.on('gameOver', function ()
        GStateMachine:change('gameover', {
            highScores = self.highScores,
            map = self.map,
            score = self.score,
            level = self.level
        })
    end)
    Event.on('score', function (points)
        self.score = self.score + points
    end)
    Event.on('lostLife', function ()
        Timer.tween(self.duration, {
            [self] = {messageY = (WINDOW_HEIGHT / 2) - (self.fontHeight / 2)}
        }):finish(function ()
            Timer.after(self.duration, function ()
                Timer.tween(self.duration, {
                    [self] = {messageY = (WINDOW_HEIGHT + self.fontHeight)}
                }):finish(function ()
                    self.messageY = -self.fontHeight
                end)
            end)
        end)
    end)
end

--[[
    PlayState update function. Updates all game components including the
    Player, enemy Entity objects, and the camera

    Key bindings:
        escape: pauses the game
    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function PlayState:update(dt)
    collectgarbage('collect')
    if love.keyboard.wasPressed('escape') then
        self.paused = true
    end
    if not self.paused then
        self:runGameLoop(dt)
    else
        self:processPauseMenuInput()
    end
    Timer.update(dt)
end

--[[
    Runs the core gameply loop during frame rate cycle updates

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function PlayState:runGameLoop(dt)
    -- update all game systems
    self.systemManager:update(dt)
    -- update Player
    self.player:update(dt)
    -- update the camera to track the Player
    self:updateCamera()
end

--[[
    Updates the location of the 'camera' so that the screen is 
    translated in relation to the Player object. The translation
    is based off the players position minus the pixel value of the
    center of the screen

    Params:
        none
    Returns:
        nil
]]
function PlayState:updateCamera()
    self.cameraX = self.player.x - (WINDOW_WIDTH / 2) + (self.player.width / 2)
    self.cameraY = self.player.y - (WINDOW_HEIGHT / 2) + (self.player.height / 2)
end

--[[
    PlayState render function. Applies the translations that are
    set in PlayState:updateCamera and renders out gameplay elements

    Params:
        none
    Returns:
        nil
]]
function PlayState:render()
    love.graphics.translate(-math.floor(self.cameraX), -math.floor(self.cameraY))
    self.map:render()
    self.systemManager:render()
    self.player:render()
    self:displayScore()
    -- debug data
    self:displayFPS()
    self:displayPlayerData()
    -- display life lost message
    self:renderLifeLostMessage()
    -- show menu if paused and not selecting restart
    if self.paused and not self.confirm then
        self:renderPauseMenu()
    end
    if self.confirm then
        self:renderConfirmMenu()
    end
end

--[[
    Tweens a message down the screen to inform the player that
    a life was lost and how many lives they have left

    Params:
        none
    Returns:
        nil
]]
function PlayState:renderLifeLostMessage()
    local message = 'REMAINING LIVES: ' .. self.player.lives
    love.graphics.setFont(GFonts['funkrocker-medium'])
    -- print text shadow
    love.graphics.setColor(0/255, 0/255, 0/255, 1)
    love.graphics.printf(message, self.cameraX + 2, self.cameraY + self.messageY + 2, WINDOW_WIDTH, 'center')
    love.graphics.printf(message, self.cameraX + 2, self.cameraY + self.messageY + 2, WINDOW_WIDTH, 'center')
    -- print message
    love.graphics.setColor(1, 0/255, 0/255, 1)
    love.graphics.printf(message, self.cameraX, self.cameraY + self.messageY, WINDOW_WIDTH, 'center')
end

--[[
    Renders the pause menu after the user has pressed escape
    during gameplay

    Params:
        none
    Returns:
        nil
]]
function PlayState:renderPauseMenu()
    -- draw dark background  
    love.graphics.setColor(10/255, 10/255, 10/255, 150/255)
    -- to keep things centered with the translation add the values to the (cameraX, cameraY) vector
    love.graphics.rectangle('fill', self.cameraX, self.cameraY, WINDOW_WIDTH, WINDOW_HEIGHT)
    -- display Paused
    love.graphics.setFont(GFonts['blood-title'])
    love.graphics.setColor(10/255, 10/255, 10/255, 1)
    love.graphics.printf('PAUSED', self.cameraX + 2, (self.cameraY + WINDOW_HEIGHT / 4) + 2, WINDOW_WIDTH, 'center')
    love.graphics.printf('PAUSED', self.cameraX + 2, (self.cameraY + WINDOW_HEIGHT / 4) + 2, WINDOW_WIDTH, 'center')
    love.graphics.setColor(1, 0/255, 0/255, 1)
    love.graphics.printf('PAUSED', self.cameraX, (self.cameraY + WINDOW_HEIGHT / 4), WINDOW_WIDTH, 'center')
    -- draw menu
    love.graphics.setFont(GFonts['funkrocker-menu'])
    self:renderOption('CONTINUE', 1, 200)
    self:renderOption('RESTART', 2, 300)
    self:renderOption('QUIT', 3, 400)
end

--[[
    Renders the confirm menu after the use has chosen to
    restart the game. Restarting wipes all current game
    data and starts from scratch

    Params:
        none
    Returns:
        nil
]]
function PlayState:renderConfirmMenu()
    -- draw dark background  
    love.graphics.setColor(10/255, 10/255, 10/255, 150/255)
    -- to keep things centered with the translation add the values to the (cameraX, cameraY) vector
    love.graphics.rectangle('fill', self.cameraX, self.cameraY, WINDOW_WIDTH, WINDOW_HEIGHT)
    -- display Paused
    love.graphics.setFont(GFonts['funkrocker-medium'])
    love.graphics.setColor(10/255, 10/255, 10/255, 1)
    love.graphics.printf('CONFIRM RESTART', self.cameraX + 2, (self.cameraY + WINDOW_HEIGHT / 4) + 2, WINDOW_WIDTH, 'center')
    love.graphics.printf('CONFIRM RESTART', self.cameraX + 2, (self.cameraY + WINDOW_HEIGHT / 4) + 2, WINDOW_WIDTH, 'center')
    love.graphics.setColor(1, 0/255, 0/255, 1)
    love.graphics.printf('CONFIRM RESTART', self.cameraX, (self.cameraY + WINDOW_HEIGHT / 4), WINDOW_WIDTH, 'center')
    -- draw menu
    love.graphics.setFont(GFonts['funkrocker-menu'])
    self:renderOption('YES', 1, 200)
    self:renderOption('NO', 2, 300)
    -- draw warning at bottom
    local warning = 'Restarting will wipe all current game data'
    love.graphics.setFont(GFonts['funkrocker-small'])
    love.graphics.setColor(10/255, 10/255, 10/255, 1)
    love.graphics.printf(warning, self.cameraX + 2, self.cameraY + (WINDOW_HEIGHT - 200) + 2, WINDOW_WIDTH, 'center')
    love.graphics.printf(warning, self.cameraX + 2, self.cameraY + (WINDOW_HEIGHT - 200) + 2, WINDOW_WIDTH, 'center')
    love.graphics.setColor(1, 0/255, 0/255, 1)
    love.graphics.printf(warning, self.cameraX, self.cameraY + (WINDOW_HEIGHT - 200), WINDOW_WIDTH, 'center')
end

--[[
    Renders the pause menu options using a provided y offset

    Params:
        name:    string - name of the menu option
        id:      number - id used to verify what has been selected
        yOffset: number - y offset used to render the menu options in a stack
    Returns;
        nil
]]
function PlayState:renderOption(name, id, yOffset)
    love.graphics.setColor(10/255, 10/255, 10/255, 1)
    love.graphics.printf(name, self.cameraX + 2, (self.cameraY + (WINDOW_HEIGHT / 3 + yOffset)) + 2, WINDOW_WIDTH, 'center')
    love.graphics.printf(name, self.cameraX + 2, (self.cameraY + (WINDOW_HEIGHT / 3 + yOffset)) + 2, WINDOW_WIDTH, 'center')
    -- reset the colour
    love.graphics.setColor(1, 0/255, 0/255, 1)
    if self.selected == id then
        love.graphics.setColor(1, 1, 1, 1)
    end
    love.graphics.printf(name, self.cameraX, self.cameraY + (WINDOW_HEIGHT / 3 + yOffset), WINDOW_WIDTH, 'center')
end

--[[
    Checks Player input and updates the game depending on
    the pause menu options selected

    Params:
        none
    Returns:
        nil
]]
function PlayState:processPauseMenuInput()
    if self.confirm then
        self:processConfirmMenuInput()
    else
        if love.keyboard.wasPressed('up') then
            Audio_MenuOption()
            self.selected = self.selected <= 1 and 3 or self.selected - 1
        end
        if love.keyboard.wasPressed('down') then
            Audio_MenuOption()
            self.selected = self.selected >= 3 and 1 or self.selected + 1
        end
        -- handle selection
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            Audio_PlayerShot()
            if self.selected == 1 then
                -- continue game with all player data
                self.paused = false
            elseif self.selected == 2 then
                -- set selected option and confirm to true
                self.selected = 1
                self.confirm = true
            else
                -- quit to MenuState
                GStateMachine:change('menu', {
                    highScores = self.highScores
                })
            end
        end
    end
end

--[[
    Checks Player input and updates the game depending on
    the pause menu options selected

    Params:
        none
    Returns:
        nil
]]
function PlayState:processConfirmMenuInput()
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        Audio_MenuOption()
        self.selected = self.selected == 1 and 2 or 1
    end
    -- handle selection
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        Audio_PlayerShot()
        if self.selected == 1 then
            -- restart game with fresh data
            self.player = nil
            self.map = nil
            self.systemManager = nil
            collectgarbage('collect')
            GStateMachine:change('select', {
                highScores = self.highScores,
            })
        else
            -- reset selected options and confirm to false
            self.selected = 1
            self.confirm = false
        end
    end
end

--[[
    Renders the current FPS

    Params:
        none
    Returns:
        nil
]]
function PlayState:displayScore()
    love.graphics.setFont(GFonts['funkrocker-small'])
    love.graphics.setColor(0/255, 0/255, 0/255, 255/255)
    love.graphics.print('Score: ' .. tostring(self.score), self.cameraX + (WINDOW_WIDTH - 300) + 2, self.cameraY + 50 + 2)
    love.graphics.print('Score: ' .. tostring(self.score), self.cameraX + (WINDOW_WIDTH - 300) + 2, self.cameraY + 50 + 2)
    love.graphics.setColor(1, 0/255, 0/255, 255/255)
    love.graphics.print('Score: ' .. tostring(self.score), self.cameraX + (WINDOW_WIDTH - 300), self.cameraY + 50)
    love.graphics.setColor(1, 1, 1, 1)
end

--[[
    Renders the current FPS

    Params:
        none
    Returns:
        nil
]]
function PlayState:displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(GFonts['funkrocker-small'])
    love.graphics.setColor(1, 0/255, 0/255, 255/255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), self.cameraX + 50, self.cameraY + 50)
    love.graphics.setColor(1, 1, 1, 1)
end

--[[
    Displays player data on the screen

    Params:
        none
    Retuns:
        nil
]]
function PlayState:displayPlayerData()
    love.graphics.setFont(GFonts['funkrocker-smaller'])
    love.graphics.setColor(0/255, 1, 0/255, 1)
    love.graphics.print('Health: ' .. tostring(self.player.health), self.cameraX + 50, self.cameraY + 140)
    love.graphics.print('Ammo: ' .. tostring(self.player.ammo), self.cameraX + 50, self.cameraY + 180)
    love.graphics.print('Red key: ' .. tostring(self.player.keys['red']), self.cameraX + 50, self.cameraY + 220)
    love.graphics.print('Green key: ' .. tostring(self.player.keys['green']), self.cameraX + 50, self.cameraY + 260)
    love.graphics.print('Blue key: ' .. tostring(self.player.keys['blue']), self.cameraX + 50, self.cameraY + 300)
    love.graphics.print('Invincible: ' .. tostring(self.player.powerups.invincible), self.cameraX + 50, self.cameraY + 340)
    love.graphics.print('Double speed: ' .. tostring(self.player.powerups.doubleSpeed), self.cameraX + 50, self.cameraY + 380)
    love.graphics.print('One shot Boss kill: ' .. tostring(self.player.powerups.oneShotBossKill), self.cameraX + 50, self.cameraY + 420)
    love.graphics.print('X: ' .. tostring(self.player.x), self.cameraX + 50, self.cameraY + 460)
    love.graphics.print('Y: ' .. tostring(self.player.y), self.cameraX + 50, self.cameraY + 500)
    love.graphics.print('Direction: ' .. self.player.direction, self.cameraX + 50, self.cameraY + 540)
    love.graphics.print('Boss spawned: ' .. tostring(self.systemManager.enemySystem.bossSpawned), self.cameraX + 50, self.cameraY + 580)
    love.graphics.print('Level: ' .. tostring(self.level), self.cameraX + 50, self.cameraY + 620)
    love.graphics.print('Invulnerable: ' .. tostring(self.player.invulnerable), self.cameraX + 50, self.cameraY + 660)
    love.graphics.print('Lives: ' .. tostring(self.player.lives), self.cameraX + 50, self.cameraY + 700)
end
