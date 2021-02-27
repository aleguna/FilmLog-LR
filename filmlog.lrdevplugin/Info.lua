return {

	LrSdkVersion = 9.0,
	LrSdkMinimumVersion = 2.0,
	LrToolkitIdentifier = 'com.leaf500.filmlog.plugin.lr',

	LrPluginName = "Film Shots",
	LrPluginInfoUrl = "http://www.leaf500.com",
	
	-- Add the Metadata Definition File
	LrMetadataProvider = 'MetadataDefinition.lua',
	
	-- Add the Metadata Tagset File
	LrMetadataTagsetFactory = {
		'MetadataTagset.lua',
		--'AllMetadataTagset.lua',
	},

    LrLibraryMenuItems = {
		{
			title = 'Import Film Shots Metadata ...',
			file = 'Import.lua',
			enabledWhen = 'photosAvailable',
		},
	},
	
	LrExportFilterProvider = {
		{
			title = "Write Film Shots Data",
			file = "Export.lua",
			id = "export",
		},
	},
	
	-- Add the entry for the Plug-in Manager Dialog
	--LrPluginInfoProvider = 'PluginInfoProvider.lua',
	
	VERSION = { major=1, minor=0, revision=0},

}
