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
    self.map = params.map
    self.systemManager = params.systemManager
    self.map:generateLevel(self.systemManager)

    -- Entity (Player) stateMachine
    self.player = params.player
    self.player.stateMachine = StateMachine {
        ['idle'] = function () return PlayerIdleState(self.player) end,
        ['walking'] = function () return PlayerWalkingState(self.player, self.map) end,
    }
    self.player.stateMachine:change('idle')

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
    -- check for an handle Player/Entity interactions in the Map
    self:checkMapInteractions(area)
    self:checkObjectInteractions(currentAreaID)
    -- update Map
    self.systemManager:update(dt)
    -- update Entity objects
    self.player:update(dt)
    -- update the camera to track the Player
    self:updateCamera()
end

--[[
    Check for and handle interactions with game objects

    Params:
        currentAreaID: number - ID of the Players current area
    Returns:
        nil
]]
function PlayState:checkObjectInteractions(currentAreaID)
    -- to check for key collisions make sure the Player is in an area with a key
    for _, key in pairs(self.systemManager.powerupSystem.keys) do
        if currentAreaID == key.areaID then
            if self.systemManager.collisionSystem:objectCollision(key) then
                self.systemManager.powerupSystem:handleKeyCollision(key)
            end
        end
    end
    -- check for crate collisions in the current area
    for _, crate in pairs(self.systemManager.powerupSystem.crates) do
        if currentAreaID == crate.areaID then
            local playerCollision = self.systemManager.collisionSystem:crateCollision(crate, self.player)
            if playerCollision.detected then
                self.systemManager.collisionSystem:handlePlayerCrateCollision(crate, playerCollision.edge)
            end
            -- check for grunt collisions
            for _, grunt in pairs(self.systemManager.enemySystem.grunts) do
                if grunt.areaID == currentAreaID then
                    local gruntCollision = self.systemManager.collisionSystem:crateCollision(crate, grunt)
                    if gruntCollision.detected then
                        self.systemManager.collisionSystem:handleEnemyCrateCollision(grunt, gruntCollision.edge)
                    end
                end
            end
            -- check for boss collisions
            if self.systemManager.enemySystem.boss then
                local bossCollision = self.systemManager.collisionSystem:crateCollision(crate, self.systemManager.enemySystem.boss)
                if bossCollision.detected then
                    self.systemManager.collisionSystem:handleEnemyCrateCollision(self.systemManager.enemySystem.boss, bossCollision.edge)
                end
            end
        end
    end
    -- check for powerup collisions in the current area
    for _, category in pairs(self.systemManager.powerupSystem.powerups) do
        for _, powerup in pairs(category) do
            if currentAreaID == powerup.areaID then
                if self.systemManager.collisionSystem:objectCollision(powerup) then
                    self.systemManager.powerupSystem:handlePowerUpCollision(powerup)
                end
            end
        end
    end
end

--[[
    Check for and handle interactions with game objects

    Params:
        area: number - Current MapArea object
    Returns:
        nil
]]
function PlayState:checkMapInteractions(area)
    -- check if the player has collided with the wall in this area
    local wallCollision = self.systemManager.collisionSystem:checkWallCollision(area, self.player)
    if wallCollision.detected then
        -- handle the wall collision
        self.systemManager.collisionSystem:handlePlayerWallCollision(area, wallCollision.edge)
    end
    -- check for any area door collisions
    local doors = nil
    if area.type == 'area' then
        doors = self.systemManager.doorSystem:getAreaDoors(area.id)
    else
        doors = self.systemManager.doorSystem:getCorridorDoors(area.id)
    end
    if doors then
        for _, door in pairs(doors) do
            -- first check Player proximity and open door if not locked
            local proximity = self.systemManager.collisionSystem:checkDoorProximity(door)
            if proximity then
                -- then check collision with the Door object to avoid Player running over it
                local doorCollision = self.systemManager.collisionSystem:checkDoorCollsion(door)
                if doorCollision.detected then
                    -- and handle the collision if so
                    self.systemManager.collisionSystem:handleDoorCollision(door, doorCollision.edge)
                end
            end
        end
    end
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
end

--[[
    Renders the pause menu options using a provided y offset

    Params:
        name: string - name of the menu option
        id: number - id used to verify what has been selected
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
            -- restart game with fresh Player data
            local player = Player(
                self.player.id,
                GAnimationDefintions['character'..tostring(self.player.id)],
                GCharacterDefinition
            )
            local map = Map(player)
            GStateMachine:change('countdown', {
                highScores = self.highScores,
                player = player,
                map = map,
                systemManager = SystemManager(player, map)
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