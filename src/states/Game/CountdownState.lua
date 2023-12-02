--[[
    CountdownState: class

    Includes: BaseState - provides base functions for state classes

    Description:
        Displays a 3, 2, 1 countdown to the player before changing
        into the PlayState 
]]

CountdownState = Class{__includes = BaseState}

--[[
    CountdownState enter function. Defined in the state machine and
    BaseState this function is called whenever the GStateMachine
    is called with 'countdown' as the stateName argument. The 
    Timer.after callback function changes state after 3 seconds

    Params:
        params: table - list of state dependent values this state requires
    Returns:
        nil
]]
function CountdownState:enter(params)
    self.highScores = params.highScores
    self.player = params.player
    self.map = params.map
    self.systemManager = params.systemManager
    self.level = params.level
    self.score = params.score
    Timer.after(3, function()
        GStateMachine:change('playing', {
            highScores = self.highScores,
            player = self.player,
            map = self.map,
            systemManager = self.systemManager,
            level = self.level,
            score = self.score
        })
    end)
end

--[[
    CountdownState constructor. Creates timer and count
    attributes to render out the current count

    Params:
        none
    Returns:
        nil
]]
function CountdownState:init()
    self.timer = 0
    self.count = 3
end

--[[
    CountdownState update function. Increments <self.timer> by
    <dt> on every frame processed by the engine and decrements
    <self.count> after <self.timer> is equal to or exceeds 1

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function CountdownState:update(dt)
    self.timer = self.timer + dt

    if self.timer >= 1 then
        self.count = self.count - 1
        self.timer = 0
    end

    Timer.update(dt)
end

--[[
    CountdownState render function. Draws out the value of
    <self.count> with a shadow behind for clarity

    Params:
        none
    Returns;
        nil
]]
function CountdownState:render()
    love.graphics.setFont(GFonts['funkrocker-large'])
    love.graphics.setColor(1, 1, 1, 1)
    -- draw shadow
    love.graphics.printf(tostring(self.count), 2, (WINDOW_HEIGHT / 3) + 2, WINDOW_WIDTH, 'center')
    love.graphics.printf(tostring(self.count), 2, (WINDOW_HEIGHT / 3) + 2, WINDOW_WIDTH, 'center')
    love.graphics.setColor(1, 0/255, 0/255, 1)
    -- draw count
    love.graphics.printf(tostring(self.count), 0, WINDOW_HEIGHT / 3, WINDOW_WIDTH, 'center')
end
