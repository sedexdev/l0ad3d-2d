--[[
    Creates a table of animations for each Entity object by
    instantiating the Animation class with the relevant sprite
    sheet and indices for the animation state of the Entity 
]]
GAnimationDefintions = {
    ['character1'] = {
        texture    = GTextures['character1'],
        fireShot   = GTextures['gun-flash'],
        animations = {
            ['walking-north']      = Animation({1, 9}, CHARACTER_WALK_INTERVAL),
            ['walking-east']       = Animation({3, 11}, CHARACTER_WALK_INTERVAL),
            ['walking-south']      = Animation({5, 13}, CHARACTER_WALK_INTERVAL),
            ['walking-west']       = Animation({7, 15}, CHARACTER_WALK_INTERVAL),
            ['walking-north-east'] = Animation({2, 10}, CHARACTER_WALK_INTERVAL),
            ['walking-south-east'] = Animation({4, 12}, CHARACTER_WALK_INTERVAL),
            ['walking-south-west'] = Animation({6, 14}, CHARACTER_WALK_INTERVAL),
            ['walking-north-west'] = Animation({8, 16}, CHARACTER_WALK_INTERVAL),
            ['idle-north']         = Animation({17}, CHARACTER_WALK_INTERVAL),
            ['idle-east']          = Animation({19}, CHARACTER_WALK_INTERVAL),
            ['idle-south']         = Animation({21}, CHARACTER_WALK_INTERVAL),
            ['idle-west']          = Animation({23}, CHARACTER_WALK_INTERVAL),
            ['idle-north-east']    = Animation({18}, CHARACTER_WALK_INTERVAL),
            ['idle-south-east']    = Animation({20}, CHARACTER_WALK_INTERVAL),
            ['idle-south-west']    = Animation({22}, CHARACTER_WALK_INTERVAL),
            ['idle-north-west']    = Animation({24}, CHARACTER_WALK_INTERVAL)
        },
    },
    ['character2'] = {
        texture    = GTextures['character2'],
        fireShot   = GTextures['gun-flash'],
        animations = {
            ['walking-north']      = Animation({1, 9}, CHARACTER_WALK_INTERVAL),
            ['walking-east']       = Animation({3, 11}, CHARACTER_WALK_INTERVAL),
            ['walking-south']      = Animation({5, 13}, CHARACTER_WALK_INTERVAL),
            ['walking-west']       = Animation({7, 15}, CHARACTER_WALK_INTERVAL),
            ['walking-north-east'] = Animation({2, 10}, CHARACTER_WALK_INTERVAL),
            ['walking-south-east'] = Animation({4, 12}, CHARACTER_WALK_INTERVAL),
            ['walking-south-west'] = Animation({6, 14}, CHARACTER_WALK_INTERVAL),
            ['walking-north-west'] = Animation({8, 16}, CHARACTER_WALK_INTERVAL),
            ['idle-north']         = Animation({17}, CHARACTER_WALK_INTERVAL),
            ['idle-east']          = Animation({19}, CHARACTER_WALK_INTERVAL),
            ['idle-south']         = Animation({21}, CHARACTER_WALK_INTERVAL),
            ['idle-west']          = Animation({23}, CHARACTER_WALK_INTERVAL),
            ['idle-north-east']    = Animation({18}, CHARACTER_WALK_INTERVAL),
            ['idle-south-east']    = Animation({20}, CHARACTER_WALK_INTERVAL),
            ['idle-south-west']    = Animation({22}, CHARACTER_WALK_INTERVAL),
            ['idle-north-west']    = Animation({24}, CHARACTER_WALK_INTERVAL)
        }
    },
    ['grunt'] = {
        texture    = GTextures['grunt'],
        animations = {
            ['walking-north']        = Animation({1, 9}, GRUNT_WALK_INTERVAL),
            ['walking-east']         = Animation({3, 11}, GRUNT_WALK_INTERVAL),
            ['walking-south']        = Animation({5, 13}, GRUNT_WALK_INTERVAL),
            ['walking-west']         = Animation({7, 15}, GRUNT_WALK_INTERVAL),
            ['walking-north-east']   = Animation({2, 10}, GRUNT_WALK_INTERVAL),
            ['walking-south-east']   = Animation({4, 12}, GRUNT_WALK_INTERVAL),
            ['walking-south-west']   = Animation({6, 14}, GRUNT_WALK_INTERVAL),
            ['walking-north-west']   = Animation({8, 16}, GRUNT_WALK_INTERVAL),
            ['attacking-north']      = Animation({17, 25}, GRUNT_ATTACK_INTERVAL),
            ['attacking-east']       = Animation({19, 27}, GRUNT_ATTACK_INTERVAL),
            ['attacking-south']      = Animation({21, 28}, GRUNT_ATTACK_INTERVAL),
            ['attacking-west']       = Animation({23, 31}, GRUNT_ATTACK_INTERVAL),
            ['attacking-north-east'] = Animation({18, 26}, GRUNT_ATTACK_INTERVAL),
            ['attacking-south-east'] = Animation({20, 28}, GRUNT_ATTACK_INTERVAL),
            ['attacking-south-west'] = Animation({22, 30}, GRUNT_ATTACK_INTERVAL),
            ['attacking-north-west'] = Animation({24, 32}, GRUNT_ATTACK_INTERVAL)
        }
    },
    ['boss'] = {
        texture    = GTextures['boss'],
        fireShot   = GTextures['boss-gun-flash'],
        animations = {
            ['walking-north']      = Animation({1, 9}, BOSS_WALK_INTERVAL),
            ['walking-east']       = Animation({3, 11}, BOSS_WALK_INTERVAL),
            ['walking-south']      = Animation({5, 13}, BOSS_WALK_INTERVAL),
            ['walking-west']       = Animation({7, 15}, BOSS_WALK_INTERVAL),
            ['walking-north-east'] = Animation({2, 10}, BOSS_WALK_INTERVAL),
            ['walking-south-east'] = Animation({4, 12}, BOSS_WALK_INTERVAL),
            ['walking-south-west'] = Animation({6, 14}, BOSS_WALK_INTERVAL),
            ['walking-north-west'] = Animation({8, 16}, BOSS_WALK_INTERVAL),
        }
    },
    ['turret'] = {
        texture  = GTextures['turret'],
        fireShot = GTextures['boss-gun-flash'],
    }
}

