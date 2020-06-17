
local function postProcessRenderedPhotos (functionContext, filterContext)
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