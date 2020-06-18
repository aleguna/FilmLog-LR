local LrPathUtils = import 'LrPathUtils'
local LrTasks = import 'LrTasks'

local FilmShotsMetadata = require 'FilmShotsMetadata.lua'
require 'log.lua'

local function addExifKey (command, key, val)
    log:tracef ("addExifKey: %s = %s", key, val)
    if val then 
        return string.format ("%s -%s=\"%s\"", command, key, val)
    end

    return command
end

local function buildExiftoolCommand (exiftoolPath, photoPath, photo)
    local meta = FilmShotsMetadata.make (photo)

    log:tracef ("buildExiftoolCommand: %s / %s ", exiftoolPath, photoPath)

    local command = exiftoolPath

    --meta.Roll_UID
    --command = addExifKey (command, "", meta.Roll_Name)
    --meta.Roll_Mode
    --meta.Roll_Status
    --command = addExifKey (command, "", meta.Roll_Comment)
    --command = addExifKey (command, "", meta.Roll_Thumbnail)
    --command = addExifKey (command, "", meta.Roll_CreationTimeUnix)
    command = addExifKey (command, "Model", meta:Roll_CameraName())
    --command = addExifKey (command, "", meta.Roll_FormatName)
    
    --command = addExifKey (command, "", meta.Frame_LocalTimeIso8601)
    --command = addExifKey (command, "", meta.Frame_Thumbnail)
    --command = addExifKey (command, "", meta.Frame_Latitude)
    --command = addExifKey (command, "", meta.Frame_Longitude)
    --command = addExifKey (command, "", meta.Frame_Locality)
    --command = addExifKey (command, "", meta.Frame_Comment)
    command = addExifKey (command, "Make", meta:Frame_EmulsionName())
    --command = addExifKey (command, "", meta.Frame_BoxISO)
    --command = addExifKey (command, "", meta.Frame_RatedISO)
    --command = addExifKey (command, "", meta.Frame_LensName)
    --command = addExifKey (command, "", meta.Frame_FocalLength)
    --command = addExifKey (command, "", meta.Frame_FStop)
    --command = addExifKey (command, "", meta.Frame_Shutter)

    command = command .. " -overwrite_original " .. photoPath

    return command
end

local function postProcessRenderedPhotos (functionContext, filterContext)
    local exiftoolPath = LrPathUtils.child(_PLUGIN.path, "exiftool/macos/exiftool" )
    if WIN_ENV == true then
        exiftoolPath = LrPathUtils.child(_PLUGIN.path, "exiftool/windows/exiftool.exe" )
    end
    log:tracef ("exiftool: %s", exiftoolPath)
	
	for sourceRendition, renditionToSatisfy in filterContext:renditions( renditionOptions ) do
		-- Wait for the upstream task to finish its work on this photo.
		
		local success, pathOrError = sourceRendition:waitForRender()
		
		if success then
			-- Now that the photo is completed and available to this filter, you can do your work on the photo here.
			-- In this example, the renditions are passed to an external application that updates the Creator metadata
            -- with the entry added in the export dialog section.

            local command = buildExiftoolCommand (exiftoolPath, sourceRendition.destinationPath, sourceRendition.photo)
            log:tracef ("command: %s", command)

			if LrTasks.execute (command) ~= 0 then
				renditionToSatisfy:renditionIsDone( false, "Failed to execute Exiftool" )
			end
        else
            log.tracef ("waitForRender: %s", pathOrError)
		end
	
	end
end

local function sectionForFilterInDialog (f, propertyTable )
	return {
		title = "Film Shots Metadata",
		f:row {
			spacing = f:control_spacing(),
			f:static_text {
				title = "Hello",
				fill_horizontal = 1,
            },
        }
    }
end

return {
    postProcessRenderedPhotos = postProcessRenderedPhotos,
	--exportPresetFields = exportPresetFields,
	sectionForFilterInDialog = sectionForFilterInDialog,
}