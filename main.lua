local Player = require("Player")
local Button = require("Button")
local fts = require("functions.Functions")
local dp = require("functions.DataPersistance")
local githubCommits = require("GithubCommits")

function love.load()
    local savedData = dp.loadData("data.json")

    -- love.window.setPosition(2100, 400)
    -- set window to larger size
    love.window.setMode(1400, 900)
    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()

    -- github related information
    githubCommits.createYearGrid()
    contributions = githubCommits.getContributionsByYear("2025")

    performanceRating = githubCommits.determinePerformance(contributions)

    -- player related information
    player = Player:new("Andrew", 100, 100)
    goalNames = {"learn lua", "learn love2d", "learn python", "learn javascript", "learn html"}
    for i = 1, 5 do
        player:addGoal(goalNames[i])

        if savedData and savedData[goalNames[i]] then
            player.goals[i].progress = savedData[goalNames[i]]
        end
    end

    goalButtons = {}
    for i, goal in pairs(player.goals) do
        table.insert(goalButtons, Button:new(100 + (i * 150), 200, 120, 40, "Reset", function()
        goal.progress = 0
        print("Reset goal: " .. goal.name)
        end))
    end
end

function love.mousepressed(mx, my, buttonPressed)
    for _, goal in ipairs(player.goals) do
        if goal:isClicked(mx, my) then
            goal:incrementProgress()

            data = {}
            for _, goal in ipairs(player.goals) do
                data[goal.name] = goal.progress
            end

            dp.saveData(data, "data.json")
        end
    end

    if buttonPressed == 1 then
        for _, b in ipairs(goalButtons) do
            if b:isHovered(mx, my) then
                b:click()
            end
        end
    end
end

function love.draw()
    player:draw()
    xValues = fts.evenlySpaceObjects(player.goals)
    
    -- draw github grid
    githubCommits.drawGrid(contributions)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(performanceRating, 10, 10)

    enumerator = 0
    for goal, progress in pairs(player.goals) do
        enumerator = enumerator + 1
        
        -- Draw goal buttons
        goalButtons[enumerator]:draw()
        goalButtons[enumerator].x = xValues[enumerator]

        -- print goal name and progress
        player.goals[enumerator].x = xValues[enumerator]
        player.goals[enumerator].y = 240
        player.goals[enumerator]:draw()

        -- Draw goal progress bars
        for i = 1, player.goals[enumerator].progress do
            love.graphics.rectangle("fill", xValues[enumerator] + ((i-1) * 25), 280, 20, 20)
        end
    end
end

function love.update()
end
