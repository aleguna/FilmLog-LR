local LightroomMetadata = {
}

local function getRawValue (photo, key)
    local value = ""

    if photo["getRawMetadata"] then
        value = photo:getRawMetadata (key)
    else
        value = photo[key]
    end
    
    return value
end

local function getFormattedValue (photo, key)
    local value = ""
    
    if photo["getFormattedMetadata"] then
        value = photo:getFormattedMetadata (key)
    else
        value = photo[key]
    end
    
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
    return metadata
end

return {
    make = function (photo)
        return LightroomMetadata:make (photo)
    end
}