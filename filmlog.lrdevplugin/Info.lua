

return {

	LrSdkVersion = 9.0,
	LrSdkMinimumVersion = 2.0,
	LrToolkitIdentifier = 'com.leaf500.filmlog.plugin.lr',

	LrPluginName = "Film Shots",
	LrPluginInfoUrl = "http://www.leaf500.com",
	
	-- Add the Metadata Definition File
	LrMetadataProvider = 'FilmShotsMetadataDefinition.lua',
	
	-- Add the Metadata Tagset File
	--LrMetadataTagsetFactory = {
	--	'CustomMetadataTagset.lua',
	--	'AllMetadataTagset.lua',
	--},

    LrLibraryMenuItems = {
        title = 'Import Film Shots Data',
        file = 'import.lua',
        enabledWhen = 'photosAvailable',
    }
	
	-- Add the entry for the Plug-in Manager Dialog
	--LrPluginInfoProvider = 'PluginInfoProvider.lua',
	
	--VERSION = { major=9, minor=1, revision=0, build="YYYYMMDDHHmm-abcs1234", },

}
