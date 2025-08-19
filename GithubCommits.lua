-- calendar.lua
package.path = package.path .. ";./libraries/?.lua"
local json = require("libraries.dkjson")

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

function getContributionsByYear(year)
    data = getGithubContributionsData()

    print("\n=== Contributions by Year (from contributions array) ===")
    local yearContributions = {}
    
    for i, contribution in ipairs(data.contributions) do
        local contributionYear = string.sub(contribution.date, 1, 4)
        if contributionYear == year then
            table.insert(yearContributions, contribution)  -- Fixed: was yearContributions.insert
        end
    end

    for i, contribution in ipairs(yearContributions) do
        print("Date: " .. contribution.date .. ", Count: " .. contribution.count .. ", Level: " .. contribution.level)  -- Fixed: was just contribution
    end

    return yearContributions
end

print(getContributionsByYear("2025"))

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
    local contributions = getContributionsByYear("2025")
    for i, box in ipairs(calendarBoxes) do
        print(contributions[i].count)
        love.graphics.rectangle("fill", box.x, 300 + box.y, boxSize, boxSize)

        -- color the box based on the contributions
        if contributions[i].count > 0 then
            love.graphics.setColor(0, 1, 0, 1)
        else
            love.graphics.setColor(1, 0, 0, 1)
        end
        
    end
end

-- Return public API
return {
    createYearGrid = createYearGrid,
    drawGrid = drawGrid
}
