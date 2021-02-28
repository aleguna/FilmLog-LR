LUAC ?= sdk/Lua\ Compiler/mac/luac
LUA ?= lua5.1
DELIVERY_DIR ?= ./delivery

DEV_PLUGIN = filmlog.lrdevplugin
REL_PLUGIN = filmlog.lrplugin
LUA_SOURCES = $(shell find ${DEV_PLUGIN} -name *.lua)
LUA_OBJECTS  := $(LUA_SOURCES:$(DEV_PLUGIN)/%.lua=$(DELIVERY_DIR)/$(REL_PLUGIN)/%.lua)

deliver : ${DELIVERY_DIR}/${REL_PLUGIN}.zip 	
	@echo ALL DONE

${DELIVERY_DIR}/${REL_PLUGIN}.zip: ${DELIVERY_DIR}/${REL_PLUGIN} \
		${DELIVERY_DIR}/${REL_PLUGIN}/Config.txt \
		${DELIVERY_DIR}/${REL_PLUGIN}/exiftool \
		${DELIVERY_DIR}/${REL_PLUGIN}/LICENSE \
		$(LUA_OBJECTS)
	rm -f ${DELIVERY_DIR}/${REL_PLUGIN}.zip
	cd ${DELIVERY_DIR} && zip -r ${REL_PLUGIN}.zip ${REL_PLUGIN}
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

LUA_TEST_PATH="./${DEV_PLUGIN}/?.lua;./test/?.lua;;"
LUA_TEST_ENV="_G.use=require"

.PHONY: test
test:
	@for f in $(shell ls test/*.lua); do	\
		echo Test: $${f}			;		\
		LUA_PATH=${LUA_TEST_PATH} ${LUA} -e "${LUA_TEST_ENV}" $${f} -o TAP || exit 1 				\
	; done
	@echo "ALL TEST PASS"
		
