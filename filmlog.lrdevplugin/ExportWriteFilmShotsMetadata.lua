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

local MetadataMap = {

 Title = "Roll_Name",
 Caption = "Frame_Locality",
 UserComment = "Frame_Comment",

 Make = "Frame_EmulsionName",
 Model = "Roll_CameraName",

 DateTime = "Frame_LocalTime",
 DateTimeOriginal = "Frame_LocalTime",

 GPSLatitude = "Frame_Latitude",
 GPSLongitude = "Frame_Longitude",

 ISO = "Frame_EffectiveISO",

 LensModel = "Frame_LensName",
 Lens = "Frame_LensName",

 FocalLength = "Frame_FocalLength",
 FNumber = "Frame_FStop",
 ApertureValue = "Frame_FStop",
 ExposureTime = "Frame_Shutter",
 ShutterSpeedValue = "Frame_Shutter",    
}

local function buildExiftoolCommand (exiftoolPath, photoPath, photo)
    local meta = FilmShotsMetadata.make (photo)

    log:tracef ("buildExiftoolCommand: %s / %s ", exiftoolPath, photoPath)

    local command = exiftoolPath

    for key,val in pairs (MetadataMap) do
        command = addExifKey (command, key, meta[val](meta))
    end

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