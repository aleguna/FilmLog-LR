LUAC = "sdk/Lua Compiler/mac/luac"
LUA = "lua5.1"

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

LUA_TEST_PATH="./filmlog.lrdevplugin/?.lua;./test/?.lua;;"
LUA_TEST_ENV="_G.use=require"

.PHONY: test
test:
	@for f in $(shell ls test/*.lua); do	\
		echo Test: $${f}			;		\
		LUA_PATH=${LUA_TEST_PATH} ${LUA} -e "${LUA_TEST_ENV}" $${f} -o TAP || exit 1 				\
	; done
	@echo "ALL TEST PASS"
		
