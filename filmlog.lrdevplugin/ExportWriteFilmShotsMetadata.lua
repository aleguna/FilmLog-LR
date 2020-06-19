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

    {key = "Title", val = "Roll_Name"},
    {key = "Caption", val = "Frame_Locality"},
    {key = "UserComment", val = "Frame_Comment"},
    {key = "Make", val = "Frame_EmulsionName"},
    {key = "Model", val = "Roll_CameraName"},
    {key = "DateTime", val = "Frame_LocalTime"},
    {key = "DateTimeOriginal", val = "Frame_LocalTime"},
    {key = "GPSLatitude", val = "Frame_Latitude"},
    {key = "GPSLongitude", val = "Frame_Longitude"},
    {key = "ISO", val = "Frame_EffectiveISO"},
    {key = "LensModel", val = "Frame_LensName"},
    {key = "Lens", val = "Frame_LensName"},
    {key = "FocalLength", val = "Frame_FocalLength"},
    {key = "FNumber", val = "Frame_FStop"},
    {key = "ApertureValue", val = "Frame_FStop"},
    {key = "ExposureTime", val = "Frame_Shutter"},
    {key = "ShutterSpeedValue", val = "Frame_Shutter"},    
}

local function buildExiftoolCommand (exiftoolPath, photoPath, photo)
    local meta = FilmShotsMetadata.make (photo)

    log:tracef ("buildExiftoolCommand: %s / %s ", exiftoolPath, photoPath)

    local command = exiftoolPath

    for _, pair in ipairs (MetadataMap) do
        command = addExifKey (command, pair.key, meta[pair.val](meta))
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

    local column = {
        spacing = f:control_spacing(),
        f:row {
			spacing = f:control_spacing(),
			f:static_text {
                title = "Update tags:",
                font = "<system/bold>",
				fill_horizontal = 1,
            },
        }
    }

    for _, pair in ipairs (MetadataMap) do
        table.insert (column,  f:row {
			spacing = f:control_spacing(),
			f:static_text {
				title = pair.key,
				fill_horizontal = 1,
            },
            f:static_text {
                title = "to",
                font = "<system/bold>",
            },
            f:static_text {
				title = pair.val,
				fill_horizontal = 1,
            },
        })
    end

	return {
        title = "Film Shots Metadata",
        f:column (column)
    }
end

return {
    postProcessRenderedPhotos = postProcessRenderedPhotos,
	--exportPresetFields = exportPresetFields,
	sectionForFilterInDialog = sectionForFilterInDialog,
}