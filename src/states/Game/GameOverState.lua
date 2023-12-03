--[[
    GameOverState: class

    Includes: BaseState - provides base functions for state classes

    Description:
        Displays the GAME OVER message to the player. If a highscore 
        is obtained the player is directd to enter their highscore by 
        changing to the EnterHighScoreState, otherwise changing to the
        MenuState 
]]

GameOverState = Class{__includes = BaseState}

--[[
    GameOverState enter function. Defined in the state machine and
    BaseState this function is called whenever the GStateMachine
    is called with 'gameover' as the stateName argument

    Params:
        params: table - list of state dependent values this state requires
    Returns:
        nil
]]
function GameOverState:enter(params)
    self.highScores = params.highScores
    self.map        = params.map
    self.level      = params.level
    self.score      = params.score
    -- tween message in
    Timer.tween(self.duration, {
        [self] = {y = (WINDOW_HEIGHT / 2) - (self.fontHeight / 2)}
    }):finish(function ()
        Timer.after(self.duration, function ()
            Timer.tween(self.duration, {
                [self] = {y = WINDOW_HEIGHT + self.fontHeight}
            }):finish(function ()
                -- TODO: implement Player score and change to high scores or menu
                GStateMachine:change('menu', {
                    highScores = self.highScores
                })
            end)
        end)
    end)
end

--[[
    GameOverState constructor

    Params:
        none
    Returns:
        nil
]]
function GameOverState:init()
    self.fontHeight = GFonts['funkrocker-medium']:getHeight()
    self.y          = -self.fontHeight
    self.duration   = 2
end


--[[
    GameOverState update function

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function GameOverState:update(dt)
    Timer.update(dt)
end

--[[
    GameOverState render function

    Params:
        none
    Returns:
        nil
]]
function GameOverState:render()
    -- render map in the background
    self.map:render()
    -- draw dark background  
    love.graphics.setColor(10/255, 10/255, 10/255, 150/255)
    -- to keep things centered with the translation add the values to the (cameraX, cameraY) vector
    love.graphics.rectangle('fill', 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
    -- draw message
    local message = 'GAME OVER'
    love.graphics.setFont(GFonts['funkrocker-medium'])
    -- print text shadow
    love.graphics.setColor(0/255, 0/255, 0/255, 1)
    love.graphics.printf(message, 0, self.y, WINDOW_WIDTH, 'center')
    love.graphics.printf(message, 0, self.y, WINDOW_WIDTH, 'center')
    -- print message
    love.graphics.setColor(1, 0/255, 0/255, 1)
    love.graphics.printf(message, 0, self.y, WINDOW_WIDTH, 'center')
end
