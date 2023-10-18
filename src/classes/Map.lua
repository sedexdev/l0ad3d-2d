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
            GMapAreaDefinitions[i].adjacentArea
        ))
        local corridors = GMapAreaDefinitions[i].corridors
        if corridors then
            for j = 1, #corridors do
                -- sotre current corridor index
                local corridorIndex = corridors[j][1]
                -- check to see if we have already instantiated this corridor
                if not table.contains(self.corridorTracker, corridorIndex) then
                    self:instantiateCorridor(corridors, j, i, corridorIndex)
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

-- checks where the corridor is located and creates a new MapCorridor object
-- updates the corridor tracker table to avoid rendering the same corridor twice
function Map:instantiateCorridor(corridors, corridorNum, areaIndex, corridorIndex)
    local x, y
    if corridors[corridorNum][2] == 'L' then
        -- set coordinates on left corridor
        x, y = self:setLeftCorridorCoordinates(GMapAreaDefinitions[areaIndex], GMapCorridorDefinitions[corridorIndex])
    elseif corridors[corridorNum][2] == 'R' then
        -- set coordinates on right corridor
        x, y = self:setRightCorridorCoordinates(GMapAreaDefinitions[areaIndex])
    elseif corridors[corridorNum][2] == 'T' then
        -- set coordinates on top corridor
        x, y = self:setTopCorridorCoordinates(GMapAreaDefinitions[areaIndex], GMapCorridorDefinitions[corridorIndex])
    else
        -- set coordinates on bottom corridor
        x, y = self:setBottomCorridorCoordinates(GMapAreaDefinitions[areaIndex])
    end
    table.insert(self.corridors, MapCorridor(
        x, y,
        GMapCorridorDefinitions[corridorIndex].width,
        GMapCorridorDefinitions[corridorIndex].height,
        GMapCorridorDefinitions[corridorIndex].direction,
        GMapCorridorDefinitions[corridorIndex].bend,
        GMapCorridorDefinitions[corridorIndex].junction,
        GMapCorridorDefinitions[corridorIndex].doorIDs
    ))
    -- add the table index to the tracker
    table.insert(self.corridorTracker, corridorIndex)
end

function Map:setLeftCorridorCoordinates(area, corridor)
    -- left edge of area minus the pixel width of the corridor
    local x = area.x - (corridor.width * (64 * 5))
    -- half the height of the area
    local y = area.y + (area.height * (32 * 5) / 2) - (32 * 5)
    return x, y
end

function Map:setRightCorridorCoordinates(area)
    -- right edge of the area
    local x = area.x + (area.width * (64 * 5))
    -- half the height of the area
    local y = area.y + (area.height * (32 * 5) / 2) - (32 * 5)
    return x, y
end

function Map:setTopCorridorCoordinates(area, corridor)
    -- center of the top edge of the area
    local x = area.x + (area.width * (64 * 5) / 2) - (32 * 5)
    local y = area.y - (corridor.height * (32 * 5))
    return x, y
end

function Map:setBottomCorridorCoordinates(area)
    -- center of the bottom edge of the area
    local x = area.x + (area.width * (64 * 5) / 2) - (32 * 5)
    local y = area.y + (area.height * (32 * 5))
    return x, y
end