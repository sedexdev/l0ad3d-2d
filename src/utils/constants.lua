-- globablly available constansts

--[[
    WINDOW DIMENSIONS
]]
WINDOW_WIDTH, WINDOW_HEIGHT = love.window.getDesktopDimensions()

--[[
    ENTITY CONSTANTS
]]
-- character sprite dimensions
ENTITY_WIDTH      = 384
ENTITY_HEIGHT     = 384
TURRET_WIDTH      = 256
TURRET_HEIGHT     = 256
PLAYER_STARTING_X = (WINDOW_WIDTH / 2) - (ENTITY_WIDTH / 2)
PLAYER_STARTING_Y = (WINDOW_HEIGHT / 2) - (ENTITY_HEIGHT / 2)

-- animations
CHARACTER_WALK_INTERVAL = 0.2
GRUNT_WALK_INTERVAL     = 2
GRUNT_ATTACK_INTERVAL   = 0.1
BOSS_WALK_INTERVAL      = 0.1
EXPLOSION_INTERVAL      = 0.1
SMOKE_INTERVAL          = 0.1
SMOKE_OFFSET            = 100

-- entity data
CHARACTER_SPEED        = 1200
GRUNT_SPEED            = 250
BOSS_SPEED             = 500
MAX_HEALTH             = 100
MAX_AMMO               = 5000
ENTITY_PROXIMITY       = 100
GRUNT_ATTACK_PROXIMITY = 100
ENTITY_AXIS_PROXIMITY  = 10
BOSS_PROXIMITY         = 600
BOSS_VELOCITY_CHANGE   = 5
TURRET_OFFSET          = 120
START_AREA_ID          = 17
STARING_COORDINATES    = {
    -- based off src/utils/definitions.lua:GMapAreaDefinitions definitions
    [1] = {x = -3200 + (20 * (64 * 5)) / 2, y = -1600 + (20 * (32 * 5)) / 2},
    [2] = {x = -9920 + (16 * (64 * 5)) / 2, y = -1280 + (16 * (32 * 5)) / 2},
    [3] = {x = 9680 + (16 * (64 * 5)) / 2,  y = -2560 + (12 * (32 * 5)) / 2},
}
STARTING_AREAS         = {17, 18, 33}
-- Boss is spawned when PLayer enters area 4
BOSS_SPAWN_AREA_ID     = 4
-- Boss is spawned in area 27
BOSS_AREA_ID           = 27
INVULNERABLE_DURATION  = 2
INVINCIBLE_DURATION    = 30
X2_SPEED_DURATION      = 15

-- bullets
PLAYER_DAMAGE      = 25
BULLET_SPEED       = 2500
ENEMY_BULLET_SPEED = 600
BULLET_WIDTH       = 100
BULLET_HEIGHT      = 100
ENEMY_SHOT_PX      = 360

-- movement key bindings
MOVEMENT_KEYS = {'up', 'right', 'down', 'left', 'w', 'd', 's', 'a'}

--[[
    GAME RENDERING CONSTANTS
]]
-- character select state
AVATAR_WIDTH  = 450
AVATAR_HEIGHT = 650

-- degrees to randians conversion
DEGREES_TO_RADIANS = 0.0174532925199432957

-- for png image that is facing EAST
ANGLES = {
    ['north']      = 270 * DEGREES_TO_RADIANS,
    ['north-east'] = 315 * DEGREES_TO_RADIANS,
    ['east']       = 360 * DEGREES_TO_RADIANS,
    ['south-east'] = 45 * DEGREES_TO_RADIANS,
    ['south']      = 90 * DEGREES_TO_RADIANS,
    ['south-west'] = 135 * DEGREES_TO_RADIANS,
    ['west']       = 180 * DEGREES_TO_RADIANS,
    ['north-west'] = 225 * DEGREES_TO_RADIANS
}

-- inline with direction of Entity object
ENTITY_ANGLES = {
    ['north']      = 360 * DEGREES_TO_RADIANS,
    ['north-east'] = 45 * DEGREES_TO_RADIANS,
    ['east']       = 90 * DEGREES_TO_RADIANS,
    ['south-east'] = 135 * DEGREES_TO_RADIANS,
    ['south']      = 180 * DEGREES_TO_RADIANS,
    ['south-west'] = 225 * DEGREES_TO_RADIANS,
    ['west']       = 270 * DEGREES_TO_RADIANS,
    ['north-west'] = 315 * DEGREES_TO_RADIANS,
}

-- directions
DIRECTIONS = {'north', 'north-east', 'east', 'south-east', 'south', 'south-west', 'west', 'north-west'}

-- map components scaled to x5
WALL_OFFSET       = 16 * 5
FLOOR_TILE_WIDTH  = 64 * 5
FLOOR_TILE_HEIGHT = 32 * 5
H_DOOR_WIDTH      = 32 * 5
H_DOOR_HEIGHT     = 16 * 5
V_DOOR_WIDTH      = 16 * 5
V_DOOR_HEIGHT     = 32 * 5

-- correction for Player object to fit through doorways
ENTITY_CORRECTION = 120
DOOR_PROXIMITY    = 250

-- IDs for each door sprite based on colour
DOOR_IDS = {
    ['under']  = 1,
    ['purple'] = 2,
    ['blue']   = 3,
    ['red']    = 4,
    ['green']  = 5,
}

-- IDs for the Doors objects in each area
AREA_DOOR_IDS = {
    [1] = 'L',
    [2] = 'T',
    [3] = 'R',
    [4] = 'B',
}

-- powerup width and height
CRATE_WIDTH    = 85 * 2.7
CRATE_HEIGHT   = 85 * 2.7
POWERUP_WIDTH  = 64 * 2.5
POWERUP_HEIGHT = 64 * 2.5
KEY_WIDTH      = 64 * 2.5
KEY_HEIGHT     = 64 * 2.5

-- area ID for invincibility powerup
INVINCIBLE_AREA = 26

-- correction for Player to collide with crates
CRATE_CORRECTION = 160

-- remove blood stain interval
BLOOD_STAIN_INTERVAL = 180

-- set offset to centre explosions
EXPLOSION_OFFSET = 50

-- minimap scale
MINIMAP_SCALE = 0.03