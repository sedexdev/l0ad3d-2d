--[[
    EnemySystem: class

    Description:
        An enemy system is responsible for spawning and removing
        enemy (Entity) objects from the Map. As enemies are killed
        they are replaced with blood splatter effects which fade
        over time, and enemies are replaced as the Player moves around
        the Map
]]

EnemySystem = Class{}

--[[
    EnemySystem constructor. Creates a store for the doors in the
    system, tracks locked doors, and knows which door the Player
    is currently interacting with 

    Params:
        player: table - Player object
    Returns:
        nil
]]
function EnemySystem:init(player)
    self.player = player
    self.grunts = {}
    self.turrets = {}
    self.boss = nil
end

--[[
    EnemySystem update function. 

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function EnemySystem:update(dt)
    for _, grunt in pairs(self.grunts) do
        grunt:update(dt)
    end
    self.boss:update(dt)
end

--[[
    EnemySystem render function.

    Params:
        none
    Returns:
        none
]]
function EnemySystem:render()
    for _, grunt in pairs(self.grunts) do
        grunt:render()
    end
    for _, turret in pairs(self.turrets) do
        turret:render()
    end
    self.boss:render()
end

--[[
    Spawns all enemy objects that are present at the beginning
    of the game. Enemy objects include Grunt and Boss Entity
    objects and gun turrets

    Params:
        areas: table - MapArea objects table
    Returns:
        nil
]]
function EnemySystem:spawn(areas)
    for _, area in pairs(areas) do
        local roomArea = area.width * area.height
        local startCount, endCount, numGrunts
        if roomArea < 64 then
            startCount = 3
            endCount = 5
        elseif roomArea == 64 then
            startCount = 6
            endCount = 10
        else
            startCount = 11
            endCount = 15
        end
        numGrunts = math.random(startCount, endCount)
        for _ = 1, numGrunts do
            local grunt = Grunt(GAnimationDefintions['grunt'], GGruntDefinition)
            grunt.x = math.random(area.x + GRUNT_WIDTH, area.x + (area.width * FLOOR_TILE_WIDTH) - GRUNT_WIDTH)
            grunt.y = math.random(area.y + GRUNT_HEIGHT, area.y + (area.height * FLOOR_TILE_HEIGHT) - GRUNT_HEIGHT)
            grunt.areaID = area.id
            grunt.stateMachine = StateMachine {
                ['walking'] = function () return GruntWalkingState(grunt, self.player) end,
                ['attacking'] = function () return GruntAttackingState(grunt, self.player) end,
            }
            grunt.stateMachine:change('walking')
            table.insert(self.grunts, grunt)
        end
        -- spawn the boss in area 27
        if area.id == 27 then
            self.boss = Boss(GAnimationDefintions['boss'], GBossDefinition)
            self.boss.stateMachine = StateMachine {
                ['walking'] = function () return BossWalkingState(self.boss, self.player) end
            }
            self.boss.stateMachine:change('walking')
        end
    end
end

--[[
    Spawns new enemy objects across the Map as enemies are killed

    Params:
        none
    Returns:
        nil
]]
function EnemySystem:respawn()
    
end
