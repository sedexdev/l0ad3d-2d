GEntityDefintions = {
    ['player'] = {
        health = 100,
        ammo = 5000,
        powerups = {},
        movementSpeed = 600,
        [1] = {
            quads = GQuads['player1-walking'],
            ['walking-up'] = {
                animations = {
                    frames = {9, 10, 11, 12},
                    interval = 0.4
                },
            },
            ['walking-right'] = {
                animations = {
                    frames = {5, 6, 7, 8},
                    interval = 0.4
                },
            },
            ['walking-down'] = {
                animations = {
                    frames = {1, 2, 3, 4},
                    interval = 0.4
                },
            },
            ['walking-left'] = {
                animations = {
                    frames = {13, 14, 15, 16},
                    interval = 0.4
                },
            }
        },
        [2] = {
            walkingQuads = GQuads['player1-walking'],
            ['walking-up'] = {
                animations = {
                    frames = {9, 10, 11, 12},
                    interval = 0.4
                },
            },
            ['walking-right'] = {
                animations = {
                    frames = {5, 6, 7, 8},
                    interval = 0.4
                },
            },
            ['walking-down'] = {
                animations = {
                    frames = {1, 2, 3, 4},
                    interval = 0.4
                },
            },
            ['walking-left'] = {
                animations = {
                    frames = {13, 14, 15, 16},
                    interval = 0.4
                },
            }
        }
    },
    ['enemies'] = {
        ['grunt'] = {
            quads = nil,
            animations = {},
            health = 50,
            movementSpeed = 500,
            powerUpChance = 20
        },
        ['boss'] = {
            quads = nil,
            animations = {},
            health = 500,
            movementSpeed = 300,
            specialAttackFrequency = 5
        }
    },
    ['turret'] = {
        quads = nil,
        animations = {},
        health = 100,
        fireRate = 2,
        rotateFrequency = 4
    }
}