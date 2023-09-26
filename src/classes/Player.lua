Player = Class{}

function Player:init(id)
    self.id = id
    self.width = 32
    self.height = 32
    self.x = WINDOW_WIDTH / 2 - (self.width / 2)
    self.y = WINDOW_HEIGHT / 2 - (self.height / 2)
    self.cameraScroll = 0
    self.powerups = {}
    self.health = 1000
    self.ammo = 5000
end

function Player:update(dt)
    if love.keyboard.isDown('up') then
        self.y = self.y - PLAYER_SPEED * dt
    end
    if love.keyboard.isDown('down') then
        self.y = self.y + PLAYER_SPEED * dt
    end
    if love.keyboard.isDown('left') then
        self.x = self.x - PLAYER_SPEED * dt
    end
    if love.keyboard.isDown('right') then
        self.x = self.x + PLAYER_SPEED * dt
    end

    self.cameraScroll = self.x - (WINDOW_WIDTH / 2) + (self.width / 2)
end

function Player:render()
    love.graphics.setColor(0/255, 1, 0/255, 1)
    love.graphics.translate(-math.floor(self.cameraScroll), 0)
    love.graphics.circle("fill", self.x, self.y, 16)
end
