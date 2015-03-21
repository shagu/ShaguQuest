#!/bin/bash

VERSION="3.2devel"

echo ":: cleaning up"
rm -rf build
mkdir -p build/enGB/ShaguQuest build/deDE/ShaguQuest build/frFR/ShaguQuest release

echo ":: installing external addons"
cp -rf resources/Cartographer build/enGB
cp -rf resources/Cartographer build/deDE
cp -rf resources/Cartographer build/frFR

cp -rf resources/EQL3 build/enGB
cp -rf resources/EQL3 build/deDE
cp -rf resources/EQL3 build/frFR

# patch locales for german cartographer to avoid lua erros
cd build/deDE
patch -s -p 1 < ../../resources/Cartographer_deDE.patch
cd - >> /dev/null

echo ":: building ShaguQuest"
# copy language specific zoneData
cp -rf resources/zoneData.lua_enGB build/enGB/ShaguQuest/zoneData.lua
cp -rf resources/zoneData.lua_deDE build/deDE/ShaguQuest/zoneData.lua
cp -rf resources/zoneData.lua_frFR build/frFR/ShaguQuest/zoneData.lua

# install default files
cp ShaguQuest.lua ShaguQuest.toc ShaguQuest.xml build/enGB/ShaguQuest
cp ShaguQuest.lua ShaguQuest.toc ShaguQuest.xml build/deDE/ShaguQuest
cp ShaguQuest.lua ShaguQuest.toc ShaguQuest.xml build/frFR/ShaguQuest

# replace veresion string
sed -i "s/oooVersionooo/$VERSION/g" build/enGB/ShaguQuest/ShaguQuest.*
sed -i "s/oooVersionooo/$VERSION/g" build/deDE/ShaguQuest/ShaguQuest.*
sed -i "s/oooVersionooo/$VERSION/g" build/frFR/ShaguQuest/ShaguQuest.*

# replace locale string
sed -i "s/oooLocaleooo/enGB/g" build/enGB/ShaguQuest/ShaguQuest.*
sed -i "s/oooLocaleooo/deDE/g" build/deDE/ShaguQuest/ShaguQuest.*
sed -i "s/oooLocaleooo/frFR/g" build/frFR/ShaguQuest/ShaguQuest.*

# build databases
echo -n "   - enGB database [ questData"
wget -q "http://localhost/shagudb/questData.php?enGB" -O build/enGB/ShaguQuest/questData.lua
echo -n ", itemData"
wget -q "http://localhost/shagudb/itemData.php?enGB" -O build/enGB/ShaguQuest/itemData.lua
echo -n ", spawnData"
wget -q "http://localhost/shagudb/spawnData.php?enGB" -O build/enGB/ShaguQuest/spawnData.lua
echo " ]"

echo -n "   - deDE database [ questData"
wget -q "http://localhost/shagudb/questData.php?deDE" -O build/deDE/ShaguQuest/questData.lua
echo -n ", itemData"
wget -q "http://localhost/shagudb/itemData.php?deDE" -O build/deDE/ShaguQuest/itemData.lua
echo -n ", spawnData"
wget -q "http://localhost/shagudb/spawnData.php?deDE" -O build/deDE/ShaguQuest/spawnData.lua
echo " ]"

echo -n "   - frFR database [ questData"
wget -q "http://localhost/shagudb/questData.php?frFR" -O build/frFR/ShaguQuest/questData.lua
echo -n ", itemData"
wget -q "http://localhost/shagudb/itemData.php?frFR" -O build/frFR/ShaguQuest/itemData.lua
echo -n ", spawnData"
wget -q "http://localhost/shagudb/spawnData.php?frFR" -O build/frFR/ShaguQuest/spawnData.lua
echo " ]"

echo ":: building release zip"
echo "   - enGB"
cd build/enGB
zip -qr9 ../../release/ShaguQuest-$VERSION-enGB.zip *
cd - >> /dev/null

echo "   - deDE"
cd build/deDE
zip -qr9 ../../release/ShaguQuest-$VERSION-deDE.zip *
cd - >> /dev/null

echo "   - frFR"
cd build/frFR
zip -qr9 ../../release/ShaguQuest-$VERSION-frFR.zip *
cd - >> /dev/null
