#!/usr/bin/php
<?php
ini_set('memory_limit', '-1');

$locales = array("enGB", "koKR", "frFR", "deDE", "zhCN", "zhTW", "esES", "esMX", "ruRU");

$all_locales = false;
$build_locale = 0;

if ( isset($argv[1]) ) {
  $build_locale = $argv[1];
} else {
  $all_locales = true;
}

foreach ($locales as $loc_id => $loc_name) {

  if ( $loc_id != $build_locale ) {
    // skip in single locale mode
    if ( $all_locales == false )
      continue;

    // skip Taiwan (zhTW)
    if ($loc_id == 5 )
      continue;

    // skip Mexico (esMX)
    if ($loc_id == 7 )
      continue;
  }

  echo "Building itemDB for $loc_name (loc_$loc_id) ... ";

  $count = 0;
  $file = "../resources/itemDB.lua_$loc_name";
  $mysql = new mysqli("127.0.0.1", "mangos", "mangos", "mangos");
  $mysql->set_charset("utf8");

  $sql_select_loc_creature = "";
  $sql_select_loc_object = "";

  // extended query for localized clients
  if ( $loc_id > 0 ) {
    $sql_select_loc_creature = ",
     elysium.locales_item.name_loc$loc_id AS item_locale,
     elysium.locales_creature.name_loc$loc_id AS mob_locale
    ";

    $sql_select_loc_object = ",
     elysium.locales_item.name_loc$loc_id AS item_locale,
     elysium.locales_gameobject.name_loc$loc_id AS mob_locale
    ";
  }

  $items = "
  SELECT
   creature_loot_template.ChanceOrQuestChance AS chance,
   item_template.name AS item,
   item_template.entry AS item_id,
   creature_template.name AS mob,
   creature_template.entry AS id
   $sql_select_loc_creature

  FROM
   item_template

  LEFT JOIN creature_loot_template on item_template.entry = creature_loot_template.item
  LEFT JOIN creature_template on creature_template.entry = creature_loot_template.entry
  LEFT JOIN elysium.locales_item     ON elysium.locales_item.entry     = item_template.entry
  LEFT JOIN elysium.locales_creature ON elysium.locales_creature.entry = creature_loot_template.entry

  UNION

  SELECT
   gameobject_loot_template.ChanceOrQuestChance AS chance,
   item_template.name AS item,
   item_template.entry AS item_id,
   gameobject_template.name AS mob,
   gameobject_template.entry AS id
   $sql_select_loc_object

  FROM
   item_template

  LEFT JOIN gameobject_loot_template ON item_template.entry = gameobject_loot_template.item
  LEFT JOIN gameobject_template ON gameobject_template.data1 = gameobject_loot_template.entry
  LEFT JOIN elysium.locales_item       ON elysium.locales_item.entry       = item_template.entry
  LEFT JOIN elysium.locales_gameobject ON elysium.locales_gameobject.entry = gameobject_template.entry

  ORDER BY item_id, chance DESC, id
  ";


  $query = $mysql->query($items);

  file_put_contents($file, "itemDB = { \n");

  $lastitem = "";
  $first = true;
  $max_entry = 0;

  while($fetch = $query->fetch_array(MYSQLI_ASSOC)){
    $max_entry = $max_entry + 1;

    $item = $fetch["item"];
    $item = str_replace("'", "\'", $item);

    $mob = $fetch["mob"];
    $mob = str_replace("'", "\'", $mob);

    // load locale if existing
    if ($loc_id > 0) {
      $item_locale = $fetch["item_locale"];
      $item_locale = str_replace("'", "\'", $item_locale);
      if($item_locale != "") {
        $item = $item_locale;
      }

      $mob_locale = $fetch["mob_locale"];
      $mob_locale = str_replace("'", "\'", $mob_locale);
      if($mob_locale != "") {
        $mob = $mob_locale;
      }
    }

    $id = $fetch["item_id"];

    $chance = abs($fetch["chance"]);
    $chance = round($chance,2);

    if($item != $lastitem){
      // echo $count - 1 . "x " . $lastitem . "\n";
      $lastitem = $item;
      $count = 1;

      if($first != true){
        file_put_contents($file, "  },\n\n", FILE_APPEND);
      } else {
        $first = false;
      }

      file_put_contents($file, "  ['" . $item . "'] =\n", FILE_APPEND);
      file_put_contents($file, "  {\n", FILE_APPEND);
      file_put_contents($file, "    ['id'] = '" . $id . "',\n", FILE_APPEND);

      if($mob != "") {
        file_put_contents($file, "    [" . $count . "] = '" . $mob . "," . $chance . "',\n", FILE_APPEND);
        $count = $count + 1;
      }
    } else {
      if($mob != "") {
        file_put_contents($file, "    [" . $count . "] = '" . $mob . "," . $chance . "',\n", FILE_APPEND);
        $count = $count + 1;
      }
    }
  }
  file_put_contents($file, "  }\n}\n", FILE_APPEND);
  echo " $max_entry entries.\n";
}

?>
