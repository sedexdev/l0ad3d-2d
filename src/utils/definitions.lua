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
        texture = GTextures['grunt'],
        animations = {
            ['walking-north'] = Animation({1, 9}, GRUNT_WALK_INTERVAL),
            ['walking-east'] = Animation({3, 11}, GRUNT_WALK_INTERVAL),
            ['walking-south'] = Animation({5, 13}, GRUNT_WALK_INTERVAL),
            ['walking-west'] = Animation({7, 15}, GRUNT_WALK_INTERVAL),
            ['walking-north-east'] = Animation({2, 10}, GRUNT_WALK_INTERVAL),
            ['walking-south-east'] = Animation({4, 12}, GRUNT_WALK_INTERVAL),
            ['walking-south-west'] = Animation({6, 14}, GRUNT_WALK_INTERVAL),
            ['walking-north-west'] = Animation({8, 16}, GRUNT_WALK_INTERVAL),
            ['attacking-north'] = Animation({17, 25}, GRUNT_ATTACK_INTERVAL),
            ['attacking-east'] = Animation({19, 27}, GRUNT_ATTACK_INTERVAL),
            ['attacking-south'] = Animation({21, 28}, GRUNT_ATTACK_INTERVAL),
            ['attacking-west'] = Animation({23, 31}, GRUNT_ATTACK_INTERVAL),
            ['attacking-north-east'] = Animation({18, 26}, GRUNT_ATTACK_INTERVAL),
            ['attacking-south-east'] = Animation({20, 28}, GRUNT_ATTACK_INTERVAL),
            ['attacking-south-west'] = Animation({22, 30}, GRUNT_ATTACK_INTERVAL),
            ['attacking-north-west'] = Animation({24, 32}, GRUNT_ATTACK_INTERVAL)
        }
    },
    ['boss'] = {
        texture = GTextures['boss'],
        fireShot = GTextures['boss-gun-flash'],
        animations = {
            ['walking-north'] = Animation({1, 9}, BOSS_WALK_INTERVAL),
            ['walking-east'] = Animation({3, 11}, BOSS_WALK_INTERVAL),
            ['walking-south'] = Animation({5, 13}, BOSS_WALK_INTERVAL),
            ['walking-west'] = Animation({7, 15}, BOSS_WALK_INTERVAL),
            ['walking-north-east'] = Animation({2, 10}, BOSS_WALK_INTERVAL),
            ['walking-south-east'] = Animation({4, 12}, BOSS_WALK_INTERVAL),
            ['walking-south-west'] = Animation({6, 14}, BOSS_WALK_INTERVAL),
            ['walking-north-west'] = Animation({8, 16}, BOSS_WALK_INTERVAL),
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
    x = (WINDOW_WIDTH / 2) - (GRUNT_WIDTH / 2),
    y = (WINDOW_HEIGHT / 2) - (GRUNT_HEIGHT / 2),
    width = GRUNT_WIDTH,
    height = GRUNT_HEIGHT,
    stateMachine = nil,
    direction = 'north',
    health = 50,
    speed = 250,
    powerUpChance = 20
}

GBossDefinition = {
    x = (WINDOW_WIDTH / 2) - (BOSS_WIDTH / 2),
    y = (WINDOW_HEIGHT / 2) - (BOSS_HEIGHT / 2),
    width = BOSS_WIDTH,
    height = BOSS_HEIGHT,
    stateMachine = nil,
    direction = 'north',
    health = 1000,
    speed = 400
}

GTurretDefinition = {
    x = nil,
    y = nil,
    width = nil,
    height = nil,
    direction = nil,
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
    stateMachine = nil,
    health = 100,
    ammo = 5000,
    shotFired = false,
    direction = 'north',
    lastDirection = 'north',
    speed = 1200,
    powerups = {
        invicible = false,
        doubleSpeed = false,
        oneShotBossKill = false
    },
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
    -- corridor locations [2]: string - which edge of the area to place the corridor against 
    -- (L = left, R = right, T = top, B = bottom)
    -- same with adjacent areas but the contain a door colour as well
    [1] = {x = -3200, y = -1600, width = 20, height = 20, corridors = {{1, 'L'}, {6, 'B'}, {8, 'R'}}, adjacentArea = nil},
    [2] = {x = -9920, y = -1200, width = 16, height = 16, corridors = {{1, 'R'}, {2, 'L'}, {3, 'T'}, {5, 'B'}}, adjacentArea = nil},
    [3] = {x = -1280, y = 3520, width = 8, height = 8, corridors = {{6, 'T'}}, adjacentArea = nil},
    [4] = {x = 1760, y = 1920, width = 8, height = 8, corridors = {{7, 'L'}}, adjacentArea = nil},
    [5] = {x = 4800, y = -640, width = 8, height = 8, corridors = {{8, 'L'}, {9, 'T'}, {10, 'R'}}, adjacentArea = nil},
    [6] = {x = -8640, y = -3280, width = 8, height = 8, corridors = {{3, 'B'}}, adjacentArea = nil},
    [7] = {x = -9920, y = 2160, width = 16, height = 8, corridors = {{5, 'T'}}, adjacentArea = nil},
    [8] = {x = -15680, y = -1360, width = 8, height = 16, corridors = {{2, 'R'}, {4, 'B'}}, adjacentArea = nil},
    [9] = {x = -17680, y = -1200, width = 6, height = 6, corridors = nil, adjacentArea = {8, 'R', 'purple'}},
    [10] = {x = -18320, y = 80, width = 8, height = 8, corridors = nil, adjacentArea = {8, 'R', 'blue'}},
    [11] = {x = -18880, y = 2480, width = 26, height = 22, corridors = {{4, 'T'}}, adjacentArea = nil},
    [12] = {x = -18240, y = 6080, width = 8, height = 8, corridors = nil, adjacentArea = {11, 'T', 'purple'}},
    [13] = {x = -14400, y = 6080, width = 8, height = 8, corridors = nil, adjacentArea = {11, 'T', 'purple'}},
    [14] = {x = 5440, y = -2080, width = 4, height = 4, corridors = {{9, 'B'}}, adjacentArea = nil},
    [15] = {x = 7520, y = 960, width = 20, height = 22, corridors = {{11, 'T'}, {13, 'B'}}, adjacentArea = nil},
    [16] = {x = 14000, y = 2080, width = 6, height = 8, corridors = nil, adjacentArea = {15, 'L', 'purple'}},
    [17] = {x = 9680, y = -2560, width = 16, height = 12, corridors = {{12, 'B'}, {15, 'R'}}, adjacentArea = nil},
    [18] = {x = 14400, y = 4560, width = 20, height = 20, corridors = {{14, 'L'}}, adjacentArea = nil},
    [19] = {x = 16240, y = 7840, width = 8, height = 8, corridors = nil, adjacentArea = {18, 'T', 'purple'}},
    [20] = {x = 16480, y = -160, width = 24, height = 24, corridors = {{16, 'T'}}, adjacentArea = nil},
    [21] = {x = 21280, y = 3760, width = 8, height = 8, corridors = nil, adjacentArea = {20, 'T', 'purple'}}
}

GMapCorridorDefinitions = {
    -- bend: string - corner description (e.g LB = left-bottom, RB = right-bottom, LT = left-top, RT = right-top)
    -- junction: integer - tile reference for collision detection
    -- direction: string - which orientation is it using (used to place doors correctly)
    [1] = {width = 5, height = 2, direction = 'horizontal', bend = nil, junction = nil, doorIDs = {left = 'purple', right = 'purple'}},
    [2] = {width = 10, height = 2, direction = 'horizontal', bend = nil, junction = nil, doorIDs = {left = 'purple', right = 'purple'}},
    [3] = {width = 1, height = 5, direction = 'vertical', bend = nil, junction = nil, doorIDs = {top = 'purple', bottom = 'purple'}},
    [4] = {width = 1, height = 8, direction = 'vertical', bend = nil, junction = nil, doorIDs = {top = 'purple', bottom = 'red'}},
    [5] = {width = 1, height = 5, direction = 'vertical', bend = nil, junction = nil, doorIDs = {top = 'purple', bottom = 'purple'}},
    [6] = {width = 1, height = 12, direction = 'vertical', bend = nil, junction = nil, doorIDs = {top = 'purple', bottom = 'purple'}},
    [7] = {width = 5, height = 2, direction = 'horizontal', bend = nil, junction = nil, doorIDs = {left = 'purple', right = 'purple'}},
    [8] = {width = 5, height = 2, direction = 'horizontal', bend = nil, junction = nil, doorIDs = {left = 'purple', right = 'purple'}},
    [9] = {width = 1, height = 5, direction = 'vertical', bend = nil, junction = nil, doorIDs = {top = 'purple', bottom = 'purple'}},
    [10] = {width = 16, height = 2, direction = 'horizontal', bend = 'RT', junction = nil, doorIDs = {left = 'purple'}},
    [11] = {width = 1, height = 5, direction = 'vertical', bend = nil, junction = nil, doorIDs = {top = 'purple', bottom = 'purple'}},
    [12] = {width = 1, height = 5, direction = 'vertical', bend = 'LB', junction = nil, doorIDs = {top = 'purple'}},
    [13] = {width = 1, height = 12, direction = 'vertical', bend = 'RB', junction = nil, doorIDs = {top = 'purple'}},
    [14] = {width = 12, height = 2, direction = 'horizontal', bend = 'LT', junction = nil, doorIDs = {right = 'purple'}},
    [15] = {width = 18, height = 2, direction = 'horizontal', bend = 'RB', junction = nil, doorIDs = {left = 'purple'}},
    [16] = {width = 1, height = 10, direction = 'vertical', bend = 'LT', junction = nil, doorIDs = {bottom = 'green'}}
}
