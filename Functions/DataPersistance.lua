-- Save data to file
local json = require("libraries.dkjson") -- or "json" if using a different library

function saveData(data, filename)
    local contents = json.encode(data, { indent = true })
    love.filesystem.write(filename, contents)
end

-- Load data from file
function loadData(filename)
    if love.filesystem.getInfo(filename) then
        local contents = love.filesystem.read(filename)
        return json.decode(contents)
    else
        return nil
    end
end
