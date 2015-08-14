#!/bin/bash

VERSION="4.2"

echo ":: cleaning up"
rm -rf build
mkdir -p build/enGB/ShaguQuest build/deDE/ShaguQuest build/deMIX/ShaguQuest release

echo ":: installing external addons"
cp -rf resources/Cartographer build/deDE
cp -rf resources/Cartographer build/deMIX
cp -rf resources/Cartographer build/enGB

cp -rf resources/EQL3 build/deDE
cp -rf resources/EQL3 build/deMIX
cp -rf resources/EQL3 build/enGB

# patch locales for german cartographer to avoid lua erros
cd build/deDE
patch -s -p 1 < ../../resources/Cartographer_deDE.patch
cd - >> /dev/null

cd build/deMIX
patch -s -p 1 < ../../resources/Cartographer_deDE.patch
cd - >> /dev/null

echo ":: building ShaguQuest"
# copy language specific zoneData
cp -rf resources/zoneData.lua_deDE build/deDE/ShaguQuest/zoneData.lua
cp resources/spawnData.lua_deDE build/deDE/ShaguQuest/spawnData.lua
cp resources/itemData.lua_deDE build/deDE/ShaguQuest/itemData.lua
cp resources/questData.lua_deDE build/deDE/ShaguQuest/questData.lua

cp -rf resources/zoneData.lua_enGB build/enGB/ShaguQuest/zoneData.lua
cp resources/spawnData.lua_enGB build/enGB/ShaguQuest/spawnData.lua
cp resources/itemData.lua_enGB build/enGB/ShaguQuest/itemData.lua
cp resources/questData.lua_enGB build/enGB/ShaguQuest/questData.lua

cp -rf resources/zoneData.lua_deDE build/deMIX/ShaguQuest/zoneData.lua
cp resources/spawnData.lua_enGB build/deMIX/ShaguQuest/spawnData.lua
cp resources/itemData.lua_enGB build/deMIX/ShaguQuest/itemData.lua
cp resources/questData.lua_enGB build/deMIX/ShaguQuest/questData.lua


# install default files
cp -rf resources/symbols ShaguQuest.lua ShaguQuest.toc ShaguQuest.xml build/deDE/ShaguQuest
cp -rf resources/symbols ShaguQuest.lua ShaguQuest.toc ShaguQuest.xml build/enGB/ShaguQuest
cp -rf resources/symbols ShaguQuest.lua ShaguQuest.toc ShaguQuest.xml build/deMIX/ShaguQuest

# replace veresion string
sed -i "s/oooVersionooo/$VERSION/g" build/deDE/ShaguQuest/ShaguQuest.*
sed -i "s/oooVersionooo/$VERSION/g" build/enGB/ShaguQuest/ShaguQuest.*
sed -i "s/oooVersionooo/$VERSION/g" build/deMIX/ShaguQuest/ShaguQuest.*

# replace locale string
sed -i "s/oooLocaleooo/deDE/g" build/deDE/ShaguQuest/ShaguQuest.*
sed -i "s/oooLocaleooo/enGB/g" build/enGB/ShaguQuest/ShaguQuest.*
sed -i "s/oooLocaleooo/enGB/g" build/deMIX/ShaguQuest/ShaguQuest.*

echo ":: building release zip"
echo "   - deDE"
cd build/deDE
zip -qr9 ../../release/ShaguQuest-$VERSION-deDE-complete.zip *
cd - >> /dev/null

echo "   - enGB"
cd build/enGB
zip -qr9 ../../release/ShaguQuest-$VERSION-enGB-complete.zip *
cd - >> /dev/null

echo "   - deMIX"
cd build/deMIX
zip -qr9 ../../release/ShaguQuest-$VERSION-deMIX-complete.zip *
cd - >> /dev/null
