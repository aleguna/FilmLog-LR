local ExiftoolBuilder = {

}

function ExiftoolBuilder:buildCommand (photoPath, meta)
    local command = self.exiftoolPath

    local empty = true

    for _, pair in ipairs (self.metadataMap) do
        if pair.key and pair.val then
            local getter = meta[pair.val]
            if getter then
                local val = getter (meta)
                if val then
                    command = command .. " " .. string.format ("-%s=\"%s\"", pair.key, val)
                    empty = false
                end
            end
        end
    end

    if empty then
        return nil
    end

    command = command .. " -overwrite_original " .. "\"" .. photoPath .. "\""

    if WIN_ENV then
        command = "\"" .. command .. "\""
    end

    return command
end

function ExiftoolBuilder:make (metadataMap)
    local builder = {}
    setmetatable (builder, self)
    self.__index = self

    if MAC_ENV then
        builder.exiftoolPath = string.format ("\"%s/%s\"", _PLUGIN.path, "exiftool/macos/exiftool")
    elseif WIN_ENV then
        builder.exiftoolPath = string.format ("\"%s\\%s\"", _PLUGIN.path, "exiftool\\windows\\exiftool.exe")
    else
        builder.exiftoolPath = "exiftool"
    end
    
    builder.metadataMap = metadataMap
    return builder
end

return {
    make = function (metadataMap)
        return ExiftoolBuilder:make (metadataMap)
    end
}