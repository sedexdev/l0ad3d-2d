-- globablly available constansts
WINDOW_WIDTH, WINDOW_HEIGHT = love.window.getDesktopDimensions()

-- character select
AVATAR_WIDTH = 450
AVATAR_HEIGHT = 650

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
    ['player'] = love.graphics.newImage('graphics/character.png')
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

GEntityDefintions = {
    ['player'] = {
        texture = GTextures['player'],
        animations = {},
        health = 100,
        ammo = 5000,
        powerups = {}
    },
    ['enimies'] = {
        ['grunt'] = {},
        ['boss'] = {}
    },
    ['turret'] = {}
}
