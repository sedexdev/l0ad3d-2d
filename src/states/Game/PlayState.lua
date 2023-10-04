PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
    self.highScores = params.highScores
    self.player = params.player
    self.map = params.map
    self.map:generateTiles()
end

function PlayState:init()
    self.cameraX = 0
    self.cameraY = 0
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        GStateMachine:change('menu', {
            highScores = self.highScores
        })
    end
    self.player:update(dt)
    self:updateCamera()
end

function PlayState:updateCamera()
    self.cameraX = self.player.x - (WINDOW_WIDTH / 2) + (self.player.width / 2)
    self.cameraY = self.player.y - (WINDOW_HEIGHT / 2) + (self.player.height / 2)
end

function PlayState:render()
    love.graphics.translate(-math.floor(self.cameraX), -math.floor(self.cameraY))
    self.map:render()
    self.player:render()
end