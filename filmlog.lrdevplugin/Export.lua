local LrPathUtils = import 'LrPathUtils'
local LrTasks = import 'LrTasks'

require 'Use'

local FilmShotsMetadata = use 'leaf500.FilmShotsMetadata'
local exiftool = use 'leaf500.ExiftoolBuilder'
local DefaultMetadataMap = use 'leaf500.DefaultMetadataMap'
local ExportDialogSection = use 'leaf500.ExportDialogSection'

local function postProcessRenderedPhotos (functionContext, filterContext)
    local builder = exiftool.make (DefaultMetadataMap)

	for sourceRendition, renditionToSatisfy in filterContext:renditions( renditionOptions ) do
		-- Wait for the upstream task to finish its work on this photo.
		
		local success, pathOrError = sourceRendition:waitForRender()
		
		if success then
			-- Now that the photo is completed and available to this filter, you can do your work on the photo here.
			-- In this example, the renditions are passed to an external application that updates the Creator metadata
            -- with the entry added in the export dialog section.

            local command = builder:buildCommand (
                sourceRendition.destinationPath,
                FilmShotsMetadata.make (sourceRendition.photo)
            )

			if LrTasks.execute (command) ~= 0 then
				renditionToSatisfy:renditionIsDone( false, "Failed to execute Exiftool" )
			end
        else
            --log.tracef ("waitForRender: %s", pathOrError)
		end
	
	end
end

local function sectionForFilterInDialog (f, propertyTable )
    return ExportDialogSection.make (f, propertyTable)
end

return {
    postProcessRenderedPhotos = postProcessRenderedPhotos,
	--exportPresetFields = exportPresetFields,
	sectionForFilterInDialog = sectionForFilterInDialog,
}