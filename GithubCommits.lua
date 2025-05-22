-- calendar.lua

-- Constants
local daysInYear = 365  -- Use 366 for leap years
local boxSize = 20      -- Size of each box (width and height)
local margin = 2        -- Margin between boxes

-- Table to store all box positions
local calendarBoxes = {}

-- Function to create the grid
local function createYearGrid()
    calendarBoxes = {}  -- Clear previous grid

    for day = 0, daysInYear - 1 do
        local col = math.floor(day / 7)
        local row = day % 7

        local x = (boxSize + margin) * col
        local y = (boxSize + margin) * row

        table.insert(calendarBoxes, {x = x, y = y, day = day + 1})
    end
end

-- Function to draw the grid
local function drawGrid()
    for _, box in ipairs(calendarBoxes) do
        love.graphics.rectangle("fill", box.x, 300 + box.y, boxSize, boxSize)
    end
end

-- Return public API
return {
    createYearGrid = createYearGrid,
    drawGrid = drawGrid
}
