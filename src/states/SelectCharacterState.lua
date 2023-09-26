SelectCharacterState = Class{__includes = BaseState}

function SelectCharacterState:enter(params)
    self.highScores = params.highScores
    Timer.after(1, function()
        GStateMachine:change('countdown', {
            highScores = self.highScores,
            player = Player{1}
        })
    end)
end

function SelectCharacterState:init()
    
end

function SelectCharacterState:update(dt)
    Timer.update(dt)
end

function SelectCharacterState:render()
    
end