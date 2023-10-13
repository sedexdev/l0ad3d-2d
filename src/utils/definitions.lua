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
        texture = nil,
        animations = {
            frames = nil,
            interval = nil
        }
    },
    ['boss'] = {
        texture = nil,
        fireShot = nil,
        animations = {
            frames = nil,
            interval = nil
        }
    },
    ['turret'] = {
        texture = nil,
        fireShot = nil,
        animations = {
            frames = nil,
            intervals = nil
        }
    }
}

GGruntDefinition = {
    x = nil,
    y = nil,
    width = nil,
    height = nil,
    direction = nil,
    lastDirection = nil,
    stateMachine = nil,
    health = 50,
    movementSpeed = 500,
    powerUpChance = 20
}

GBossDefinition = {
    x = nil,
    y = nil,
    width = nil,
    height = nil,
    direction = nil,
    lastDirection = nil,
    stateMachine = nil,
    health = 500,
    movementSpeed = 300,
    specialAttackFrequency = 5
}

GTurretDefinition = {
    x = nil,
    y = nil,
    width = nil,
    height = nil,
    direction = nil,
    lastDirection = nil,
    stateMachine = nil,
    health = 200,
    fireRate = 2,
    rotateFrequency = 4
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

GMapAreaDefinitions = {
    [1] = {x = -3200, y = -1600, width = 20, height = 20, corridors = {1, 8, 6}, adjacentAreas = nil},
    [2] = {x = -9920, y = -1200, width = 16, height = 16, corridors = {1, 2, 3, 5}, adjacentAreas = nil},
    -- [3] = {x = nil, y = nil, width = 8, height = 8, corridors = {6}, adjacentAreas = nil},
    -- [4] = {x = nil, y = nil, width = 8, height = 8, corridors = {7}, adjacentAreas = nil},
    -- [5] = {x = nil, y = nil, width = 8, height = 8, corridors = {8, 9, 10}, adjacentAreas = nil},
    -- [6] = {x = nil, y = nil, width = 8, height = 8, corridors = {3}, adjacentAreas = nil},
    -- [7] = {x = nil, y = nil, width = 16, height = 8, corridors = {5}, adjacentAreas = nil},
    -- [8] = {x = nil, y = nil, width = 8, height = 16, corridors = {2, 4}, adjacentAreas = {9, 10}},
    -- [9] = {x = nil, y = nil, width = 6, height = 6, corridors = nil, adjacentAreas = {8}},
    -- [10] = {x = nil, y = nil, width = 8, height = 8, corridors = nil, adjacentAreas = {8}},
    -- [11] = {x = nil, y = nil, width = 26, height = 22, corridors = {4}, adjacentAreas = {12, 13}},
    -- [12] = {x = nil, y = nil, width = 8, height = 8, corridors = nil, adjacentAreas = {11}},
    -- [13] = {x = nil, y = nil, width = 8, height = 8, corridors = nil, adjacentAreas = {11}},
    -- [14] = {x = nil, y = nil, width = 4, height = 4, corridors = {9}, adjacentAreas = nil},
    -- [15] = {x = nil, y = nil, width = 20, height = 22, corridors = {11, 13}, adjacentAreas = {16}},
    -- [16] = {x = nil, y = nil, width = 8, height = 8, corridors = nil, adjacentAreas = {15}},
    -- [17] = {x = nil, y = nil, width = 16, height = 12, corridors = {12, 15}, adjacentAreas = nil},
    -- [18] = {x = nil, y = nil, width = 20, height = 20, corridors = {14}, adjacentAreas = {19}},
    -- [19] = {x = nil, y = nil, width = 8, height = 8, corridors = nil, adjacentAreas = {18}},
    -- [20] = {x = nil, y = nil, width = 24, height = 24, corridors = {16}, adjacentAreas = {21}},
    -- [21] = {x = nil, y = nil, width = 8, height = 8, corridors = nil, adjacentAreas = {20}}
}

GMapCorridorDefinitions = {
    -- bend: string - corner description (e.g LBC = left-bottom-corner, RTC = right-top-corner)
    -- junction: integer - tile reference for collision detection
    [1] = {x = -4800, y = 0, width = 5, height = 2, direction = 'horizontal', bend = nil, junction = nil, doorIDs = {left = 'purple', right = 'purple'}},
    [2] = {x = -13120, y = 0, width = 10, height = 2, direction = 'horizontal', bend = nil, junction = nil, doorIDs = {left = 'purple', right = 'purple'}},
    [3] = {x = 4000, y = 0, width = 1, height = 5, direction = 'vertical', bend = nil, junction = nil, doorIDs = {top = 'purple', bottom = 'purple'}},
    -- [4] = {x = nil, y = nil, width = 1, height = 8, direction = 'vertical', bend = nil, junction = nil, doorIDs = {top = 'purple', bottom = 'red'}},
    -- [5] = {x = nil, y = nil, width = 1, height = 5, direction = 'vertical', bend = nil, junction = nil, doorIDs = {top = 'purple', bottom = 'purple'}},
    -- [6] = {x = nil, y = nil, width = 1, height = 12, direction = 'vertical', bend = nil, junction = nil, doorIDs = {top = 'purple', bottom = 'purple'}},
    -- [7] = {x = nil, y = nil, width = 5, height = 2, direction = 'horizontal', bend = nil, junction = nil, doorIDs = {left = 'purple', right = 'purple'}},
    -- [8] = {x = nil, y = nil, width = 5, height = 2, direction = 'horizontal', bend = nil, junction = nil, doorIDs = {left = 'purple', right = 'purple'}},
    -- [9] = {x = nil, y = nil, width = 1, height = 5, direction = 'vertical', bend = nil, junction = nil, doorIDs = {top = 'purple', bottom = 'purple'}},
    -- [10] = {x = nil, y = nil, width = 16, height = 2, direction = 'horizontal', bend = nil, junction = nil, doorIDs = {left = 'purple'}},
    -- [11] = {x = nil, y = nil, width = 1, height = 4, direction = 'vertical', bend = nil, junction = nil, doorIDs = {top = 'purple', bottom = 'purple'}},
    -- [12] = {x = nil, y = nil, width = 1, height = 8, direction = 'vertical', bend = nil, junction = nil, doorIDs = {top = 'purple', bottom = 'purple'}},
    -- [13] = {x = nil, y = nil, width = 1, height = 12, direction = 'vertical', bend = nil, junction = nil, doorIDs = {top = 'purple'}},
    -- [14] = {x = nil, y = nil, width = 12, height = 2, direction = 'horizontal', bend = nil, junction = nil, doorIDs = {right = 'purple'}},
    -- [15] = {x = nil, y = nil, width = 12, height = 2, direction = 'horizontal', bend = nil, junction = nil, doorIDs = {left = 'purple'}},
    -- [16] = {x = nil, y = nil, width = 2, height = 5, direction = 'horizontal', bend = nil, junction = nil, doorIDs = {bottom = 'green'}}
}
