--[[
    Map: class

    Description:
        Creates and renders out the game map. The map is comprised
        of areas and corridors that join areas together. Areas have
        a fixed (x, y) coordinate with corridors being rendered from
        the center of the area wall depending on the location of the
        corridor (left, right, top, bottom). The (x, y) of any corridors
        connected to an area is determined based on the (x, y) of the 
        area
]]

Map = Class{}

--[[
    Map constructor. Defines tables for storing area and corridor
    objects, as well as a corridor tracking table that stores the index
    of a corridor as defined in src/utils/definitions.lua as GMapCorridorDefinitions.
    The indices are used to ensure that corridors are not rendered twice
    as they are connected to 2 different areas 

    Params:
        none
    Returns:
        nil
]]
function Map:init()
    self.areas = {}
    self.corridors = {}
    self.corridorTracker = {}
end

--[[
    Map render function. Renders out the areas, corridors, powerup objects,
    crates, and enemies that define this Map

    Params:
        none
    Returns:
        none
]]
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
end

--[[
    Generates the MapArea and MapCorridor objects that are composite
    elements of the Map. Also responsible for generating interactive
    game objects including Entity and PowerUp instances for the Player
    object to interact with

    Params:
        none
    Returns:
        nil
]]
function Map:generateLevel()
    -- instantiate the area objects and add them to the areas table
    for i = 1, #GMapAreaDefinitions do
        table.insert(self.areas, MapArea(
            i, -- area id
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
                    self:instantiateCorridor(corridors[j], i)
                end
            end
        end
    end
    -- generate the tiles for each area
    for _, area in pairs(self.areas) do
        area:generateFloorTiles()
        area:generateWallTiles()
    end
    -- generate the tiles for each corridor
    for _, corridor in pairs(self.corridors) do
        MapArea.generateFloorTiles(corridor)
        corridor:generateWallTiles()
    end
    -- create powerups
    -- update powerups so more are spawned as the level goes on
    -- create enemies
    -- update enemies so more are spawned as the level goes on
end

--[[
    Checks where the corridor is located (L, R, T, B) and creates 
    a new MapCorridor object using the helper functions below for 
    each location. Also updates the <self.corridorTracker> table 
    to avoid rendering the same corridor twice

    Params:
        corridor: table - corridor definition with GMapAreaDefinitions.corridors 
                          index and location
        areaIndex: number - index of the area as defined in GMapAreaDefinitions
    Returns:
        nil
]]
function Map:instantiateCorridor(corridor, areaIndex)
    -- corridor[1] = index in GMapAreaDefinitions.corridors[j] (see) MapArea:generateLevel() above
    -- corridor[2] = location in GMapAreaDefinitions.corridors[j] (see) MapArea:generateLevel() above
    local x, y
    if corridor[2] == 'L' then
        -- set coordinates on left corridor
        x, y = self:setLeftCorridorCoordinates(GMapAreaDefinitions[areaIndex], GMapCorridorDefinitions[corridor[1]])
    elseif corridor[2] == 'R' then
        -- set coordinates on right corridor
        x, y = self:setRightCorridorCoordinates(GMapAreaDefinitions[areaIndex])
    elseif corridor[2] == 'T' then
        -- set coordinates on top corridor
        x, y = self:setTopCorridorCoordinates(GMapAreaDefinitions[areaIndex], GMapCorridorDefinitions[corridor[1]])
    else
        -- set coordinates on bottom corridor
        x, y = self:setBottomCorridorCoordinates(GMapAreaDefinitions[areaIndex])
    end
    -- create the MapCorridor objects
    table.insert(self.corridors, MapCorridor(
        corridor[1], -- corridor id
        x, y,
        GMapCorridorDefinitions[corridor[1]].width,
        GMapCorridorDefinitions[corridor[1]].height,
        GMapCorridorDefinitions[corridor[1]].direction,
        GMapCorridorDefinitions[corridor[1]].bend,
        GMapCorridorDefinitions[corridor[1]].junction,
        GMapCorridorDefinitions[corridor[1]].doorIDs
    ))
    -- add the table index to the tracker
    table.insert(self.corridorTracker, corridor[1])
end

--[[
    Sets the (x, y) coordinates for any MapCorridor object joined 
    to the left wall of a MapArea object

    Params:
        area: table - GMapAreaDefinitions definition of the MapArea 
                      object whose corridors we need to calculate 
                      (x, y) for 
        corridor: table - GMapCorridorDefinitions definition of the
                          MapCorridor object we are calculating 
                          (x, y) for
    Returns
        number: x - the x coordeinate the corridor will be rendered at
        number: y - the y coordeinate the corridor will be rendered at
]]
function Map:setLeftCorridorCoordinates(area, corridor)
    -- corridor definition required to calculate corridor width offset
    -- left edge of area minus the pixel width of the corridor
    local x = area.x - (corridor.width * (64 * 5))
    -- half the height of the area
    local y = area.y + (area.height * (32 * 5) / 2) - (32 * 5)
    return x, y
end

--[[
    Sets the (x, y) coordinates for any MapCorridor object joined 
    to the right wall of a MapArea object

    Params:
        area: table - GMapAreaDefinitions definition of the MapArea 
                      object whose corridors we need to calculate 
                      (x, y) for
    Returns
        number: x - the x coordeinate the corridor will be rendered at
        number: y - the y coordeinate the corridor will be rendered at
]]
function Map:setRightCorridorCoordinates(area)
    -- right edge of the area
    local x = area.x + (area.width * (64 * 5))
    -- half the height of the area
    local y = area.y + (area.height * (32 * 5) / 2) - (32 * 5)
    return x, y
end

--[[
    Sets the (x, y) coordinates for any MapCorridor object joined 
    to the top wall of a MapArea object

    Params:
        area: table - GMapAreaDefinitions definition of the MapArea 
                      object whose corridors we need to calculate 
                      (x, y) for 
        corridor: table - GMapCorridorDefinitions definition of the
                          MapCorridor object we are calculating 
                          (x, y) for
    Returns
        number: x - the x coordeinate the corridor will be rendered at
        number: y - the y coordeinate the corridor will be rendered at
]]
function Map:setTopCorridorCoordinates(area, corridor)
    -- corridor definition required to calculate corridor height offset
    -- half the width of the area
    local x = area.x + (area.width * (64 * 5) / 2) - (32 * 5)
    -- top edge of the area minus the pixel height of the corridor
    local y = area.y - (corridor.height * (32 * 5))
    return x, y
end

--[[
    Sets the (x, y) coordinates for any MapCorridor object joined 
    to the bottom wall of a MapArea object

    Params:
        area: table - GMapAreaDefinitions definition of the MapArea 
                      object whose corridors we need to calculate 
                      (x, y) for
    Returns
        number: x - the x coordeinate the corridor will be rendered at
        number: y - the y coordeinate the corridor will be rendered at
]]
function Map:setBottomCorridorCoordinates(area)
    -- half the width of the area
    local x = area.x + (area.width * (64 * 5) / 2) - (32 * 5)
    -- bottom edge of the area
    local y = area.y + (area.height * (32 * 5))
    return x, y
end
