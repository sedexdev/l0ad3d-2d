Player = Class{}

function Player:init(id)
    self.id = id
    self.width = 32
    self.height = 32
    self.x = WINDOW_WIDTH / 2 - (self.width / 2)
    self.y = WINDOW_HEIGHT / 2 - (self.height / 2)
    self.cameraScrollX = 0
    self.cameraScrollY = 0
    self.powerups = {}
    self.health = 1000
    self.ammo = 5000
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

    self.cameraScrollX = self.x - (WINDOW_WIDTH / 2) + (self.width / 2)
    self.cameraScrollY = self.y - (WINDOW_HEIGHT / 2) + (self.height / 2)
end

function Player:render()
    love.graphics.setColor(0/255, 1, 0/255, 1)
    love.graphics.translate(-math.floor(self.cameraScrollX), -math.floor(self.cameraScrollY))
    love.graphics.circle("fill", self.x, self.y, 16)
end
