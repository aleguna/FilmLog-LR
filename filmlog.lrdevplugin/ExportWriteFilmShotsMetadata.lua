local LrPathUtils = import 'LrPathUtils'
local LrTasks = import 'LrTasks'

local FilmShotsMetadata = require 'FilmShotsMetadata.lua'
local exiftool = require 'ExiftoolInterface'

--require 'log.lua'

local function postProcessRenderedPhotos (functionContext, filterContext)
    local exiftoolPath = LrPathUtils.child(_PLUGIN.path, "exiftool/macos/exiftool" )
    if WIN_ENV == true then
        exiftoolPath = LrPathUtils.child(_PLUGIN.path, "exiftool/windows/exiftool.exe" )
    end
    --og:tracef ("exiftool: %s", exiftoolPath)
	
	for sourceRendition, renditionToSatisfy in filterContext:renditions( renditionOptions ) do
		-- Wait for the upstream task to finish its work on this photo.
		
		local success, pathOrError = sourceRendition:waitForRender()
		
		if success then
			-- Now that the photo is completed and available to this filter, you can do your work on the photo here.
			-- In this example, the renditions are passed to an external application that updates the Creator metadata
            -- with the entry added in the export dialog section.

            exiftoolPath = "\""..exiftoolPath.."\""
            local command = exiftool.buildCommand (
                exiftoolPath,
                sourceRendition.destinationPath,
                FilmShotsMetadata.make (sourceRendition.photo)
            )
            if WIN_ENV == true then
                command = "\"" .. command .. "\""
            end
            --log:tracef ("command: %s", command)

			if LrTasks.execute (command) ~= 0 then
				renditionToSatisfy:renditionIsDone( false, "Failed to execute Exiftool" )
			end
        else
            --log.tracef ("waitForRender: %s", pathOrError)
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

    for _, pair in ipairs (exiftool.MetadataMap) do
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