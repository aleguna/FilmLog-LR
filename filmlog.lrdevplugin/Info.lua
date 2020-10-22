

return {

	LrSdkVersion = 9.0,
	LrSdkMinimumVersion = 2.0,
	LrToolkitIdentifier = 'com.leaf500.filmlog.plugin.lr',

	LrPluginName = "Film Shots",
	LrPluginInfoUrl = "http://www.leaf500.com",
	
	-- Add the Metadata Definition File
	LrMetadataProvider = 'FilmShotsMetadataDefinition.lua',
	
	-- Add the Metadata Tagset File
	LrMetadataTagsetFactory = {
		'FilmShotsMetadataTagset.lua',
		--'AllMetadataTagset.lua',
	},

    LrLibraryMenuItems = {
        title = 'Apply Film Shots Metadata',
        file = 'ApplyFilmShotsMetadata.lua',
        enabledWhen = 'photosAvailable',
	},
	
	LrExportFilterProvider = {
		{
			title = "Write Film Shots Data",
			file = "ExportWriteFilmShotsMetadata.lua",
			id = "export",
		},
	},
	
	-- Add the entry for the Plug-in Manager Dialog
	--LrPluginInfoProvider = 'PluginInfoProvider.lua',
	
	VERSION = { major=0, minor=4, revision=0},

}
