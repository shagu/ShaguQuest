VERSION = $(shell git rev-parse --abbrev-ref HEAD)
BUILD_DIR = $(shell pwd)/build
all: clean enGB koKR frFR deDE zhCN esES ruRU

clean:
	rm -rf build

db:
	cd ./database && php ./itemDB.php
	cd ./database && php ./questDB.php
	cd ./database && php ./vendorDB.php
	cd ./database && php ./spawnDB.php
	cd ./database && php ./zoneDB.php

enGB koKR frFR deDE zhCN esES ruRU:
	# create dir
	install -d release

	# build enGB
	install -d build/$@/ShaguDB/db
	cp -rf resources/Cartographer build/$@
	cp -rf resources/ShaguQuest build/$@
	cp resources/zoneDB.lua_$@ build/$@/ShaguDB/db/zoneDB.lua
	cp resources/spawnDB.lua_$@ build/$@/ShaguDB/db/spawnDB.lua
	cp resources/itemDB.lua_$@ build/$@/ShaguDB/db/itemDB.lua
	cp resources/questDB.lua_$@ build/$@/ShaguDB/db/questDB.lua
	cp resources/vendorDB.lua_$@ build/$@/ShaguDB/db/vendorDB.lua
	cp -rf resources/img resources/symbols ShaguDB*.lua ShaguDB.toc build/$@/ShaguDB
	sed -i "s/oooVersionooo/$(VERSION)/g" build/$@/ShaguDB/ShaguDB*
	sed -i "s/oooLocaleooo/$@/g" build/$@/ShaguDB/ShaguDB*
	cd build/$@ && zip -qr9 ../../release/ShaguDB-$(VERSION)-$@-complete.zip *

	# symlink to test environment
	install -d ~/games/wow-locales/WoW-1.12.1-$@/Interface/AddOns

	rm -rf ~/games/wow-locales/WoW-1.12.1-$@/Interface/AddOns/ShaguDB
	rm -rf ~/games/wow-locales/WoW-1.12.1-$@/Interface/AddOns/ShaguQuest
	rm -rf ~/games/wow-locales/WoW-1.12.1-$@/Interface/AddOns/Cartographer

	ln -sf $(BUILD_DIR)/$@/ShaguDB ~/games/wow-locales/WoW-1.12.1-$@/Interface/AddOns/ShaguDB
	ln -sf $(BUILD_DIR)/$@/ShaguQuest ~/games/wow-locales/WoW-1.12.1-$@/Interface/AddOns/ShaguQuest
	ln -sf $(BUILD_DIR)/$@/Cartographer ~/games/wow-locales/WoW-1.12.1-$@/Interface/AddOns/Cartographer
