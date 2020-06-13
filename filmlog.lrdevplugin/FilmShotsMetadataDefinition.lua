return {
    metadataFieldsForPhotos = {
        {
            id = 'Locality',
            title = "Locality",
            dataType = 'string', -- Specifies the data type for this field.
            browsable = true,
            searchable = true,
        },
    },

    schemaVersion = 1,
	
    updateFromEarlierSchemaVersion = function( catalog, previousSchemaVersion )
    end,
}