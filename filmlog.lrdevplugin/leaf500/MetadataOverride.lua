require 'Use'

local LightroomMetadata = use 'leaf500.LightroomMetadata'
local FilmShotsMetadata = use 'leaf500.FilmShotsMetadata'
local ExiftoolBuilder = use 'leaf500.ExiftoolBuilder'

local function apply (photos, metadataMap, LrTasks)
    if not photos or #photos == 0 then
        return {-1}
    end

    local results = {}

    for _, photo in ipairs (photos) do
        local meta = LightroomMetadata.make (photo)
        local builder = ExiftoolBuilder.make (metadataMap)	

        local command = builder:buildCommand (meta:path(), FilmShotsMetadata.make (photo))
        if command then
            local exiftoolResult = LrTasks.execute (command)
            table.insert (results, exiftoolResult)
        else
            table.insert (results, -1)
        end
    end

    return results
end

return {
    apply = apply
}