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

local function saveMetadata (photo, rollData, frameIndex)
    photo:setPropertyForPlugin (_PLUGIN, "Roll_UID", nil)
    photo:setPropertyForPlugin (_PLUGIN, "Roll_Name", rollData.name)
    photo:setPropertyForPlugin (_PLUGIN, "Roll_Mode", rollData.mode)
    photo:setPropertyForPlugin (_PLUGIN, "Roll_Status", rollData.status)
    photo:setPropertyForPlugin (_PLUGIN, "Roll_Comment", rollData.comment)
    photo:setPropertyForPlugin (_PLUGIN, "Roll_Thumbnail", nil)
    photo:setPropertyForPlugin (_PLUGIN, "Roll_CreationTimeUnix", rollData.timestamp)
    photo:setPropertyForPlugin (_PLUGIN, "Roll_CameraName", rollData.cameraName)
    photo:setPropertyForPlugin (_PLUGIN, "Roll_FormatName", rollData.formatName)
    
    photo:setPropertyForPlugin (_PLUGIN, "Frame_LocalTimeIso8601", rollData.frames[frameIndex].localTime)
    photo:setPropertyForPlugin (_PLUGIN, "Frame_Thumbnail", nil);
    photo:setPropertyForPlugin (_PLUGIN, "Frame_Latitude", tostring (rollData.frames[frameIndex].latitude))
    photo:setPropertyForPlugin (_PLUGIN, "Frame_Longitude", tostring (rollData.frames[frameIndex].longitude))
    photo:setPropertyForPlugin (_PLUGIN, "Frame_Locality", rollData.frames[frameIndex].locality)
    photo:setPropertyForPlugin (_PLUGIN, "Frame_Comment", rollData.frames[frameIndex].comment)
    photo:setPropertyForPlugin (_PLUGIN, "Frame_EmulsionName", rollData.frames[frameIndex].emulsionName)
    photo:setPropertyForPlugin (_PLUGIN, "Frame_BoxISO", tostring (rollData.frames[frameIndex].boxIsoSpeed))
    photo:setPropertyForPlugin (_PLUGIN, "Frame_RatedISO", tostring (rollData.frames[frameIndex].ratedIsoSpeed))
    photo:setPropertyForPlugin (_PLUGIN, "Frame_LensName", rollData.frames[frameIndex].lensName)
    photo:setPropertyForPlugin (_PLUGIN, "Frame_FocalLength", tostring (rollData.frames[frameIndex].focalLength))
    photo:setPropertyForPlugin (_PLUGIN, "Frame_FStop", tostring (rollData.frames[frameIndex].aperture))
    photo:setPropertyForPlugin (_PLUGIN, "Frame_Shutter", rollData.frames[frameIndex].shutterSpeed)

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
                        saveMetadata (photo, filmShotsMetadata[1], tonumber (frameIndex))
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
