require 'Use'

local Version = use 'leaf500.Version'
local PluginInfo = use 'Info'

local VERSION_URL = "https://storage.googleapis.com/lrplugin.filmlog.leaf500.com/Info.lua"
local DOWNLOAD_URL = "http://leaf500.com/lightroom-plugin"

local function loadstring (str)
    if _G.loadstring then
        return _G.loadstring (str)
    end
    return load (str)
end

local function check (LrHttp, INFO)
    local result, headers = LrHttp.get (VERSION_URL, nil, 1)

    if INFO == nil then
        INFO = PluginInfo
    end

    if result and string.find (result, "<Error>") == nil then
        local chunk, error = loadstring (result)

        if chunk then
            local NEW_INFO = chunk ()
            if NEW_INFO and Version.newer (INFO.VERSION, NEW_INFO.VERSION)
            then
                return {
                    newVersion = string.format ("%d.%d.%d", NEW_INFO.VERSION.major, NEW_INFO.VERSION.minor, NEW_INFO.VERSION.revision),
                    downloadUrl = DOWNLOAD_URL
                }
            end
        else
            --print (error)
        end
    end

    return nil
end


return {
    check = check
}