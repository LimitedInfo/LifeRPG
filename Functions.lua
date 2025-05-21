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


return {
    evenlySpaceObjects = evenlySpaceObjects
}

