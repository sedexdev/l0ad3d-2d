Map = Class{}

function Map:init()
    self.rooms = {}
    self.corridors = {}
    self.powerups = {}
end

function Map:update(dt)
    
end

function Map:render()
    for _, room in pairs(self.rooms) do
        room:render()
    end
    for _, corridor in pairs(self.corridors) do
        corridor:render()
    end
    for _, powerup in pairs(self.powerups) do
        powerup:render()
    end
end