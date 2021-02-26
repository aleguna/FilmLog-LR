require 'Use'

local json = use 'lib.dkjson'

local function fromJson (jsonString)
    if jsonString then
        local filmShotsMetadata, pos, error = json.decode (jsonString)
        
        if filmShotsMetadata and #filmShotsMetadata == 1 then
            local filmFrames = {}
            local maxIndex = 0
                        
            for _, frame in ipairs (filmShotsMetadata[1].frames) do
                filmFrames[frame.frameIndex] = frame

                if frame.frameIndex > maxIndex then
                    maxIndex = frame.frameIndex
                end
            end

            filmShotsMetadata[1].frameCount = maxIndex
            filmShotsMetadata[1].frames = filmFrames
            return filmShotsMetadata[1]
        else
            --print ("Error: ", pos, error)
        end
    end

    return nil
end

local function readFile (path)
    local str = nil

    local file = io.open (path)
    if file then
        str = file:read("*all")
        file:close ()
    end

    return str
end

local function fromFile (path)
    local jsonString = readFile (path)
    return fromJson (jsonString)
end

return {
    Mode = {
        ROLL = 'R',
        SET = 'HS'
    },

    fromJson = fromJson,
    fromFile = fromFile
}