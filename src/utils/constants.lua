-- globablly available constansts

--[[
    WINDOW DIMENSIONS
]]
WINDOW_WIDTH, WINDOW_HEIGHT = love.window.getDesktopDimensions()

--[[
    ENTITY CONSTANTS
]]
-- character sprite dimensions
CHARACTER_WIDTH = 384
CHARACTER_HEIGHT = 384
GRUNT_WIDTH = 384
GRUNT_HEIGHT = 384
BOSS_WIDTH = 384
BOSS_HEIGHT = 384

-- animations
CHARACTER_WALK_INTERVAL = 0.2
GRUNT_WALK_INTERVAL = 0.2
GRUNT_ATTACK_INTERVAL = 0.1
BOSS_WALK_INTERVAL = 0.1

-- entity speeds
CHARACTER_SPEED = 1200
GRUNT_SPEED = 250
BOSS_SPEED = 400

-- movement key bindings
MOVEMENT_KEYS = {'up', 'right', 'down', 'left', 'w', 'd', 's', 'a'}

--[[
    GAME RENDERING CONSTANTS
]]
-- character select state
AVATAR_WIDTH = 450
AVATAR_HEIGHT = 650

-- degrees to randians conversion
DEGREES_TO_RADIANS = 0.0174532925199432957

-- for png image that is facing EAST
ANGLES = {
    ['north'] = 270 * DEGREES_TO_RADIANS,
    ['north-east'] = 315 * DEGREES_TO_RADIANS,
    ['east'] = 360 * DEGREES_TO_RADIANS,
    ['south-east'] = 45 * DEGREES_TO_RADIANS,
    ['south'] = 90 * DEGREES_TO_RADIANS,
    ['south-west'] = 135 * DEGREES_TO_RADIANS,
    ['west'] = 180 * DEGREES_TO_RADIANS,
    ['north-west'] = 225 * DEGREES_TO_RADIANS
}

-- wall offset scalled to x5
WALL_OFFSET = 16 * 5

-- IDs for each door sprite based on colour
DOOR_IDS = {
    ['under'] = 1,
    ['purple'] = 2,
    ['blue'] = 3,
    ['red'] = 4,
    ['green'] = 5,
}