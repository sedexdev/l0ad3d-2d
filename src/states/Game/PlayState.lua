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
    self.highScores    = params.highScores
    self.player        = params.player
    self.map           = params.map
    self.systemManager = params.systemManager
    self.hud           = params.hud
    self.level         = params.level
    self.score         = params.score
    self.map:generateLevel(self.systemManager)
end

--[[
    PlayState exit function. Tears down game objects so the game can
    be restarted after a gameOver event or can progress after a 
    levelComplete event

    Params:
        event: string - event type to handle
    Returns:
        nil
]]
function PlayState:exit(event)
    if event == 'levelComplete' then
        self.systemManager = nil
    end
    if event == 'gameOver' then
        self.player        = nil
        self.map           = nil
        self.systemManager = nil
        self.hud           = nil
        self.level         = nil
        self.score         = nil
    end
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
    self.cameraX    = 0
    self.cameraY    = 0
    -- pause gameplay
    self.paused     = false
    self.selected   = 1
    self.confirm    = false
    -- life lost message
    self.fontHeight = GFonts['funkrocker-medium']:getHeight()
    self.messageY   = -self.fontHeight
    self.duration   = 2
    -- event listeners
    Event.on('levelComplete', function ()
        Audio_LevelComplete()
        Event.dispatch('score', 2000 * self.level)
        self:exit('levelComplete')
        IncreaseStats()
        GStateMachine:change('complete', {
            highScores    = self.highScores,
            player        = self.player,
            map           = self.map,
            hud           = self.hud,
            score         = self.score,
            level         = self.level
        })
    end)
    Event.on('gameOver', function ()
        Audio_GameOver()
        self:exit('gameOver')
        GStateMachine:change('gameover', {
            highScores = self.highScores,
            map        = self.map,
            score      = self.score,
            level      = self.level
        })
    end)
    Event.on('score', function (points)
        self.score = self.score + points
    end)
    Event.on('lostLife', function ()
        Audio_PlayerDeath()
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
    -- update HUD
    self.hud:update(dt)
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
    self.hud:render(self.cameraX, self.cameraY)
    self.player:render()
    self:displayScore()
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
                self.confirm  = true
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
            self.player        = nil
            self.map           = nil
            self.systemManager = nil
            self.hud           = nil
            collectgarbage('collect')
            GStateMachine:change('select', {
                highScores = self.highScores,
            })
        else
            -- reset selected options and confirm to false
            self.selected = 1
            self.confirm  = false
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
    love.graphics.print('Score: ' .. tostring(self.score), self.cameraX + (WINDOW_WIDTH - 330) + 2, self.cameraY + 60 + 2)
    love.graphics.print('Score: ' .. tostring(self.score), self.cameraX + (WINDOW_WIDTH - 330) + 2, self.cameraY + 60 + 2)
    love.graphics.setColor(1, 0/255, 0/255, 255/255)
    love.graphics.print('Score: ' .. tostring(self.score), self.cameraX + (WINDOW_WIDTH - 330), self.cameraY + 60)
    love.graphics.setColor(1, 1, 1, 1)
end
