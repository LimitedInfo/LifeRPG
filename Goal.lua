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

function Goal:incrementProgress()
    self.progress = self.progress + 1
end

function Goal:isClicked(mx, my)
    return mx >= self.x and mx <= self.x + self.width and
           my >= self.y and my <= self.y + self.height
end


return Goal

