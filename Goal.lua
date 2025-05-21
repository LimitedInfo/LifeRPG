local Classs = require("middleclass")


local Goal = Classs("Goal")

function Goal:initialize(name, progress, x, y)
    self.name = name
    self.x = x
    self.y = y
    self.width = 100
    self.height = 100
    self.progress = progress or 0 
end

function Goal:draw()
    love.graphics.print(self.name, self.x, self.y)
    love.graphics.print(self.progress, self.x, self.y + 20)
end

function Goal:incrementProgress()
    self.progress = self.progress + 1
end

function Goal:isClicked(mx, my)
    return mx >= self.x and mx <= self.x + self.width and
           my >= self.y and my <= self.y + self.height
end


return Goal

