--[[
    LevelCompleteState: class

    Includes: BaseState - provides base functions for state classes

    Description:
        Displays a 'Level Complete' message to the player and restarts
        play by starting the player back in the start area. The boss
        has their health increased slighly and grunt enemies damage 
        increases. Any powerups are removed and keys rendered back
        in their original location
]]

LevelCompleteState = Class{__includes = BaseState}

--[[
    LevelCompleteState enter function. Defined in the state machine and
    BaseState this function is called whenever the GStateMachine
    is called with 'complete' as the stateName argument. The 
    Timer.after callback function changes state after 3 seconds

    Params:
        params: table - list of state dependent values this state requires
    Returns:
        nil
]]
function LevelCompleteState:enter(params)
    self.highScores    = params.highScores
    self.player        = params.player
    self.map           = params.map
    self.systemManager = params.systemManager
    self.hud           = params.hud
    self.level         = params.level
    self.score         = params.score
    -- tween message in
    Timer.tween(self.duration, {
        [self] = {y = (WINDOW_HEIGHT / 2) - (self.fontHeight / 2)}
    }):finish(function ()
        Timer.after(self.duration, function ()
            Timer.tween(self.duration, {
                [self] = {y = WINDOW_HEIGHT + self.fontHeight}
            }):finish(function ()
                -- create new instances
                local map = Map()
                local player = Player(
                    self.player.id,
                    GAnimationDefintions['character'..tostring(self.player.id)],
                    Copy(GCharacterDefinition)
                )
                -- create new SystemManager
                local systemManager = SystemManager(map, player)
                -- player lives need to carry over
                player.lives        = self.player.lives
                -- Player stateMachine
                player.stateMachine = StateMachine {
                    ['idle']    = function () return PlayerIdleState(player) end,
                    ['walking'] = function ()
                        local walkingState = PlayerWalkingState(player, map)
                        walkingState:subscribe(systemManager)
                        walkingState:subscribe(systemManager.doorSystem)
                        walkingState:subscribe(systemManager.collisionSystem)
                        walkingState:subscribe(systemManager.objectSystem)
                        walkingState:subscribe(systemManager.enemySystem)
                        walkingState:subscribe(systemManager.effectsSystem)
                        return walkingState
                    end
                }
                player.stateMachine:change('idle')
                -- clear game data
                self.player        = nil
                self.map           = nil
                self.systemManager = nil
                self.hud           = nil
                -- collect nil objects before restarting in new level
                collectgarbage('collect')
                GStateMachine:change('countdown', {
                    highScores    = self.highScores,
                    player        = player,
                    map           = map,
                    systemManager = systemManager,
                    hud           = HUD(player),
                    score         = self.score,
                    level         = self.level + 1
                })
            end)
        end)
    end)
end

--[[
    LevelCompleteState constructor

    Params:
        none
    Returns:
        nil
]]
function LevelCompleteState:init()
    self.fontHeight = GFonts['funkrocker-medium']:getHeight()
    self.y          = -self.fontHeight
    self.duration   = 2
end

--[[
    LevelCompleteState update function

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function LevelCompleteState:update(dt)
    if love.keyboard.wasPressed('escape') then
        GStateMachine:change('menu')
    end
    Timer.update(dt)
end

--[[
    LevelCompleteState render function

    Params:
        none
    Returns:
        nil
]]
function LevelCompleteState:render()
    -- render map in the background
    self.map:render()
    -- draw dark background  
    love.graphics.setColor(10/255, 10/255, 10/255, 150/255)
    -- to keep things centered with the translation add the values to the (cameraX, cameraY) vector
    love.graphics.rectangle('fill', 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
    -- draw message
    local message = 'LEVEL COMPLETE'
    love.graphics.setFont(GFonts['funkrocker-medium'])
    -- print text shadow
    love.graphics.setColor(0/255, 0/255, 0/255, 1)
    love.graphics.printf(message, 2, self.y + 2, WINDOW_WIDTH, 'center')
    love.graphics.printf(message, 2, self.y + 2, WINDOW_WIDTH, 'center')
    -- print message
    love.graphics.setColor(1, 0/255, 0/255, 1)
    love.graphics.printf(message, 0, self.y, WINDOW_WIDTH, 'center')
end
