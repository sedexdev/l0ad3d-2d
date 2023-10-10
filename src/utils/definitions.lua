GAnimationDefintions = {
    ['character1'] = {
        texture = GTextures['character1'],
        fireShot = GTextures['gun-flash'],
        animations = {
            ['walking-north'] = Animation({1, 9}, CHARACTER_WALK_INTERVAL),
            ['walking-east'] = Animation({3, 11}, CHARACTER_WALK_INTERVAL),
            ['walking-south'] = Animation({5, 13}, CHARACTER_WALK_INTERVAL),
            ['walking-west'] = Animation({7, 15}, CHARACTER_WALK_INTERVAL),
            ['walking-north-east'] = Animation({2, 10}, CHARACTER_WALK_INTERVAL),
            ['walking-south-east'] = Animation({4, 12}, CHARACTER_WALK_INTERVAL),
            ['walking-south-west'] = Animation({6, 14}, CHARACTER_WALK_INTERVAL),
            ['walking-north-west'] = Animation({8, 16}, CHARACTER_WALK_INTERVAL),
            ['idle-north'] = Animation({17}, CHARACTER_WALK_INTERVAL),
            ['idle-east'] = Animation({19}, CHARACTER_WALK_INTERVAL),
            ['idle-south'] = Animation({21}, CHARACTER_WALK_INTERVAL),
            ['idle-west'] = Animation({23}, CHARACTER_WALK_INTERVAL),
            ['idle-north-east'] = Animation({18}, CHARACTER_WALK_INTERVAL),
            ['idle-south-east'] = Animation({20}, CHARACTER_WALK_INTERVAL),
            ['idle-south-west'] = Animation({22}, CHARACTER_WALK_INTERVAL),
            ['idle-north-west'] = Animation({24}, CHARACTER_WALK_INTERVAL)
        },
    },
    ['character2'] = {
        texture = GTextures['character2'],
        fireShot = GTextures['gun-flash'],
        animations = {
            ['walking-north'] = Animation({1, 9}, CHARACTER_WALK_INTERVAL),
            ['walking-east'] = Animation({3, 11}, CHARACTER_WALK_INTERVAL),
            ['walking-south'] = Animation({5, 13}, CHARACTER_WALK_INTERVAL),
            ['walking-west'] = Animation({7, 15}, CHARACTER_WALK_INTERVAL),
            ['walking-north-east'] = Animation({2, 10}, CHARACTER_WALK_INTERVAL),
            ['walking-south-east'] = Animation({4, 12}, CHARACTER_WALK_INTERVAL),
            ['walking-south-west'] = Animation({6, 14}, CHARACTER_WALK_INTERVAL),
            ['walking-north-west'] = Animation({8, 16}, CHARACTER_WALK_INTERVAL),
            ['idle-north'] = Animation({17}, CHARACTER_WALK_INTERVAL),
            ['idle-east'] = Animation({19}, CHARACTER_WALK_INTERVAL),
            ['idle-south'] = Animation({21}, CHARACTER_WALK_INTERVAL),
            ['idle-west'] = Animation({23}, CHARACTER_WALK_INTERVAL),
            ['idle-north-east'] = Animation({18}, CHARACTER_WALK_INTERVAL),
            ['idle-south-east'] = Animation({20}, CHARACTER_WALK_INTERVAL),
            ['idle-south-west'] = Animation({22}, CHARACTER_WALK_INTERVAL),
            ['idle-north-west'] = Animation({24}, CHARACTER_WALK_INTERVAL)
        }
    },
    ['grunt'] = {
        quads = nil,
        animations = {
            frames = nil,
            interval = nil
        },
        health = 50,
        movementSpeed = 500,
        powerUpChance = 20
    },
    ['boss'] = {
        quads = nil,
        animations = {
            frames = nil,
            interval = nil
        },
        health = 500,
        movementSpeed = 300,
        specialAttackFrequency = 5
    },
    ['turret'] = {
        quads = nil,
        animations = {
            frames = nil,
            intervals = nil
        },
        health = 100,
        fireRate = 2,
        rotateFrequency = 4
    }
}

GCharacterDefinition = {
    x = (WINDOW_WIDTH / 2) - (CHARACTER_WIDTH / 2),
    y = (WINDOW_HEIGHT / 2) - (CHARACTER_HEIGHT / 2),
    width = CHARACTER_WIDTH,
    height = CHARACTER_HEIGHT,
    health = 100,
    ammo = 5000,
    shotFired = false,
    direction = 'north',
    lastDirection = 'north',
    speed = 1200,
    powerups = {
        invicible = false,
        infinite_ammo = false,
        one_shot_boss_kill = false
    },
    stateMachine = nil,
    ['character1'] = {
        weapons = 2,
        currentWeapon = 'right'
    },
    ['character2'] = {
        weapons = 1,
        currentWeapon = 'right'
    }
}
