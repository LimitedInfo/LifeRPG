-- calendar.lua
package.path = package.path .. ";./libraries/?.lua"
local json = require("libraries.dkjson")

contributionGoal = 7

function getGithubContributionsData()
    local file = io.open('repositories/github_data.json', "r")
    if file then
        jsonString = file:read("*a")
        file:close()

    else
        print("Could not open file for reading")
    end

    return json.decode(jsonString)
end

local function countTable(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

function printTable(t, indent)
    indent = indent or 0
    local prefix = string.rep("  ", indent)
    
    if type(t) ~= "table" then
        print(prefix .. tostring(t))
        return
    end
    
    for key, value in pairs(t) do
        if type(value) == "table" then
            print(prefix .. tostring(key) .. ":")
            printTable(value, indent + 1)
        else
            print(prefix .. tostring(key) .. ": " .. tostring(value))
        end
    end
end

function parseDate(date)
    local year = string.sub(date, 1, 4)
    local month = string.sub(date, 6, 7)
    local day = string.sub(date, 9, 10)
    return {year = year, month = month, day = day}
end

function getContributionsByYear(year)
    data = getGithubContributionsData()

    local yearContributions = {}
    
    for i, contribution in ipairs(data.contributions) do
        local contributionYear = string.sub(contribution.date, 1, 4)
        if contributionYear == year then
            table.insert(yearContributions, contribution)  -- Fixed: was yearContributions.insert
        end
    end
    return yearContributions
end

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
local function drawGrid(contributions)
    for i, box in ipairs(calendarBoxes) do
        -- we need to draw the boxes relative to the bottom middle of the screen dynamically
        local screenWidth = love.graphics.getWidth()
        local screenHeight = love.graphics.getHeight()
        local gridWidth = (boxSize + margin) * math.ceil(daysInYear / 7)
        local startX = (screenWidth - gridWidth) / 2
        local startY = screenHeight - (boxSize + margin) * 7 - 50

        -- lets make these boxes Elements to enable UIHover
        local boxElement = UIElement:new(startX + box.x, startY + box.y, boxSize, boxSize)
        
        -- override the draw behavior to draw the box
        boxElement.draw = function()
            love.graphics.rectangle("fill", startX + box.x, startY + box.y, boxSize, boxSize)
        end

        -- set the draw behavior to draw the box
        boxElement:draw()

        -- lets set the hover behavior to display the date of the contribution in text
        boxElement.hoverBehavior = function()
            love.graphics.setColor(1, 1, 1)
            love.graphics.print(contributions[i].date, startX + box.x - 55, startY + box.y)
        end

        if boxElement:isHovered(love.mouse.getX(), love.mouse.getY()) then
            boxElement.hoverBehavior()
        end

        -- color the box based on the contributions
        if contributions[i].count > 0 then
            love.graphics.setColor(0, contributions[i].count * .25, 0, 1)
        else
            love.graphics.setColor(.1, .1, .1, 1)
        end
        
    end
end

function determinePerformance(contributions)
    -- filter to dates within the last 7 days including today
    local today = os.date("*t")
    local sevenDaysAgo = {
        year = today.year,
        month = today.month,
        day = today.day - 7
    }
    local sevenDaysAgoDate = os.time(sevenDaysAgo)

    -- filter contributions to only include dates within the last 7 days
    local filteredContributions = {}
    for i, contribution in ipairs(contributions) do
        local contributionDate = os.time(parseDate(contribution.date))

        if contributionDate >= sevenDaysAgoDate then
            table.insert(filteredContributions, contribution)
        end
    end

    local count = 0
    for i, contribution in ipairs(filteredContributions) do
        count = count + contribution.count * contribution.level
    end
 
    if count > contributionGoal then
        performanceRating = 'Awesome'
    elseif count > contributionGoal * .75 then
        performanceRating = 'Good'
    elseif count > contributionGoal * .5 then
        performanceRating = 'Average'
    else
        performanceRating = 'Needs Improvement'
    end


    return performanceRating
end


-- Return public API
return {
    createYearGrid = createYearGrid,
    drawGrid = drawGrid,
    determinePerformance = determinePerformance,
    getContributionsByYear = getContributionsByYear
}
