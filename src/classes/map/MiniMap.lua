--[[
    MiniMap: class

    Includes: Observer - parent class for observers

    Description:
        Defines the minimap within the HUD so the Player can
        use the marker to find their way around the Map
]]

MiniMap = Class{includes = Observer}

--[[
    MiniMap constructor

    Params:
        none
    Returns:
        nil
]]
function MiniMap:init()
    self.width          = WINDOW_WIDTH / 2
    self.height         = WINDOW_HEIGHT / 2
    self.playerMarkerX  = self.width
    self.playerMarkerY  = self.height
end

--[[
    MiniMap render function

    Params:
        cameraX: number - x location of game camera
        cameraY: number - y location of game camera
    Returns:
        nil
]]
function MiniMap:render(cameraX, cameraY)
    local offset = WINDOW_HEIGHT / 3
    love.graphics.setColor(0/255, 1, 0/255, 0.8)
    self:drawCorridors(cameraX, cameraY, offset)
    self:drawAreas(cameraX, cameraY, offset)
    self:drawPlayerMarker(cameraX, cameraY, offset)
end

--[[
    Observer message function implementation. Updates the
    <self.playerData> instance variable with the latest
    Player data and checks for collision with game objects
    and the map enevironment

    Params:
        data: table - Player object current state
    Returns;
        nil
]]
function MiniMap:message(data)
    if data.source == 'PlayerWalkingState' then
        self.playerMarkerX = data.x * MINIMAP_SCALE
        self.playerMarkerY = data.y * MINIMAP_SCALE
    end
end

-- ========================= DRAW FUNCTIONS =========================

--[[
    Creates the minimap corridrs to be rendered to the
    canvas based off of the definitions defined in
    GMapAreaDefinitions

    Params:
        cameraX: number - x location of game camera
        cameraY: number - y location of game camera
        offset:  number - pixel offset for minimap
    Returns:
        nil
]]
function MiniMap:drawCorridors(cameraX, cameraY, offset)
    for i = 1, 16 do
        local x, y = self:getCorridorCoordinates(GMapAreaDefinitions[i])
        -- add corrections to make sure corridors touch the nearby area
        if i ==  7 then x = x - 50 end
        if i == 10 then x = x - 100 end
        if i == 11 then y = y - 50 end
        if i == 13 then x = x + 100 end
        if i == 15 then x = x - 100 end
        love.graphics.rectangle("fill",
            (cameraX + self.width) + x * MINIMAP_SCALE,
            (cameraY + self.height - offset) + y * MINIMAP_SCALE,
            (GMapAreaDefinitions[i].width * FLOOR_TILE_WIDTH) * MINIMAP_SCALE,
            (GMapAreaDefinitions[i].height * FLOOR_TILE_HEIGHT) * MINIMAP_SCALE
        )
    end
end

--[[
    Creates the minimap areas to be rendered to the
    canvas based off of the definitions defined in
    GMapAreaDefinitions

    Params:
        cameraX: number - x location of game camera
        cameraY: number - y location of game camera
        offset:  number - pixel offset for minimap
    Returns:
        nil
]]
function MiniMap:drawAreas(cameraX, cameraY, offset)
    for i = 17, #GMapAreaDefinitions do
        love.graphics.rectangle("fill",
            (cameraX + self.width) + GMapAreaDefinitions[i].x * MINIMAP_SCALE,
            (cameraY + self.height - offset) + GMapAreaDefinitions[i].y * MINIMAP_SCALE,
            (GMapAreaDefinitions[i].width * FLOOR_TILE_WIDTH) * MINIMAP_SCALE,
            (GMapAreaDefinitions[i].height * FLOOR_TILE_HEIGHT) * MINIMAP_SCALE
        )
    end
end

--[[
    Draws the Player marker relative to the Player object
    in the main Map

    Params:
        cameraX: number - x location of game camera
        cameraY: number - y location of game camera
        offset:  number - pixel offset for minimap
    Returns:
        nil
]]
function MiniMap:drawPlayerMarker(cameraX, cameraY, offset)
    love.graphics.setColor(1, 0/255, 0/255)
    love.graphics.rectangle(
        "fill",
        (cameraX + self.width) + self.playerMarkerX,
        (cameraY + self.height - offset) + self.playerMarkerY,
        10, 10
    )
end

-- ========================= GETTERS =========================

--[[
    Checks where the corridor is located (L, R, T, B) and sets the corridor
    area coordinates based off one of the areas it is joined to as defined
    in GMapAreaDefinitions

    Params:
        area: table - GMapAreaDefinitions definition of an area
    Returns:
        nil
]]
function MiniMap:getCorridorCoordinates(area)
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
        number: x - the x coordinate the corridor will be rendered at
        number: y - the y coordinate the corridor will be rendered at
]]
function MiniMap:setLeftCorridorCoordinates(area, corridor)
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
        number: x - the x coordinate the corridor will be rendered at
        number: y - the y coordinate the corridor will be rendered at
]]
function MiniMap:setRightCorridorCoordinates(area)
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
        number: x - the x coordinate the corridor will be rendered at
        number: y - the y coordinate the corridor will be rendered at
]]
function MiniMap:setTopCorridorCoordinates(area, corridor)
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
        number: x - the x coordinate the corridor will be rendered at
        number: y - the y coordinate the corridor will be rendered at
]]
function MiniMap:setBottomCorridorCoordinates(area)
    -- half the width of the area
    local x = area.x + (area.width * FLOOR_TILE_WIDTH / 2) - FLOOR_TILE_HEIGHT
    -- bottom edge of the area
    local y = area.y + (area.height * FLOOR_TILE_HEIGHT)
    return x, y
end

