LUAC = "sdk/Lua Compiler/mac/luac"

LUA_FILES = ApplyFilmShotsMetadata.lua \
	ExportWriteFilmShotsMetadata.lua \
	FilmShotsMetadata.lua \
	FilmShotsMetadataDefinition.lua \
	FilmShotsMetadataTagset.lua \
	Info.lua \
	import.lua \
	json.lua \
	log.lua

filmlog.lrplugin.zip : ${LUA_FILES}
	cp -r filmlog.lrdevplugin/exiftool filmlog.lrplugin
	zip -r filmlog.lrplugin.zip filmlog.lrplugin

${LUA_FILES}: %.lua : filmlog.lrdevplugin/%.lua
	${LUAC} -o filmlog.lrplugin/$@ $<

