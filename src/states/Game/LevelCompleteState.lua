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
    self.highScores = params.highScores
    self.player = params.player
    self.map = params.map
    self.systemManager = params.systemManager
    self.level = params.level
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
    self.y = -self.fontHeight
    self.duration = 2
end

--[[
    LevelCompleteState update function. Updates the timer for
    tweening the Level Complete mesage

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function LevelCompleteState:update(dt)
    Timer.tween(self.duration, {
        [self] = {y = (WINDOW_HEIGHT / 2) - (self.fontHeight / 2)}
    }):finish(
        Timer.tween(self.duration, {
            [self] = {y = WINDOW_HEIGHT + self.fontHeight}
        }):finish(
            GStateMachine:change('countdown', {
                highScores = self.highScores,
                player = self.player,
                map = self.map,
                systemManager = self.systemManager,
                level = self.level + 1
            })
        )
    )
end

--[[
    LevelCompleteState render function

    Params:
        none
    Returns:
        nil
]]
function LevelCompleteState:render()
    local message = 'LEVEL COMPLETE'
    love.graphics.setFont(GFonts['funkrocker-medium'])
    local fontWidth = GFonts['funkrocker-medium']:getWidth(message)
    love.graphics.setColor(1, 0/255, 0/255, 1)
    love.graphics.printf(message,
        (WINDOW_WIDTH / 2) - (fontWidth / 2), self.y,
        WINDOW_WIDTH,
        'center'
    )
end
