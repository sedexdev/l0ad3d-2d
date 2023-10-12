Map = Class{}

function Map:init()
    self.numAreas = 1
    self.areas = {}
end

function Map:update(dt)
    
end

function Map:render()
    for _, area in pairs(self.areas) do
        area:render()
    end
    -- for _, powerup in pairs(self.rooms.powerups) do
    --     powerup:render()
    -- end
    -- for _, corridor in pairs(self.corridors) do
    --     corridor:render()
    -- end
end

function Map:generateLevel()
    -- instantiate the area objects and add them to the areas table
    table.insert(self.areas, MapArea(0, 0, 6, 8, 3, 6, 2))
    -- generate the tiles for each area
    for _, area in pairs(self.areas) do
        area:generateFloorTiles()
        area:generateWallTiles()
    end
    -- create a number of corridors less than the number of rooms
    -- join some rooms by corridors
    -- join other rooms to each other directly
    -- create powerups
    -- update powerups so more are spawned as the level goes on
end