--[[
    Character attributes definition
]]
GCharacterDefinition = {
    type          = 'character',
    x             = (WINDOW_WIDTH / 2) - (ENTITY_WIDTH / 2),
    y             = (WINDOW_HEIGHT / 2) - (ENTITY_HEIGHT / 2),
    dx            = CHARACTER_SPEED,
    dy            = CHARACTER_SPEED,
    width         = ENTITY_WIDTH,
    height        = ENTITY_HEIGHT,
    stateMachine  = nil,
    health        = MAX_HEALTH,
    ammo          = MAX_AMMO,
    shotFired     = false,
    direction     = 'north',
    lastDirection = 'north',
    invulnerable  = false,
    lives         = 3,
    powerups      = {
        invincible      = false,
        doubleSpeed     = false,
        oneShotBossKill = false
    },
    keys = {
        red   = false,
        blue  = false,
        green = false
    },
    ['character1'] = {
        weapons       = 2,
        currentWeapon = 'right'
    },
    ['character2'] = {
        weapons       = 1,
        currentWeapon = 'right'
    }
}

--[[
    Grunt attributes definition
]]
GGruntDefinition = {
    type          = 'grunt',
    x             = nil,
    y             = nil,
    dx            = GRUNT_SPEED,
    dy            = GRUNT_SPEED,
    width         = ENTITY_WIDTH,
    height        = ENTITY_HEIGHT,
    areaID        = nil,
    stateMachine  = nil,
    direction     = nil,
    health        = 50,
    powerUpChance = 20,
    damage        = 5
}

--[[
    Boss attributes definition
]]
GBossDefinition = {
    type          = 'boss',
    x             = -14592,
    y             = 4128,
    dx            = BOSS_SPEED,
    dy            = BOSS_SPEED,
    width         = ENTITY_WIDTH,
    height        = ENTITY_HEIGHT,
    areaID        = 27,
    stateMachine  = nil,
    direction     = nil,
    health        = 1000,
    weapons       = 1,
    currentWeapon = 'right',
    damage        = 10
}

--[[
    Turret attributes definition
]]
GTurretDefinition = {
    type         = 'turret',
    x            = nil,
    y            = nil,
    dx           = nil,
    dy           = nil,
    width        = TURRET_WIDTH,
    height       = TURRET_HEIGHT,
    areaID       = nil,
    direction    = nil,
    stateMachine = nil,
    health       = 200,
    damage       = 15
}

