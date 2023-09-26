PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
    self.highScores = params.highScores
    self.player = params.player
end

function PlayState:init()
    
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        GStateMachine:change('menu', {
            highScores = self.highScores
        })
    end
    self.player:update(dt)
end

function PlayState:render()
    self.player:render()
end