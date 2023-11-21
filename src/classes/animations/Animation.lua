--[[
    Animation: class

    Description:
        Updates the animations for a given sprite according
        to the number of frames passed in and an interval
        over which to change the frames
]]

Animation = Class{}

--[[
    Animation constructor

    Params:
        frames:   table  - the indices of the sprite sheet to execute the animation
        interval: number - period elapsed before changing frames
    Returns:
        nil
]]
function Animation:init(frames, interval)
    self.frames = frames
    self.interval = interval
    self.currentFrame = 1
    self.timer = 0
end

--[[
    Animation update function. If more than 1 frame is present
    in <self.frames> then increment <self.timer> by <dt> on every
    frame processed by the enigine. Once <self.timer> passes
    <self.interval> change the current frame to the next in the
    table or switch back to the first one 

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function Animation:update(dt)
    if #self.frames > 1 then
        self.timer = self.timer + dt
        if self.timer > self.interval then
            self.currentFrame = math.max(1, (self.currentFrame + 1) % (#self.frames + 1))
            self.timer = self.timer % self.interval
        end
    end
end

--[[
    Returns the number value of the current frame being
    animated

    Params:
        none
    Returns:
        number: the sprite sheet index representing the image 
                to draw during this frame
]]
function Animation:getCurrentFrame()
    return self.frames[self.currentFrame]
end
