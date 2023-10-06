-- globablly available constansts
WINDOW_WIDTH, WINDOW_HEIGHT = love.window.getDesktopDimensions()

-- character select
AVATAR_WIDTH = 450
AVATAR_HEIGHT = 650

-- character sprite dimensions
CHARACTER_WIDTH = 384
CHARACTER_HEIGHT = 384

-- keys
MOVEMENT_KEYS = {'up', 'right', 'down', 'left', 'w', 'd', 's', 'a'}

-- animations
CHARACTER_WALK_INTERVAL = 0.2
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
