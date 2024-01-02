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
    objects

    Params:
        none
    Returns:
        nil
]]
function Map:init()
    self.areas = {}
end

--[[
    Map render function. Renders out the MapArea objects stored 
    in <self.areas>

    Params:
        none
    Returns:
        none
]]
function Map:render()
    -- render out each area
    for _, area in pairs(self.areas) do
        area:render()
    end
end

--[[
    Generates the MapArea objects that form the Map. Also responsible 
    for calling functions for generating interactive game objects 
    including Entity and PowerUp instances for the Player object to 
    interact with, as well the games door system


    Params:
        systemManager: table - SystemManager object
    Returns:
        nil
]]
function Map:generateLevel(systemManager)
    -- instantiate the area objects and add them to the areas table
    for i = 1, #GMapAreaDefinitions do
        -- populate the (x, y) for corridors based off of joined areas
        local x, y
        if GMapAreaDefinitions[i].type == 'corridor' then
            x, y = self:getCorridorCoordinates(GMapAreaDefinitions[i])
            GMapAreaDefinitions[i].x = x
            GMapAreaDefinitions[i].y = y
        end
        table.insert(self.areas, MapArea(
            i, -- area id
            GMapAreaDefinitions[i].x,
            GMapAreaDefinitions[i].y,
            GMapAreaDefinitions[i].width,
            GMapAreaDefinitions[i].height,
            GMapAreaDefinitions[i].type,
            GMapAreaDefinitions[i].orientation,
            GMapAreaDefinitions[i].bends,
            GMapAreaDefinitions[i].joins,
            GMapAreaDefinitions[i].doors,
            GMapAreaDefinitions[i].adjacentAreas
        ))
        -- insert invincibility powerup up in area 26
        if i == INVINCIBLE_AREA then
            local powerupX = GMapAreaDefinitions[i].x + (GMapAreaDefinitions[i].width * FLOOR_TILE_WIDTH / 2) - POWERUP_WIDTH / 2
            local powerupY = GMapAreaDefinitions[i].y + (GMapAreaDefinitions[i].height * FLOOR_TILE_HEIGHT / 2) - POWERUP_HEIGHT / 2
            table.insert(systemManager.objectSystem.objects[i].powerups,
                -- set ID of 0 to make it unique from other powerups that start at ID == 1
                PowerUp(0, 'invincible', i, powerupX, powerupY)
            )
        end
    end
    for _, area in pairs(self.areas) do
        -- generate the tiles for each area
        area:generateFloorTiles()
        area:generateWallTiles()
    end
    -- initialise the Door objects in the DoorSystem
    systemManager.doorSystem:initialiseDoors(self.areas)
    -- spawn powerups, crates, and keys
    systemManager.objectSystem:spawn()
    -- spawn enemies in area 17 and it's adjacent areas at the start
    for _, area in pairs(self:getStartingAreas()) do
        systemManager.enemySystem:spawn(area)
    end
    -- spawn the turrets in each area
    systemManager.enemySystem:spawnTurrets()
end

-- ========================= GETTERS =========================

--[[
    Returns the MapArea object of the area with the corresponding
    area ID

    Params:
        areaID: number - area ID to index <self.areas>
    Returns:
        table: MapArea object
]]
function Map:getAreaDefinition(areaID)
    return self.areas[areaID]
end

--[[
    Gets the starting areas to spawn grunt type Entity objects in
    when the game level is generated

    Params:
        none
    Returns:
        table: list of MapArea objects
]]
function Map:getStartingAreas()
    local areas = {}
    table.insert(areas, self.areas[START_AREA_ID])
    for _, id in pairs(GAreaAdjacencyDefinitions[START_AREA_ID]) do
        if id >= START_AREA_ID then
            table.insert(areas, self.areas[id])
        end
    end
    return areas
end

-- ========================= SETTERS =========================

