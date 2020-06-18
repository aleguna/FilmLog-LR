local LrFunctionContext = import 'LrFunctionContext'
local LrDialogs = import 'LrDialogs'
local LrApplication = import 'LrApplication'
local LrTasks = import 'LrTasks'
local LrPathUtils = import 'LrPathUtils'
local LrFileUtils = import 'LrFileUtils'

local FilmShotsMetadata = require 'FilmShotsMetadata.lua'
local json = require 'json.lua'
require 'log.lua'

local function readFile (path)
    local str = nil

    local file = io.open (path)
    if file then
        str = file:read("*all")
        file:close ()
    end

    return str;
end

local function saveMetadata (photo, rollData, frameData)
    local meta = FilmShotsMetadata.make (photo)

    meta:setRoll_UID (nil)
    meta:setRoll_Name (rollData.name)
    meta:setRoll_Mode (rollData.mode)
    meta:setRoll_Status (rollData.status)
    meta:setRoll_Comment (rollData.comment)
    meta:setRoll_Thumbnail (nil)
    meta:setRoll_CreationTimeUnix (rollData.timestamp)
    meta:setRoll_CameraName (rollData.cameraName)
    meta:setRoll_FormatName (rollData.formatName)
    
    meta:setFrame_LocalTimeIso8601 (frameData.localTime)
    meta:setFrame_Thumbnail (nil)
    meta:setFrame_Latitude (tostring (frameData.latitude))
    meta:setFrame_Longitude (tostring (frameData.longitude))
    meta:setFrame_Locality (frameData.locality)
    meta:setFrame_Comment (frameData.comment)
    meta:setFrame_EmulsionName (frameData.emulsionName)
    meta:setFrame_BoxISO (tostring (frameData.boxIsoSpeed))
    meta:setFrame_RatedISO (tostring (frameData.ratedIsoSpeed))
    meta:setFrame_LensName (frameData.lensName)
    meta:setFrame_FocalLength (tostring (frameData.focalLength))
    meta:setFrame_FStop (tostring (frameData.aperture))
    meta:setFrame_Shutter (frameData.shutterSpeed)

end

local function findFrame (rollData, frameIndex)
    for _, frame in ipairs (rollData.frames) do
        if frame.frameIndex == frameIndex then
            return frame
        end
    end
    return nil
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
                if filmShotsMetadata and #filmShotsMetadata == 1 then
                    local frameData = findFrame (filmShotsMetadata[1], tonumber (frameIndex))
                    if frameData then
                        catalog:withPrivateWriteAccessDo (function (context)
                            saveMetadata (photo, filmShotsMetadata[1], frameData)
                        end)
                    else
                        LrDialogs.message ("Couldn't find frame with index ".. frameIndex) 
                    end
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
