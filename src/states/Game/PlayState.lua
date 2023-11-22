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
    self.map:generateLevel(self.systemManager)
    -- pause gameplay
    self.paused = false
    self.selected = 1
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
    if love.keyboard.wasPressed('escape') then
        self.paused = true
    end
    if not self.paused then
        self:runGameLoop(dt)
    else
        self:processPauseMenuInput()
    end
end

--[[
    Runs the core gameply loop during frame rate cycle updates

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function PlayState:runGameLoop(dt)
    -- get the Player's current area
    local currentAreaID = self.player.currentArea.id
    local area = self.map:getAreaDefinition(currentAreaID)
    -- check for and handle Player/Entity game interactions
    self:checkInteractions(currentAreaID, area)
    -- update all game systems
    self.systemManager:update(dt)
    -- update Player
    self.player:update(dt)
    -- update the camera to track the Player
    self:updateCamera()
end

--[[
    Check for and handle interactions with game objects

    Params:
        currentAreaID: number - ID of the Players current area
        area:          table  - MapArea object
    Returns:
        nil
]]
function PlayState:checkInteractions(currentAreaID, area)
    self.systemManager:checkKeys(currentAreaID)
    self.systemManager:checkCrates(currentAreaID)
    self.systemManager:checkPowerUps(currentAreaID)
    self.systemManager:checkMap(area)
    self.systemManager:checkGrunts(currentAreaID)
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
    self:displayFPS()
    -- show menu if paused
    if self.paused then
        self:renderPauseMenu()
    end
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
    if love.keyboard.wasPressed('up') then
        GAudio['select']:stop()
        GAudio['select']:play()
        self.selected = self.selected <= 1 and 3 or self.selected - 1
    end
    if love.keyboard.wasPressed('down') then
        GAudio['select']:stop()
        GAudio['select']:play()
        self.selected = self.selected >= 3 and 1 or self.selected + 1
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        GAudio['select']:stop()
        GAudio['gunshot']:play()
        if self.selected == 1 then
            -- continue game with all player data
            self.paused = false
        elseif self.selected == 2 then
            -- restart game with fresh data
            local map = Map()
            local player = Player(
                self.selected,
                GAnimationDefintions['character'..tostring(self.selected)],
                GCharacterDefinition
            )
            local systemManager = SystemManager(map, player)
            -- Player stateMachine
            player.stateMachine = StateMachine {
                ['idle'] = function () return PlayerIdleState(player) end,
                ['walking'] = function ()
                    local walkingState = PlayerWalkingState(player, map)
                    walkingState:subscribe(systemManager)
                    walkingState:subscribe(systemManager.doorSystem)
                    walkingState:subscribe(systemManager.collisionSystem)
                    walkingState:subscribe(systemManager.powerupSystem)
                    walkingState:subscribe(systemManager.enemySystem)
                    walkingState:subscribe(systemManager.effectsSystem)
                    return walkingState
                end
            }
            player.stateMachine:change('idle')
            GStateMachine:change('countdown', {
                highScores = self.highScores,
                player = player,
                map = map,
                systemManager = systemManager
            })
        else
            -- quit to MenuState
            GStateMachine:change('menu', {
                highScores = self.highScores
            })
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
function PlayState:displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(GFonts['funkrocker-small'])
    love.graphics.setColor(1, 0/255, 0/255, 255/255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), self.cameraX + 50, self.cameraY + 50)
    love.graphics.setColor(1, 1, 1, 1)
end
