LUAC = "sdk/Lua Compiler/mac/luac"
LUA = "/usr/local/bin/lua"

LUA_FILES = ApplyFilmShotsMetadata.lua \
	ExportWriteFilmShotsMetadata.lua \
	FilmShotsMetadata.lua \
	FilmShotsMetadataDefinition.lua \
	FilmShotsMetadataTagset.lua \
	ExiftoolInterface.lua \
	Info.lua \
	import.lua \
	dkjson.lua \
	log.lua

deliver : ${LUA_FILES}
	cp -r filmlog.lrdevplugin/exiftool filmlog.lrplugin
	cp LICENSE filmlog.lrplugin
	zip -r filmlog.lrplugin.zip filmlog.lrplugin

${LUA_FILES}: %.lua : filmlog.lrdevplugin/%.lua
	${LUAC} -o filmlog.lrplugin/$@ $<

.PHONY: test
test: 
	${LUA} test/TestExifToolExport.lua
	
