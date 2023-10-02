-- globablly available constansts
WINDOW_WIDTH = 1920
WINDOW_HEIGHT = 1080

-- player
PLAYER_SPEED = 600

-- global resources
GFonts = {
    ['funkrocker-smaller'] = love.graphics.newFont('fonts/funkrocker.ttf', 32),
    ['funkrocker-small'] = love.graphics.newFont('fonts/funkrocker.ttf', 48),
    ['funkrocker-menu'] = love.graphics.newFont('fonts/funkrocker.ttf', 64),
    ['funkrocker-highscores'] = love.graphics.newFont('fonts/Funkrocker.ttf', 108),
    ['blood-title'] = love.graphics.newFont('fonts/HoMicIDE EFfeCt.ttf', 160),
    ['blood-count'] = love.graphics.newFont('fonts/HoMicIDE EFfeCt.ttf', 192),
}

GTextures = {

}

GAudio = {

}

GQuads = {

}

GStateMachine = StateMachine {
    ['menu'] = function() return MenuState() end,
    ['select'] = function() return SelectCharacterState() end,
    ['countdown'] = function() return CountdownState() end,
    ['playing'] = function() return PlayState() end,
    ['highscores'] = function() return HighScoreState() end
}
