#!/usr/bin/php
<?php

ini_set('memory_limit', '-1');

switch($argv[1]) {
	case "enGB":
		$locale = "enGB";
		break;

	case "deDE":
		$locale = "deDE";
		break;

	default:
		$locale = "enGB";
		break;
}

$count = 0;
$file = "../resources/itemDB.lua_$locale";
$mysql = new mysqli("localhost", "shagu", "shagu", "shagu");
if($mysql->connect_errno != 0){	echo "cant connect to database"; }
$mysql->set_charset("utf8");

$items = "
SELECT
 creature_loot_template.ChanceOrQuestChance AS chance,
 item_template.name AS item,
 item_template.entry AS item_id,
 creature_template.name AS mob,
 creature_template.entry AS id,
 locales_item.name_loc3 AS item_loc3,
 locales_creature.name_loc3 AS mob_loc3

FROM 
 item_template

LEFT JOIN creature_loot_template on item_template.entry = creature_loot_template.item
LEFT JOIN creature_template on creature_template.entry = creature_loot_template.entry
LEFT JOIN locales_item 	   ON locales_item.entry = item_template.entry
LEFT JOIN locales_creature ON locales_creature.entry = creature_loot_template.entry

UNION

SELECT
 gameobject_loot_template.ChanceOrQuestChance AS chance,
 item_template.name AS item,
 item_template.entry AS item_id,
 gameobject_template.name AS mob,
 gameobject_template.entry AS id,
 locales_item.name_loc3 AS item_loc3,
 locales_gameobject.name_loc3 AS mob_loc3

FROM 
 item_template

LEFT JOIN gameobject_loot_template ON item_template.entry = gameobject_loot_template.item
LEFT JOIN gameobject_template ON gameobject_template.data1 = gameobject_loot_template.entry
LEFT JOIN locales_item 	   ON locales_item.entry = item_template.entry
LEFT JOIN locales_gameobject ON gameobject_template.entry = locales_gameobject.entry

ORDER BY item_id, chance DESC, id
";


echo "sending mysql query...";
$query = $mysql->query($items);

file_put_contents($file, "itemDB = { \n");

$lastitem = "";
$first = true;

while($fetch = $query->fetch_array(MYSQLI_ASSOC)){
	$item = $fetch["item"];
	$item = str_replace("'", "\'", $item);

	$item_loc3 = $fetch["item_loc3"];
	$item_loc3 = str_replace("'", "\'", $item_loc3);

	$mob = $fetch["mob"];
	$mob = str_replace("'", "\'", $mob);

	$mob_loc3 = $fetch["mob_loc3"];
	$mob_loc3 = str_replace("'", "\'", $mob_loc3);

	if($locale == "deDE" and $item_loc3 != "") { $item = $item_loc3; }
	if($locale == "deDE" and $mob_loc3 != "") { $mob = $mob_loc3; }

	$id = $fetch["item_id"];

	$chance = abs($fetch["chance"]);
	$chance = round($chance,2);

	if($item != $lastitem){
		echo $count - 1 . "x " . $lastitem . "\n";
		$lastitem = $item;
		$count = 1;
			
		if($first != true){
		  file_put_contents($file, "  },\n\n", FILE_APPEND);
		} else {
			$first = false;
		}

		file_put_contents($file, "  ['" . $item . "'] = \n", FILE_APPEND);
		file_put_contents($file, "  {\n", FILE_APPEND);	
		file_put_contents($file, "    ['id'] = '" . $id . "',\n", FILE_APPEND);

		if($mob != "") {
		file_put_contents($file, "    [" . $count . "] = '" . $mob . "," . $chance . "',\n", FILE_APPEND);
		}
		$count = $count + 1;
	} else {
		file_put_contents($file, "    [" . $count . "] = '" . $mob . "," . $chance . "',\n", FILE_APPEND);
		$count = $count + 1;
	}
}
file_put_contents($file, "  }\n}\n", FILE_APPEND);

?>
