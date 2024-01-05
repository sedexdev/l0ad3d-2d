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
    self.cameraX       = 0
    self.cameraY       = 0
    self.width         = 190
    self.height        = 185
    self.canvas        = love.graphics.newCanvas(self.width, self.height)
    self.playerMarkerX = self.width / 2
    self.playerMarkerY = self.height / 2
    self:setCanvas()
end

--[[
    MiniMap update function

    Params:
        dt: number - deltatime counter for current frame rate
    Returns:
        nil
]]
function MiniMap:update(dt)
    self:updateCamera()
    self:setCanvas()
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
    love.graphics.draw(self.canvas, cameraX + 105, cameraY + 105)
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

--[[
    Sets up the canvas for drawing

    Params:
        none
    Returns:
        nil
]]
function MiniMap:setCanvas()
    love.graphics.setCanvas(self.canvas)
    -- clear must be called to let the canvas update
    love.graphics.clear()
    -- light green background
    love.graphics.setColor(0/255, 1, 0/255, 0.8)
    love.graphics.rectangle("fill", (-19000 * MINIMAP_SCALE), (-3600 * MINIMAP_SCALE), self.width * 2.3, self.height * 1.4)
    -- darker green for the areas
    love.graphics.setColor(0/255, 102/255, 0/255, 0.8)
    self:drawCorridors()
    self:drawAreas()
    self:drawPlayerMarker()
    love.graphics.setCanvas()
end

--[[
    Updates the location of the 'camera' so that the canvas is 
    translated in relation to the Player marker. The translation
    is based off the players position minus the pixel value of the
    center of the canvas

    Params:
        none
    Returns:
        nil
]]
function MiniMap:updateCamera()
    self.cameraX = self.playerMarkerX - (self.width / 2)
    self.cameraY = self.playerMarkerY - (self.height / 2)
end

-- ========================= DRAW FUNCTIONS =========================

--[[
    Creates the minimap corridrs to be rendered to the
    canvas based off of the definitions defined in
    GMapAreaDefinitions

    Params:
        none
    Returns:
        nil
]]
function MiniMap:drawCorridors()
    for i = 1, 16 do
        local x, y = self:getCorridorCoordinates(GMapAreaDefinitions[i])
        -- add corrections to make sure corridors touch the nearby area
        if i ==  7 then x = x - 50 end
        if i == 10 then x = x - 100 end
        if i == 11 then y = y - 50 end
        if i == 13 then x = x + 100 end
        if i == 15 then x = x - 100 end
        love.graphics.rectangle("fill",
            x * MINIMAP_SCALE,
            y * MINIMAP_SCALE,
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
        none
    Returns:
        nil
]]
function MiniMap:drawAreas()
    for i = 17, #GMapAreaDefinitions do
        love.graphics.rectangle("fill",
            GMapAreaDefinitions[i].x * MINIMAP_SCALE,
            GMapAreaDefinitions[i].y * MINIMAP_SCALE,
            (GMapAreaDefinitions[i].width * FLOOR_TILE_WIDTH) * MINIMAP_SCALE,
            (GMapAreaDefinitions[i].height * FLOOR_TILE_HEIGHT) * MINIMAP_SCALE
        )
    end
end

--[[
    Draws the Player marker relative to the Player object
    in the main Map

    Params:
        none
    Returns:
        nil
]]
function MiniMap:drawPlayerMarker()
    love.graphics.translate(-math.floor(self.cameraX), -math.floor(self.cameraY))
    love.graphics.setColor(1, 0/255, 0/255)
    love.graphics.rectangle(
        "fill",
        self.playerMarkerX, self.playerMarkerY,
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

