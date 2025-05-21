local Classs = require("middleclass")
local Goal = require("Goal")


local Player = Classs("Player")

function Player:initialize(name, x, y)
    self.name = name
    self.x = x
    self.y = y
    self.goals = {}
end

function Player:addGoal(name, progress)
    local goal = Goal:new(name, progress)
    table.insert(self.goals, goal)
end


return Player


