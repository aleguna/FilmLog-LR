local LrPathUtils = import 'LrPathUtils'
local LrTasks = import 'LrTasks'

require 'Use'
local log = require 'Logger' ('export')

local FilmShotsMetadata = use 'leaf500.FilmShotsMetadata'
local exiftool = use 'leaf500.ExiftoolBuilder'
local DefaultMetadataMap = use 'leaf500.DefaultMetadataMap'
local ExportDialogSection = use 'leaf500.ExportDialogSection'

local function postProcessRenderedPhotos (functionContext, filterContext)
	log ('postProcessRenderedPhotos')

    local builder = exiftool.make (DefaultMetadataMap)

	log ('renditions')
	for sourceRendition, renditionToSatisfy in filterContext:renditions( renditionOptions ) do
		-- Wait for the upstream task to finish its work on this photo.
		
		log ('Wait: ', sourceRendition.photo.localIdentifier)
		local success, pathOrError = sourceRendition:waitForRender()
		
		if success then
			-- Now that the photo is completed and available to this filter, you can do your work on the photo here.
			-- In this example, the renditions are passed to an external application that updates the Creator metadata
            -- with the entry added in the export dialog section.

			log ('Write: ', pathOrError)

            local command = builder:buildCommand (
                sourceRendition.destinationPath,
                FilmShotsMetadata.make (sourceRendition.photo)
            )

			local exiftoolResult = LrTasks.execute (command)
			if  exiftoolResult ~= 0 then
				log ('Exiftool: ret: ', exiftoolResult)
				renditionToSatisfy:renditionIsDone( false, "Failed to execute Exiftool" )
			else
				log  ('Exiftool: OK')
			end
        else
            log ("waitForRender: error: ", pathOrError)
		end	
	end
	log ("DONE")
end

local function sectionForFilterInDialog (f, propertyTable )
	log ('sectionForFilterInDialog')
    return ExportDialogSection.make (f, propertyTable)
end

return {
    postProcessRenderedPhotos = postProcessRenderedPhotos,
	--exportPresetFields = exportPresetFields,
	sectionForFilterInDialog = sectionForFilterInDialog,
}