local LrTasks = import 'LrTasks'

require 'Use'

local log = require 'Logger' ('export')

local DefaultMetadataMap = use 'leaf500.DefaultMetadataMap'
local ExportDialogSection = use 'leaf500.ExportDialogSection'
local ExportRender = use 'leaf500.ExportRender'

local function postProcessRenderedPhotos (functionContext, filterContext)
	log ('postProcessRenderedPhotos')
	ExportRender.render (filterContext:renditions (), DefaultMetadataMap, LrTasks)
	log ("DONE")
end

local function sectionForFilterInDialog (f, propertyTable )
	log ('sectionForFilterInDialog')
	return {
        title = "Film Shots Metadata",
    	ExportDialogSection.build (f, propertyTable)
    }
end

return {
    postProcessRenderedPhotos = postProcessRenderedPhotos,
	--exportPresetFields = exportPresetFields,
	sectionForFilterInDialog = sectionForFilterInDialog,
}