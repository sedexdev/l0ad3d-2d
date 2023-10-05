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
    ['funkrocker-count'] = love.graphics.newFont('fonts/Funkrocker.ttf', 192),
    ['blood-title'] = love.graphics.newFont('fonts/HoMicIDE EFfeCt.ttf', 170),
}

GTextures = {
    ['grey-background'] = love.graphics.newImage('graphics/mottled-grey.png'),
    ['bullet-hole'] = love.graphics.newImage('graphics/bullet_hole.png'),
    ['floor-tiles'] = love.graphics.newImage('graphics/floor_tiles.png')
}

GAudio = {
    ['theme'] = love.audio.newSource('audio/theme.mp3', 'static'),
    ['gunshot'] = love.audio.newSource('audio/gunshot.wav', 'static'),
    ['select'] = love.audio.newSource('audio/select.wav', 'static'),
    ['error'] = love.audio.newSource('audio/error.wav', 'static'),
}

GQuads = {
    ['floor-tiles'] = GenerateQuads(GTextures['floor-tiles'], 64, 32)
}

GStateMachine = StateMachine {
    ['menu'] = function() return MenuState() end,
    ['select'] = function() return SelectCharacterState() end,
    ['countdown'] = function() return CountdownState() end,
    ['playing'] = function() return PlayState() end,
    ['highscores'] = function() return HighScoreState() end
}
