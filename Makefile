PREFIX = ~/games/nostalrius/Interface/AddOns
PREFIX2 = ~/games/classic\ wow/Interface/AddOns
VERSION = $(shell git rev-parse --abbrev-ref HEAD)
LANG = enGB

all: clean addon install

clean: 
	rm -rf build

db:
	cd ./database && php ./itemDB.php deDE
	cd ./database && php ./itemDB.php enGB

	cd ./database && php ./questDB.php deDE
	cd ./database && php ./questDB.php enGB

	cd ./database && php ./vendorDB.php deDE
	cd ./database && php ./vendorDB.php enGB

	cd ./database && php ./spawnDB.php deDE
	cd ./database && php ./spawnDB.php enGB

addon:
	# create directories
	install -d build/enGB/ShaguDB/db
	install -d build/deMIX/ShaguDB/db
	install -d build/deDE/ShaguDB/db
	install -d release

	# install Cartographer
	cp -rf resources/Cartographer build/deDE
	cp -rf resources/Cartographer build/deMIX
	cp -rf resources/Cartographer build/enGB

	# install ShaguQuest
	cp -rf resources/ShaguQuest build/deDE
	cp -rf resources/ShaguQuest build/deMIX
	cp -rf resources/ShaguQuest build/enGB

	# copy language specific databases
	# deDE
	cp resources/zoneDB.lua_deDE build/deDE/ShaguDB/db/zoneDB.lua
	cp resources/spawnDB.lua_deDE build/deDE/ShaguDB/db/spawnDB.lua
	cp resources/itemDB.lua_deDE build/deDE/ShaguDB/db/itemDB.lua
	cp resources/questDB.lua_deDE build/deDE/ShaguDB/db/questDB.lua
	cp resources/vendorDB.lua_deDE build/deDE/ShaguDB/db/vendorDB.lua

	# enGB
	cp resources/zoneDB.lua_enGB build/enGB/ShaguDB/db/zoneDB.lua
	cp resources/spawnDB.lua_enGB build/enGB/ShaguDB/db/spawnDB.lua
	cp resources/itemDB.lua_enGB build/enGB/ShaguDB/db/itemDB.lua
	cp resources/questDB.lua_enGB build/enGB/ShaguDB/db/questDB.lua
	cp resources/vendorDB.lua_enGB build/enGB/ShaguDB/db/vendorDB.lua

	# deMIX
	cp resources/zoneDB.lua_deDE build/deMIX/ShaguDB/db/zoneDB.lua
	cp resources/spawnDB.lua_enGB build/deMIX/ShaguDB/db/spawnDB.lua
	cp resources/itemDB.lua_enGB build/deMIX/ShaguDB/db/itemDB.lua
	cp resources/questDB.lua_enGB build/deMIX/ShaguDB/db/questDB.lua
	cp resources/vendorDB.lua_enGB build/deMIX/ShaguDB/db/vendorDB.lua

	# install default files
	cp -rf resources/img resources/symbols ShaguDB*.lua ShaguDB.toc build/deDE/ShaguDB
	cp -rf resources/img resources/symbols ShaguDB*.lua ShaguDB.toc build/enGB/ShaguDB
	cp -rf resources/img resources/symbols ShaguDB*.lua ShaguDB.toc build/deMIX/ShaguDB

	# replace veresion string
	sed -i "s/oooVersionooo/$(VERSION)/g" build/deDE/ShaguDB/ShaguDB*
	sed -i "s/oooVersionooo/$(VERSION)/g" build/enGB/ShaguDB/ShaguDB*
	sed -i "s/oooVersionooo/$(VERSION)/g" build/deMIX/ShaguDB/ShaguDB*

	# replace locale string
	sed -i "s/oooLocaleooo/deDE/g" build/deDE/ShaguDB/ShaguDB*
	sed -i "s/oooLocaleooo/enGB/g" build/enGB/ShaguDB/ShaguDB*
	sed -i "s/oooLocaleooo/enGB/g" build/deMIX/ShaguDB/ShaguDB*

install:
	# remove deprecated addon
	install -d $(PREFIX)
	rm -rf $(PREFIX)/ShaguDB
	rm -rf $(PREFIX)/Cartographer
	rm -rf $(PREFIX)/ShaguQuest

	# install new addon
	cp -rf ./build/enGB/* $(PREFIX)
	
	# remove deprecated addon
	install -d $(PREFIX2)
	rm -rf $(PREFIX2)/ShaguDB
	rm -rf $(PREFIX2)/Cartographer
	rm -rf $(PREFIX2)/ShaguQuest

	# install new addon
	cp -rf ./build/deDE/* $(PREFIX2)


zip:
	# building complete zip
	cd build/deDE && zip -qr9 ../../release/ShaguDB-$(VERSION)-deDE-complete.zip *
	cd build/enGB && zip -qr9 ../../release/ShaguDB-$(VERSION)-enGB-complete.zip *
	cd build/deMIX && zip -qr9 ../../release/ShaguDB-$(VERSION)-deMIX-complete.zip *

	# building release zip
	cd build/deDE && zip -qr9 ../../release/ShaguDB-$(VERSION)-deDE.zip ShaguDB Cartographer
	cd build/enGB && zip -qr9 ../../release/ShaguDB-$(VERSION)-enGB.zip ShaguDB Cartographer
	cd build/deMIX && zip -qr9 ../../release/ShaguDB-$(VERSION)-deMIX.zip ShaguDB Cartographer

