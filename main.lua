if love._console then
    love._console = love._console or require("console")
end

local Player = require("Player")
local Button = require("Button")

function love.load()
    -- Set window size
    love.window.setMode(800, 600, {
        resizable = false,
        vsync = true
    })

    -- Set window position on the screen (e.g., top-left corner: 100,100)
    love.window.setPosition(2100, 400)


    


    x = 100
    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()
    player = Player:new("Andrew", 100, 100)
    player:addGoal("learn lua")
    player:addGoal("learn love2d")
    player:addGoal("learn python")
    player:addGoal("learn javascript")
    player:addGoal("learn html")

    goalButtons = {}
    for i, goal in pairs(player.goals) do
        table.insert(goalButtons, Button:new(100 + (i * 150), 200, 120, 40, "Reset", function()
            goal.progress = 0
            print("Reset goal: " .. goal.name)
        end))
    end

    
end


function evenlySpaceObjects(objects)
    local xValues = {}
    local count = 0

    -- Count how many items
    for _ in pairs(objects) do
        count = count + 1
    end

    local i = 0
    for _ in pairs(objects) do
        i = i + 1
        table.insert(xValues, screenWidth / count * i)
    end

    return xValues
end


function isOffScreen(obj)
    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()
    
    return obj.x + obj.width < 0 or        -- Left
           obj.x > screenWidth or          -- Right
           obj.y + obj.height < 0 or       -- Top
           obj.y > screenHeight            -- Bottom
end



obj = {
    x = 100,
    y = 50, 
    width = 200,
    height = 150
}


function love.mousepressed(mx, my, buttonPressed)
    for _, goal in ipairs(player.goals) do
        if goal:isClicked(mx, my) then
            goal:incrementProgress()
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


function isClicked(object, mx, my)
    return mx >= object.x and mx <= object.x + object.width and
           my >= object.y and my <= object.y + object.height
end


function love.draw()
    -- love.graphics.rectangle("line", obj.x, obj.y, obj.width, obj.height)
    love.graphics.print(player.name, 400, 200)

    xValues = evenlySpaceObjects(player.goals)
    enumerator = 0
    for goal, progress in pairs(player.goals) do
        enumerator = enumerator + 1
        player.goals[enumerator].x = xValues[enumerator]
        player.goals[enumerator].y = 240

        goalButtons[enumerator]:draw()
        goalButtons[enumerator].x = xValues[enumerator]

        --love.graphics.print(resetButton.label, xValues[enumerator], 220)
        love.graphics.print(player.goals[enumerator].name, xValues[enumerator], 240)
        love.graphics.print(player.goals[enumerator].progress, xValues[enumerator], 260)

        for i = 1, player.goals[enumerator].progress do
            love.graphics.rectangle("fill", xValues[enumerator] + ((i-1) * 25), 280, 20, 20)
        end
    end
end


function love.update()
    obj.x = obj.x + 5
    if isOffScreen(obj) then
        obj.x = 100
    end
end
