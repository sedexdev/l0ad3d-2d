Map = Class{}

function Map:init()
    self.numAreas = 1
    self.areas = {}
    self.corridors = {}
    self.corridorTracker = {}
end

function Map:update(dt)
    
end

function Map:render()
    for _, area in pairs(self.areas) do
        area:render()
    end
    for _, corridor in pairs(self.corridors) do
        corridor:render()
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
    for i = 1, #GMapAreaDefinitions do
        table.insert(self.areas, MapArea(
            GMapAreaDefinitions[i].x,
            GMapAreaDefinitions[i].y,
            GMapAreaDefinitions[i].width,
            GMapAreaDefinitions[i].height,
            GMapAreaDefinitions[i].corridors,
            GMapAreaDefinitions[i].adjacentAreas
        ))
        if GMapAreaDefinitions[i].corridors then
            for j = 1, #GMapCorridorDefinitions do
                -- check to see if we have already instantiated this corridor
                if not table.contains(self.corridorTracker, GMapCorridorDefinitions[j]) then
                    table.insert(self.corridors, MapCorridor(
                        GMapCorridorDefinitions[j].x,
                        GMapCorridorDefinitions[j].y,
                        GMapCorridorDefinitions[j].width,
                        GMapCorridorDefinitions[j].height,
                        GMapCorridorDefinitions[j].direction,
                        GMapCorridorDefinitions[j].bend,
                        GMapCorridorDefinitions[j].junction,
                        GMapCorridorDefinitions[j].doorIDs
    
                    ))
                    -- add the table index to the tracker
                    table.insert(self.corridorTracker, j)
                end
            end
        end
    end
    -- generate the tiles for each area
    for _, area in pairs(self.areas) do
        area:generateFloorTiles()
        area:generateWallTiles()
    end
    for _, corridor in pairs(self.corridors) do
        MapArea.generateFloorTiles(corridor)
        corridor:generateWallTiles()
    end
    -- create powerups
    -- update powerups so more are spawned as the level goes on
end