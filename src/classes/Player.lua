Player = Class{}

function Player:init(id, def)
    self.id = id
    self.def = def
    self.width = 32
    self.height = 32
    self.x = WINDOW_WIDTH / 2 - (self.width / 2)
    self.y = WINDOW_HEIGHT / 2 - (self.height / 2)
end

function Player:update(dt)
    if love.keyboard.isDown('up') or love.keyboard.isDown('w') then
        self.y = self.y - PLAYER_SPEED * dt
    end
    if love.keyboard.isDown('down') or love.keyboard.isDown('s') then
        self.y = self.y + PLAYER_SPEED * dt
    end
    if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
        self.x = self.x - PLAYER_SPEED * dt
    end
    if love.keyboard.isDown('right') or love.keyboard.isDown('d') then
        self.x = self.x + PLAYER_SPEED * dt
    end
end

function Player:render()
    if self.id == 1 then
        love.graphics.setColor(0/255, 1, 0/255, 1)
    else
        love.graphics.setColor(0/255, 0/255, 1, 1)
    end
    love.graphics.circle("fill", self.x, self.y, 16)
end
