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

// {{{ query: enGB
$items_enGB = "
SELECT
 creature_loot_template.ChanceOrQuestChance AS chance,
 item_template.name AS item,
 creature_template.name AS mob,
 creature_template.entry AS id

FROM 
 item_template,
 creature_template,
 creature_loot_template

WHERE item_template.entry = creature_loot_template.item
AND creature_template.entry = creature_loot_template.entry

UNION

SELECT
 gameobject_loot_template.ChanceOrQuestChance AS chance,
 item_template.name AS item,
 gameobject_template.name AS mob,
 gameobject_template.entry AS id

FROM 
 item_template,
 gameobject_template,
 gameobject_loot_template

WHERE item_template.entry = gameobject_loot_template.item
AND gameobject_template.data1 = gameobject_loot_template.entry

ORDER BY item, chance, id DESC
";
// }}}
// {{{ query: deDE
$items_deDE = "
SELECT
 creature_loot_template.ChanceOrQuestChance AS chance,
 locales_item.name_loc3 AS item,
 locales_creature.name_loc3 AS mob

FROM 
 locales_item,
 locales_creature,
 creature_loot_template

WHERE locales_item.entry = creature_loot_template.item
AND locales_creature.entry = creature_loot_template.entry

UNION

SELECT
 gameobject_loot_template.ChanceOrQuestChance AS chance,
 locales_item.name_loc3 AS item,
 locales_gameobject.name_loc3 AS mob

FROM 
 locales_item,
 locales_gameobject,
 gameobject_template,
 gameobject_loot_template

WHERE locales_item.entry = gameobject_loot_template.item
AND gameobject_template.data1 = gameobject_loot_template.entry
AND gameobject_template.entry = locales_gameobject.entry

ORDER BY item, chance DESC
";
// }}}
// {{{ query: frFR
$items_frFR = "
SELECT
 creature_loot_template.ChanceOrQuestChance AS chance,
 locales_item.name_loc2 AS item,
 locales_creature.name_loc2 AS mob

FROM 
 locales_item,
 locales_creature,
 creature_loot_template

WHERE locales_item.entry = creature_loot_template.item
AND locales_creature.entry = creature_loot_template.entry

UNION

SELECT
 gameobject_loot_template.ChanceOrQuestChance AS chance,
 locales_item.name_loc2 AS item,
 locales_gameobject.name_loc2 AS mob

FROM 
 locales_item,
 locales_gameobject,
 gameobject_template,
 gameobject_loot_template

WHERE locales_item.entry = gameobject_loot_template.item
AND gameobject_template.data1 = gameobject_loot_template.entry
AND gameobject_template.entry = locales_gameobject.entry

ORDER BY item, chance DESC
";
// }}}

echo "sending mysql query...";
if($locale == "enGB") {
	$query = $mysql->query($items_enGB);
} elseif($locale == "frFR") {
	$query = $mysql->query($items_frFR);
} else {
	$query = $mysql->query($items_deDE);
}

file_put_contents($file, "itemDB = { \n");

$lastitem = "";
$first = true;

while($fetch = $query->fetch_array(MYSQLI_ASSOC)){
	$item = $fetch["item"];
	$item = str_replace("'", "\'", $item);

	$mob = $fetch["mob"];
	$mob = str_replace("'", "\'", $mob);

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
		file_put_contents($file, "    [" . $count . "] = '" . $mob . "," . $chance . "',\n", FILE_APPEND);
		$count = $count + 1;
	} else {
		file_put_contents($file, "    [" . $count . "] = '" . $mob . "," . $chance . "',\n", FILE_APPEND);
		$count = $count + 1;
	}
}
file_put_contents($file, "  }\n}\n", FILE_APPEND);

?>
