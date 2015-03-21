<?php

error_reporting(0); 
ini_set('memory_limit', '-1');

if(isset($_GET[enGB])) {
  $locale = "enGB";
} elseif(isset($_GET[frFR])){
  $locale = "frFR";
} else {
  $locale = "deDE";
}

$mysql = new mysqli("localhost", "root", "foo", "mangos");
if($mysql->connect_errno != 0){
  echo "cant connect to database";
}

$mysql->set_charset("utf8");

header('Content-Type: text/plain; charset=utf-8');

// {{{ query: enGB
$items_enGB = "
SELECT
 creature_loot_template.ChanceOrQuestChance AS chance,
 item_template.name AS item,
 creature_template.name AS mob

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
 gameobject_template.name AS mob

FROM 
 item_template,
 gameobject_template,
 gameobject_loot_template

WHERE item_template.entry = gameobject_loot_template.item
AND gameobject_template.data1 = gameobject_loot_template.entry

ORDER BY item, chance DESC
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


echo "itemData = { \n";

if($locale == "enGB") {
	$query = $mysql->query($items_enGB);
} elseif($locale == "frFR") {
	$query = $mysql->query($items_frFR);
} else {
	$query = $mysql->query($items_deDE);
}

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
		$lastitem = $item;
		$count = 1;
			
		if($first != true){
		  echo "  },\n\n";
		} else {
			$first = false;
		}

		echo "  ['" . $item . "'] = \n";
		echo "  {\n";	
		echo "    [" . $count . "] = '" . $mob . "," . $chance . "',\n";
		$count = $count + 1;
	} else {
		echo "    [" . $count . "] = '" . $mob . "," . $chance . "',\n";
		$count = $count + 1;
	}
}
echo "  }\n";
echo "}\n";

?>
