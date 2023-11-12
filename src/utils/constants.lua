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

-- map components scaled to x5
WALL_OFFSET = 16 * 5
FLOOR_TILE_WIDTH = 64 * 5
FLOOR_TILE_HEIGHT = 32 * 5
H_DOOR_WIDTH = 32 * 5
H_DOOR_HEIGHT = 16 * 5
V_DOOR_WIDTH = 16 * 5
V_DOOR_HEIGHT = 32 * 5

-- correction for Player object to fit through doorways
PLAYER_CORRECTION = 120
DOOR_PROXIMITY = 250

-- IDs for each door sprite based on colour
DOOR_IDS = {
    ['under'] = 1,
    ['purple'] = 2,
    ['blue'] = 3,
    ['red'] = 4,
    ['green'] = 5,
}

-- IDs for the Doors objects in each area
AREA_DOOR_IDS = {
    [1] = 'L',
    [2] = 'T',
    [3] = 'R',
    [4] = 'B',
}

-- powerup object IDs - includs crates and keys
POWERUP_IDS = {
    ['doubleSpeed'] = 1,
    ['health'] = 2,
    ['ammo'] = 3,
    ['invincible'] = 4,
    ['oneShotBossKill'] = 5,
}

-- powerup width and height
CRATE_WIDTH = 128 * 2.5
CRATE_HEIGHT = 128 * 2.5
POWERUP_WIDTH = 64 * 2.5
POWERUP_HEIGHT = 64 * 2.5
KEY_WIDTH = 64 * 2.5
KEY_HEIGHT = 64 * 2.5