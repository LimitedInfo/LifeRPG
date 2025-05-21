local Classs = require("middleclass")
local UIElement = require("Element")

Button = setmetatable({}, {__index = UIElement})
Button.__index = Button

function Button:new(x, y, width, height, label, onClick)
    local obj = UIElement.new(self, x, y, width, height)
    obj.label = label or "Button"
    obj.onClick = onClick or function() end
    setmetatable(obj, Button)
    return obj
end

function Button:click()
    self.onClick()
end

return Button
