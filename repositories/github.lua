

local function httpGet(url)
    local handle = io.popen('curl -s "' .. url .. '"')
    local result = handle:read("*a")
    handle:close()
    return result
end

local function saveJsonToFile(jsonString, filename)
    -- Encode the data to JSON string with pretty formatting
    -- local jsonString = json.encode(data, { indent = true })
    
    -- Write to file
    local file = io.open(filename, "w")
    if file then
        file:write(jsonString)
        file:close()
        return true
    else
        return false, "Could not open file for writing"
    end
end

package.path = package.path .. ";../?.lua;../?/init.lua"

-- Usage
local response = httpGet('https://github-contributions-api.jogruber.de/v4/LimitedInfo')
print("Response:", response)

-- Parse JSON if needed (you already have dkjson)
local json = require("libraries.dkjson")
local data = json.decode(response)
if data then
    print("Parsed data:", data)
    saveJsonToFile(response, "github_data.json")
end