local LrFunctionContext = import 'LrFunctionContext'
local LrDialogs = import 'LrDialogs'
local LrApplication = import 'LrApplication'
local LrTasks = import 'LrTasks'
local LrPathUtils = import 'LrPathUtils'
local LrFileUtils = import 'LrFileUtils'

local json = require 'json.lua'

local function readFile (path)
    local str = nil

    local file = io.open (path)
    if file then
        str = file:read("*all")
        file:close ()
    end

    return str;
end

local function saveMetadata (photo, metadata)
    photo:setPropertyForPlugin (_PLUGIN, "Roll_Name", metadata[1].name)
end

local function applyFilmShotsMetadataToPhoto (catalog, photo, frameIndex) 
    local path = photo:getRawMetadata ('path')
    if path and LrFileUtils.exists (path) then 
        local dir = LrPathUtils.parent (path)
        local dirName = LrPathUtils.leafName (dir)
        if dir and dirName then
            local jsonPath = LrPathUtils.child (dir, dirName..".json")
            local jsonString = readFile (jsonPath)
            if jsonString then
                local filmShotsMetadata = json.decode (jsonString)
                if filmShotsMetadata then
                    catalog:withPrivateWriteAccessDo (function (context)
                        saveMetadata (photo, filmShotsMetadata)
                    end)
                else
                    LrDialogs.message ("Incorrect file format "..jsonPath)
                end
            else
                LrDialogs.message ("Couldn't read metadata file "..jsonPath..", please check")
            end
        else
            LrDialogs.message ("This photo doesn't appear to be in a valid folder")
        end
    else
        LrDialogs.message ("This photo doesn't appear to have a valid path")
    end
    
end

local function applyFilmShotsMetadata () 
    local catalog = LrApplication.activeCatalog ()
    if catalog then
        local photo = catalog:getTargetPhoto ()
        if photo then
            local frameIndex, error = photo:getPropertyForPlugin (_PLUGIN, "Frame_Index", nil, true)
            if frameIndex then
                applyFilmShotsMetadataToPhoto (catalog, photo, frameIndex)
            else
                LrDialogs.message ("You need to set 'Frame Index' metadata property in 'Film Shots Metadata' section first")
            end
        else
            LrDialogs.message ("You need to select a photo first")
        end
    else
        LrDialogs.message ("You need to select a catalog first")
    end
end

LrFunctionContext.postAsyncTaskWithContext ("applyFilmShotsMetadata", function (context)
     applyFilmShotsMetadata ()
end)
