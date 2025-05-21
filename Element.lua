UIElement = {}
UIElement.__index = UIElement

function UIElement:new(x, y, width, height)
    local obj = {
        x = x or 0,
        y = y or 0,
        width = width or 100,
        height = height or 30,
        label = "UIElement"
    }
    setmetatable(obj, self)
    return obj
end

function UIElement:draw()
    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(self.label, self.x + 10, self.y + 5)
end

function UIElement:isHovered(mx, my)
    return mx >= self.x and mx <= self.x + self.width and
           my >= self.y and my <= self.y + self.height
end

function UIElement:click()
    -- override in subclass
end

return UIElement
