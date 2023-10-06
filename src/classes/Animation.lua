Animation = Class{}

function Animation:init(frames, interval)
    self.frames = frames
    self.interval = interval
    self.currentFrame = 1
    self.timer = 0
end

function Animation:update(dt)
    if #self.frames > 1 then
        self.timer = self.timer + dt
        if self.timer > self.interval then
            self.currentFrame = math.max(1, (self.currentFrame + 1) % (#self.frames + 1))
            self.timer = self.timer % self.interval
        end
    end
end

function Animation:getCurrentFrame()
    return self.frames[self.currentFrame]
end