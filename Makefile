PREFIX = ~/games/nostalrius/Interface/AddOns
VERSION = $(shell git rev-parse --abbrev-ref HEAD)
LANG = enGB

all: clean addon install

clean: 
	rm -rf build

addon:
	# create directories
	install -d build/enGB/ShaguQuest/db
	install -d build/deMIX/ShaguQuest/db
	install -d build/deDE/ShaguQuest/db
	install -d release

	# install Cartographer
	cp -rf resources/Cartographer build/deDE
	cp -rf resources/Cartographer build/deMIX
	cp -rf resources/Cartographer build/enGB

	# install EQL3
	cp -rf resources/EQL3 build/deDE
	cp -rf resources/EQL3 build/deMIX
	cp -rf resources/EQL3 build/enGB

	# patch deDE cartographer
	cd build/deDE && patch -s -p 1 < ../../resources/Cartographer_deDE.patch
	cd build/deMIX && patch -s -p 1 < ../../resources/Cartographer_deDE.patch

	# copy language specific databases
	# deDE
	cp resources/zoneData.lua_deDE build/deDE/ShaguQuest/db/zoneData.lua
	cp resources/spawnData.lua_deDE build/deDE/ShaguQuest/db/spawnData.lua
	cp resources/itemData.lua_deDE build/deDE/ShaguQuest/db/itemData.lua
	cp resources/questData.lua_deDE build/deDE/ShaguQuest/db/questData.lua
	cp resources/vendorData.lua_deDE build/deDE/ShaguQuest/db/vendorData.lua

	# enGB
	cp resources/zoneData.lua_enGB build/enGB/ShaguQuest/db/zoneData.lua
	cp resources/spawnData.lua_enGB build/enGB/ShaguQuest/db/spawnData.lua
	cp resources/itemData.lua_enGB build/enGB/ShaguQuest/db/itemData.lua
	cp resources/questData.lua_enGB build/enGB/ShaguQuest/db/questData.lua
	cp resources/vendorData.lua_enGB build/enGB/ShaguQuest/db/vendorData.lua

	# deMIX
	cp resources/zoneData.lua_deDE build/deMIX/ShaguQuest/db/zoneData.lua
	cp resources/spawnData.lua_enGB build/deMIX/ShaguQuest/db/spawnData.lua
	cp resources/itemData.lua_enGB build/deMIX/ShaguQuest/db/itemData.lua
	cp resources/questData.lua_enGB build/deMIX/ShaguQuest/db/questData.lua
	cp resources/vendorData.lua_enGB build/deMIX/ShaguQuest/db/vendorData.lua

	# install default files
	cp -rf resources/symbols ShaguQuest*.lua ShaguQuest.toc ShaguQuest*.xml build/deDE/ShaguQuest
	cp -rf resources/symbols ShaguQuest*.lua ShaguQuest.toc ShaguQuest*.xml build/enGB/ShaguQuest
	cp -rf resources/symbols ShaguQuest*.lua ShaguQuest.toc ShaguQuest*.xml build/deMIX/ShaguQuest

	# replace veresion string
	sed -i "s/oooVersionooo/$(VERSION)/g" build/deDE/ShaguQuest/ShaguQuest.*
	sed -i "s/oooVersionooo/$(VERSION)/g" build/enGB/ShaguQuest/ShaguQuest.*
	sed -i "s/oooVersionooo/$(VERSION)/g" build/deMIX/ShaguQuest/ShaguQuest.*

	# replace locale string
	sed -i "s/oooLocaleooo/deDE/g" build/deDE/ShaguQuest/ShaguQuest.*
	sed -i "s/oooLocaleooo/enGB/g" build/enGB/ShaguQuest/ShaguQuest.*
	sed -i "s/oooLocaleooo/enGB/g" build/deMIX/ShaguQuest/ShaguQuest.*

install:
	# remove deprecated addon
	install -d $(PREFIX)
	rm -rf $(PREFIX)/ShaguQuest
	rm -rf $(PREFIX)/Cartographer
	rm -rf $(PREFIX)/EQL3

	# install new addon
	cp -rf ./build/enGB/* $(PREFIX)

zip:
	# building release zip"
	cd build/deDE && zip -qr9 ../../release/ShaguQuest-$(VERSION)-deDE-complete.zip *
	cd build/enGB && zip -qr9 ../../release/ShaguQuest-$(VERSION)-enGB-complete.zip *
	cd build/deMIX && zip -qr9 ../../release/ShaguQuest-$(VERSION)-deMIX-complete.zip *

