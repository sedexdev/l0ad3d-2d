-- globablly available constansts
WINDOW_WIDTH = 1920
WINDOW_HEIGHT = 1080

-- global resources
GFonts = {
    ['blood-smaller'] = love.graphics.newFont('fonts/HoMicIDE EFfeCt.ttf', 32),
    ['blood-small'] = love.graphics.newFont('fonts/HoMicIDE EFfeCt.ttf', 48),
    ['blood-menu'] = love.graphics.newFont('fonts/HoMicIDE EFfeCt.ttf', 64),
    ['blood-highscores'] = love.graphics.newFont('fonts/HoMicIDE EFfeCt.ttf', 108),
    ['blood-title'] = love.graphics.newFont('fonts/HoMicIDE EFfeCt.ttf', 160),
    ['blood-count'] = love.graphics.newFont('fonts/HoMicIDE EFfeCt.ttf', 192)
}

GTextures = {

}

GAudio = {

}

GQuads = {

}

GStateMachine = StateMachine {
    ['menu'] = function() return MenuState() end,
    ['countdown'] = function() return CountdownState() end,
    ['playing'] = function() return PlayState() end,
    ['highscores'] = function() return HighScoreState() end
}