--[[
    Defines the parameters of each MapArea object that is combined to 
    create the game Map. The game is comprised of 2 core Map elements;
    an area, and joining areas between areas (corridors). These both
    take different values for initialisation so not all value are defined
    on each element in this table. MapArea attributes include:

    x:                       number - x coordinate in px (set to nil for corridors)
    y:                       number - y coordinate in px (set to nil for corridors)
    width:                   number - width in tiles
    height:                  number - height in tiles
    type:                    string - area | corridor
    (corridor) direction:    string - which orientation is it using (used to place walls correctly)
    (corridor) bends:        table  - corner descriptions (e.g LB = left-bottom, RT = right-top)
    (corridor) joins:        table  - area index and location to base corridor (x, y) off of
    (area | corridor) doors: table  - lists the locations and colours of doors in the area
    (area) adjacentAreas:    table  - contains area IDs for collision detection
    turrets:                 number - the number of turret Entity objects in the area
    key:                     string - the colour of a key found in this area
]]
GMapAreaDefinitions = {
    --========== JOINING AREAS ==========
    [1]  = {x = nil, y = nil, width = 5,  height = 2,  type = 'corridor', orientation = 'horizontal', joins = {{17, 'L'}, {18, 'R'}}},
    [2]  = {x = nil, y = nil, width = 10, height = 2,  type = 'corridor', orientation = 'horizontal', joins = {{18, 'L'}, {24, 'R'}}},
    [3]  = {x = nil, y = nil, width = 1,  height = 5,  type = 'corridor', orientation = 'vertical',   joins = {{18, 'T'}, {22, 'B'}}},
    [4]  = {x = nil, y = nil, width = 1,  height = 8,  type = 'corridor', orientation = 'vertical',   joins = {{24, 'B'}, {27, 'T'}}},
    [5]  = {x = nil, y = nil, width = 1,  height = 5,  type = 'corridor', orientation = 'vertical',   joins = {{18, 'B'}, {23, 'T'}}},
    [6]  = {x = nil, y = nil, width = 1,  height = 12, type = 'corridor', orientation = 'vertical',   doors = {R = 'purple'}, joins = {{17, 'B'}, {19, 'T'}}},
    [7]  = {x = nil, y = nil, width = 5,  height = 2,  type = 'corridor', orientation = 'horizontal', joins = {{20, 'L'}, {6, 'R'}}},
    [8]  = {x = nil, y = nil, width = 5,  height = 2,  type = 'corridor', orientation = 'horizontal', joins = {{17, 'R'}, {21, 'L'}}},
    [9]  = {x = nil, y = nil, width = 1,  height = 5,  type = 'corridor', orientation = 'vertical',   joins = {{21, 'T'}, {30, 'B'}}},
    [10] = {x = nil, y = nil, width = 16, height = 2,  type = 'corridor', orientation = 'horizontal', bends = {'RT'}, doors = {B = 'purple'}, joins = {{21, 'R'}}},
    [11] = {x = nil, y = nil, width = 1,  height = 5,  type = 'corridor', orientation = 'vertical',   joins = {{31, 'T'}, {10, 'B'}}},
    [12] = {x = nil, y = nil, width = 1,  height = 5,  type = 'corridor', orientation = 'vertical',   bends = {'LB'}, joins = {{33, 'B'}}},
    [13] = {x = nil, y = nil, width = 12, height = 2,  type = 'corridor', orientation = 'horizontal', bends = {'LT'}, joins = {{34, 'L'}}},
    [14] = {x = nil, y = nil, width = 1,  height = 12, type = 'corridor', orientation = 'vertical',   bends = {'RB'}, joins = {{31, 'B'}}},
    [15] = {x = nil, y = nil, width = 18, height = 2,  type = 'corridor', orientation = 'horizontal', bends = {'RB'}, joins = {{33, 'R'}}},
    [16] = {x = nil, y = nil, width = 1,  height = 10, type = 'corridor', orientation = 'vertical',   bends = {'LT'}, joins = {{36, 'T'}}},
    -- ========== MAIN AREAS ========== 
    [17] = {x = -3200,  y = -1600, width = 20, height = 20, type = 'area', doors = {L = 'purple', B = 'purple', R = 'purple'}},
    [18] = {x = -9920,  y = -1280, width = 16, height = 16, type = 'area', doors = {L = 'purple', B = 'purple', R = 'purple', T = 'purple'}},
    [19] = {x = -1280,  y = 3520,  width = 8,  height = 8,  type = 'area', doors = {T = 'purple'}},
    [20] = {x = 1840,   y = 1920,  width = 8,  height = 8,  type = 'area', doors = {L = 'purple'}},
    [21] = {x = 4800,   y = -640,  width = 8,  height = 8,  type = 'area', doors = {L = 'purple', R = 'purple', T = 'purple'}},
    [22] = {x = -8640,  y = -3360, width = 8,  height = 8,  type = 'area', doors = {B = 'purple'}},
    [23] = {x = -9920,  y = 2080,  width = 16, height = 8,  type = 'area', doors = {T = 'purple'}},
    [24] = {x = -15680, y = -1280, width = 8,  height = 16, type = 'area', adjacentAreas = {[1] = {areaID = 25, doorID = 4}, [2] = {areaID = 26, doorID = 3}}, doors = {B = 'purple', R = 'purple'}, turrets = 2},
    [25] = {x = -15680, y = -2640, width = 8,  height = 8,  type = 'area', doors = {B = 'purple'}, key = 'green'},
    [26] = {x = -18320, y = -640,  width = 8,  height = 8,  type = 'area', doors = {R = 'blue'}},
    [27] = {x = -18560, y = 2560,  width = 26, height = 22, type = 'area', adjacentAreas = {[1] = {areaID = 28, doorID = 2}, [2] = {areaID = 29, doorID = 2}}, doors = {T = 'red'}, turrets = 4},
    [28] = {x = -18240, y = 6160,  width = 8,  height = 8,  type = 'area', doors = {T = 'purple'}},
    [29] = {x = -14400, y = 6160,  width = 8,  height = 8,  type = 'area', doors = {T = 'purple'}},
    [30] = {x = 5440,   y = -2080, width = 4,  height = 4,  type = 'area', doors = {B = 'purple'}},
    [31] = {x = 6720,   y = 1040,  width = 20, height = 22, type = 'area', adjacentAreas = {[1] = {areaID = 32, doorID = 1}}, doors = {B = 'purple', T = 'purple'}, turrets = 2},
    [32] = {x = 13200,  y = 2080,  width = 6,  height = 8,  type = 'area', doors = {L = 'purple'}},
    [33] = {x = 9680,   y = -2560, width = 16, height = 12, type = 'area', doors = {B = 'purple', R = 'purple'}},
    [34] = {x = 13520,  y = 4720,  width = 20, height = 20, type = 'area', adjacentAreas = {[1] = {areaID = 35, doorID = 2}}, doors = {L = 'purple'}, turrets = 2},
    [35] = {x = 15360,  y = 8000,  width = 8,  height = 8,  type = 'area', doors = {T = 'purple'}, key = 'blue'},
    [36] = {x = 16480,  y = -160,  width = 24, height = 24, type = 'area', adjacentAreas = {[1] = {areaID = 37, doorID = 2}}, doors = {T = 'green'}, turrets = 4},
    [37] = {x = 19680,  y = 3760,  width = 4,  height = 4,  type = 'area', doors = {T = 'purple'}, key = 'red'},
}

