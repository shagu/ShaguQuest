#!/bin/bash
# dbc exports as csv are required

locales="enUS koKR frFR deDE zhCN zhTW esES esMX ruRU"
index=0

for loc in $locales; do

  if [ "$loc" = "ruRU" ]; then index=0; fi

  echo "## $loc ##"
  if [ -f "AreaTable_${loc}.dbc.csv" ]; then
    echo "zoneDB = {" > zoneDB.lua_${loc}

    tail -n +2 AreaTable_${loc}.dbc.csv | while read line; do
      id=$(echo $line | cut -d , -f 1)
      entry=$(echo $line | cut -d , -f $(expr 12 + $index))
      echo "    [$id] = $entry," | tee -a  zoneDB.lua_${loc}
    done

    echo "}" >> zoneDB.lua_${loc}
  else
    echo "Skipping ..."
  fi

  index=$(expr $index + 1)
done
