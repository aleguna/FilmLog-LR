require 'Logger'

local LightroomMetadata = {
}

local function getRawValue (photo, key)
    local value = ""

    if photo["getRawMetadata"] then
        value = photo:getRawMetadata (key)
    else
        value = photo[key]
    end

    log (photo.localIdentifier, ' getR: ', key, '=', tostring (value))
    
    return value
end

local function getFormattedValue (photo, key)
    local value = ""
    
    if photo["getFormattedMetadata"] then
        value = photo:getFormattedMetadata (key)
    else
        value = photo[key]
    end

    log (photo.localIdentifier, ' getF: ', key, '=', tostring (value))
    
    return value
end

function LightroomMetadata:stackPositionInFolder ()
    return getRawValue (self.photo, "stackPositionInFolder")
end

function LightroomMetadata:fileName ()
    return getFormattedValue (self.photo, "fileName")
end

function LightroomMetadata:make (photo) 
    local metadata = {}
    setmetatable (metadata, self)
    self.__index = self

    metadata.photo = photo

    log ("LightroomMetadata::make OK")

    return metadata
end

return {
    make = function (photo)
        return LightroomMetadata:make (photo)
    end
}