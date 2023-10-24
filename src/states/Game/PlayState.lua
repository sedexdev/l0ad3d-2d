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
    
    TODO: review where Entitys are spawned and tracked

    Params:
        params: table - list of state dependent values this state requires
    Returns:
        nil
]]
function PlayState:enter(params)
    self.highScores = params.highScores
    self.map = params.map
    self.map:generateLevel()
    self.player = params.player
    self.player.stateMachine = StateMachine {
        ['idle'] = function () return PlayerIdleState(self.player) end,
        ['walking'] = function () return PlayerWalkingState(self.player, self.map) end,
    }
    self.player.stateMachine:change('idle')
    self.grunt = params.grunt
    self.grunt.stateMachine = StateMachine {
        ['walking'] = function () return GruntWalkingState(self.grunt, self.player) end,
        ['attacking'] = function () return GruntAttackingState(self.grunt, self.player) end,
    }
    self.grunt.stateMachine:change('walking')
    self.boss = params.boss
    self.boss.stateMachine = StateMachine {
        ['walking'] = function () return BossWalkingState(self.boss, self.player) end
    }
    self.boss.stateMachine:change('walking')
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

    TODO: change escape key to change to PauseState

    Key bindings:
        escape: changes state back to the MenuState
    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        GStateMachine:change('menu', {
            highScores = self.highScores
        })
    end

    -- check if the player has collided with the wall in this area
    local wallCollision = self.player:checkWallCollision(self.player.currentArea.id)
    if wallCollision.detected then
        -- get the area definition for the current area
        local area = self.map:getAreaDefinition(self.player.currentArea.id)
        -- declare corrections for readability if the if/elseif statements below
        local correctionOffset = 18
        local leftCorrection = area.x - WALL_OFFSET + correctionOffset
        local rightCorrection = area.x + (area.width * (64 * 5)) - CHARACTER_WIDTH + WALL_OFFSET - correctionOffset
        local topCorrection = area.y - WALL_OFFSET + correctionOffset
        local bottomCorrection = area.y + (area.height * (32 * 5)) - CHARACTER_HEIGHT + WALL_OFFSET - correctionOffset
        -- for single wall collisions just update x or y
        if wallCollision.edge == 'L' then
            self.player.x = leftCorrection
        elseif wallCollision.edge == 'R' then
            self.player.x = rightCorrection
        elseif wallCollision.edge == 'T' then
            self.player.y = topCorrection
        elseif wallCollision.edge == 'B' then
            self.player.y = bottomCorrection
        -- for multi-wall collisions update x and y
        elseif wallCollision.edge == 'LT' then
            self.player.x = leftCorrection
            self.player.y = topCorrection
        elseif wallCollision.edge == 'RT' then
            self.player.x = rightCorrection
            self.player.y = topCorrection
        elseif wallCollision.edge == 'LB' then
            self.player.x = leftCorrection
            self.player.y = bottomCorrection
        elseif wallCollision.edge == 'RB' then
            self.player.x = rightCorrection
            self.player.y = bottomCorrection
        end
    end

    self.player:update(dt)
    self.grunt:update(dt)
    self.boss:update(dt)
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
    self.player:render()
    self.grunt:render()
    self.boss:render()
end
