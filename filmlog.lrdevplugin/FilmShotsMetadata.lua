require 'log.lua'

local Metatable = {
    __index = function (table, key)
        return table.photo:getPropertyForPlugin (_PLUGIN, key)
    end,

    __newindex = function (table, key, value)
        log:tracef ("%s = %s", key, value)
        table.photo:setPropertyForPlugin (_PLUGIN, key, value)
    end
}

return {
    make = function (photo)
        local metadata = {}
        metadata.photo = photo

        setmetatable (metadata, Metatable)

        return metadata
    end
}