--[[
    Checks where the corridor is located (L, R, T, B) and sets the corridor
    area coordinates based off one of the areas it is joined to as defined
    in GMapAreaDefinitions

    Params:
        area: table - GMapAreaDefinitions definition of an area
    Returns:
        nil
]]
function Map:getCorridorCoordinates(area)
    -- just use frst table in self.joins to get the coordinates
    if area.joins[1][2] == 'L' then
        -- get coordinates of left corridor
        return self:setLeftCorridorCoordinates(GMapAreaDefinitions[area.joins[1][1]], area)
    elseif area.joins[1][2] == 'R' then
        -- get coordinates of right corridor
        return self:setRightCorridorCoordinates(GMapAreaDefinitions[area.joins[1][1]])
    elseif area.joins[1][2] == 'T' then
        -- get coordinates of top corridor
        return self:setTopCorridorCoordinates(GMapAreaDefinitions[area.joins[1][1]], area)
    elseif area.joins[1][2] == 'B' then
        -- get coordinates of bottom corridor
        return self:setBottomCorridorCoordinates(GMapAreaDefinitions[area.joins[1][1]])
    end
end

--[[
    Gets the (x, y) coordinates for a corridor MapArea object joined 
    to the left wall of another MapArea object

    Params:
        area:     table - GMapAreaDefinitions definition
        corridor: table - GMapAreaDefinitions definition
    Returns
        number: x - the x coordeinate the corridor will be rendered at
        number: y - the y coordeinate the corridor will be rendered at
]]
function Map:setLeftCorridorCoordinates(area, corridor)
    -- corridor definition required to calculate corridor width offset
    -- left edge of area minus the pixel width of the corridor
    local x = area.x - (corridor.width * FLOOR_TILE_WIDTH)
    -- half the height of the area
    local y = area.y + (area.height * FLOOR_TILE_HEIGHT / 2) - FLOOR_TILE_HEIGHT
    return x, y
end

--[[
    Gets the (x, y) coordinates for a corridor MapArea object joined 
    to the right wall of another MapArea object

    Params:
        area: table - GMapAreaDefinitions definition
    Returns
        number: x - the x coordeinate the corridor will be rendered at
        number: y - the y coordeinate the corridor will be rendered at
]]
function Map:setRightCorridorCoordinates(area)
    -- right edge of the area
    local x = area.x + (area.width * FLOOR_TILE_WIDTH)
    -- half the height of the area
    local y = area.y + (area.height * FLOOR_TILE_HEIGHT / 2) - FLOOR_TILE_HEIGHT
    return x, y
end

--[[
    Gets the (x, y) coordinates for a corridor MapArea object joined 
    to the top wall of another MapArea object

    Params:
        area:     table - GMapAreaDefinitions definition
        corridor: table - GMapAreaDefinitions definition
    Returns
        number: x - the x coordeinate the corridor will be rendered at
        number: y - the y coordeinate the corridor will be rendered at
]]
function Map:setTopCorridorCoordinates(area, corridor)
    -- corridor definition required to calculate corridor height offset
    -- half the width of the area
    local x = area.x + (area.width * FLOOR_TILE_WIDTH / 2) - FLOOR_TILE_HEIGHT
    -- top edge of the area minus the pixel height of the corridor
    local y = area.y - (corridor.height * FLOOR_TILE_HEIGHT)
    return x, y
end

--[[
    Gets the (x, y) coordinates for a corridor MapArea object joined 
    to the bottom wall of another MapArea object

    Params:
        area: table - GMapAreaDefinitions definition
    Returns
        number: x - the x coordeinate the corridor will be rendered at
        number: y - the y coordeinate the corridor will be rendered at
]]
function Map:setBottomCorridorCoordinates(area)
    -- half the width of the area
    local x = area.x + (area.width * FLOOR_TILE_WIDTH / 2) - FLOOR_TILE_HEIGHT
    -- bottom edge of the area
    local y = area.y + (area.height * FLOOR_TILE_HEIGHT)
    return x, y
end
