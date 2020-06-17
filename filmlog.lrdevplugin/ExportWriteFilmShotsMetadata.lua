
local function buildExiftoolCommand (exiftoolPath, photoPath, photo)
    photo:getPropertyForPlugin (_PLUGIN, "Roll_UID")
    photo:getPropertyForPlugin (_PLUGIN, "Roll_Name")
    photo:getPropertyForPlugin (_PLUGIN, "Roll_Mode")
    photo:getPropertyForPlugin (_PLUGIN, "Roll_Status")
    photo:getPropertyForPlugin (_PLUGIN, "Roll_Comment")
    photo:getPropertyForPlugin (_PLUGIN, "Roll_Thumbnail")
    photo:getPropertyForPlugin (_PLUGIN, "Roll_CreationTimeUnix")
    photo:getPropertyForPlugin (_PLUGIN, "Roll_CameraName")
    photo:getPropertyForPlugin (_PLUGIN, "Roll_FormatName")
    
    photo:getPropertyForPlugin (_PLUGIN, "Frame_LocalTimeIso8601")
    photo:getPropertyForPlugin (_PLUGIN, "Frame_Thumbnail")
    photo:getPropertyForPlugin (_PLUGIN, "Frame_Latitude")
    photo:getPropertyForPlugin (_PLUGIN, "Frame_Longitude")
    photo:getPropertyForPlugin (_PLUGIN, "Frame_Locality")
    photo:getPropertyForPlugin (_PLUGIN, "Frame_Comment")
    photo:getPropertyForPlugin (_PLUGIN, "Frame_EmulsionName")
    photo:getPropertyForPlugin (_PLUGIN, "Frame_BoxISO")
    photo:getPropertyForPlugin (_PLUGIN, "Frame_RatedISO")
    photo:getPropertyForPlugin (_PLUGIN, "Frame_LensName")
    photo:getPropertyForPlugin (_PLUGIN, "Frame_FocalLength")
    photo:getPropertyForPlugin (_PLUGIN, "Frame_FStop")
    photo:getPropertyForPlugin (_PLUGIN, "Frame_Shutter")
end

local function postProcessRenderedPhotos (functionContext, filterContext)
    local exiftoolPath = LrPathUtils.child(_PLUGIN.path, "exiftool/macos/exiftool" )
    if WIN_ENV == true then
        exiftoolPath = LrPathUtils.child(_PLUGIN.path, "exiftool/windows/exiftool.exe" )
    end
	
	for sourceRendition, renditionToSatisfy in filterContext:renditions( renditionOptions ) do
		-- Wait for the upstream task to finish its work on this photo.
		
		local success, _ = sourceRendition:waitForRender()
		
		if success then
			-- Now that the photo is completed and available to this filter, you can do your work on the photo here.
			-- In this example, the renditions are passed to an external application that updates the Creator metadata
            -- with the entry added in the export dialog section.

            local command = buildExiftoolCommand (exiftoolPath, sourceRendition.destinationPath, sourceRendition.photo)
			if LrTasks.execute (command) ~= 0 then
				renditionToSatisfy:renditionIsDone( false, "Failed to execute Exiftool" )
			end
		
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