-- (x, y) coordinates for each key
GKeyDefinitions = {
    [1] = {areaID = 37, x = 20700,  y = 4140},  -- red
    [2] = {areaID = 35, x = 15460,  y = 9038},  -- blue
    [3] = {areaID = 25, x = -15580, y = -2560}  -- green
}

--[[
    adjacency matrix used for reducing calls to the Grunt update(dt)
    function within EnemySystem:update(dt). Only Grunts in the current
    and nearby areas are updated to avoid render issues from mass updates
]]
GAreaAdjacencyDefinitions = {
    [17] = {18, 19, 20, 21},
    [18] = {17, 22, 23, 24, 25, 26},
    [19] = {17, 20},
    [20] = {17, 19},
    [21] = {17, 30, 31, 32, 33},
    [22] = {18},
    [23] = {18},
    [24] = {18, 27, 28, 29},
    [25] = {18, 27},
    [26] = {18, 27},
    [27] = {24, 25, 26},
    [28] = {24, 25, 26},
    [29] = {24, 25, 26},
    [30] = {21},
    [31] = {21, 33, 35},
    [32] = {21, 33, 34},
    [33] = {21, 36, 37},
    [34] = {31, 32, 37},
    [35] = {31, 32, 37},
    [36] = {33},
    [37] = {33, 34},
}
