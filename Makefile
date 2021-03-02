LUAC ?= luac5.1
LUA ?= lua5.1
DELIVERY_DIR ?= ./delivery

DEV_PLUGIN = filmlog.lrdevplugin
REL_PLUGIN = filmlog.lrplugin

INFO_FILE = ${DEV_PLUGIN}/Info.lua

TVERSION = $(shell ${LUA} ${INFO_FILE} --version-table)
SVERSION = $(shell ${LUA} ${INFO_FILE} --version)

TVERISON_NEXT_BUILD = $(shell ${LUA} ${DEV_PLUGIN}/Info.lua --next-build)

LUA_SOURCES = $(shell find ${DEV_PLUGIN} -name *.lua)
LUA_OBJECTS  := $(LUA_SOURCES:$(DEV_PLUGIN)/%.lua=$(DELIVERY_DIR)/$(REL_PLUGIN)/%.lua)

LUA_TEST_DIR = test
LUA_TESTS = $(shell find ${LUA_TEST_DIR} -name Test*.lua)

LUA_TEST_PATH = "./${DEV_PLUGIN}/?.lua;./test/?.lua;;"
LUA_TEST_ENV = "_G.use=require"

DELIVERY_ARCHIVE = ${REL_PLUGIN}-v${SVERSION}.zip
DELIVERY_ARCHIVE_PATH = ${DELIVERY_DIR}/${DELIVERY_ARCHIVE}

.PHONY:
bump_build:
	@sed -i~ "s|${TVERSION}|${TVERISON_NEXT_BUILD}|" ${INFO_FILE}

.PHONY: sversion
sversion:
	@echo ${SVERSION}

deliver : ${DELIVERY_ARCHIVE_PATH} 	
	@echo ALL DONE

${DELIVERY_ARCHIVE_PATH}: ${DELIVERY_DIR}/${REL_PLUGIN} \
		${DELIVERY_DIR}/${REL_PLUGIN}/Config.txt \
		${DELIVERY_DIR}/${REL_PLUGIN}/exiftool \
		${DELIVERY_DIR}/${REL_PLUGIN}/LICENSE \
		$(LUA_OBJECTS)
	rm -f ${DELIVERY_ARCHIVE_PATH}
	cd ${DELIVERY_DIR} && zip -r ${DELIVERY_ARCHIVE} ${REL_PLUGIN}
	rm -rf ${DELIVERY_DIR}/${REL_PLUGIN}

.PHONY: ${DELIVERY_DIR}/${REL_PLUGIN}
${DELIVERY_DIR}/${REL_PLUGIN}:
	rm -rf ${DELIVERY_DIR}/${REL_PLUGIN}
	mkdir -p ${DELIVERY_DIR}/${REL_PLUGIN}

${DELIVERY_DIR}/${REL_PLUGIN}/Config.txt:
	cp ${DEV_PLUGIN}/Config.txt ${DELIVERY_DIR}/${REL_PLUGIN}

.PHONY: ${DELIVERY_DIR}/${REL_PLUGIN}/exiftool
${DELIVERY_DIR}/${REL_PLUGIN}/exiftool:
	cp -r ${DEV_PLUGIN}/exiftool ${DELIVERY_DIR}/${REL_PLUGIN}

${DELIVERY_DIR}/${REL_PLUGIN}/LICENSE:
	cp LICENSE ${DELIVERY_DIR}/${REL_PLUGIN}

$(LUA_OBJECTS) : $(DELIVERY_DIR)/$(REL_PLUGIN)/%.lua : $(DEV_PLUGIN)/%.lua
	mkdir -p $(shell dirname $@)
	${LUAC} -o $@ $<

.PHONY: test
test: $(LUA_TESTS)
	@echo "ALL TEST PASS"

.PHONY: $(LUA_TESTS)
$(LUA_TESTS):
	@echo Test: $@
	@LUA_PATH=${LUA_TEST_PATH} ${LUA} -e "${LUA_TEST_ENV}" $@ -o TAP
	
		
