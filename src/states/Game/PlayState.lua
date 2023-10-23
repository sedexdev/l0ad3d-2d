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
