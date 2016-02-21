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
$file = "../resources/vendorDB.lua_$locale";
$mysql = new mysqli("localhost", "shagu", "shagu", "shagu");
if($mysql->connect_errno != 0){	echo "cant connect to database"; }
$mysql->set_charset("utf8");

// {{{ query: enGB
$items_enGB = "
SELECT
 item_template.name AS item,
 creature_template.name AS mob,
 creature_template.entry AS id,
 npc_vendor.maxcount AS maxcount

FROM 
 item_template,
 creature_template,
 npc_vendor

WHERE item_template.entry = npc_vendor.item
AND creature_template.entry = npc_vendor.entry

ORDER BY item, id DESC
";
// }}}

// {{{ query: deDE
$items_deDE = "
SELECT
 locales_item.name_loc3 AS item,
 locales_creature.name_loc3 AS mob,
 locales_creature.entry AS id,
 npc_vendor.maxcount AS maxcount

FROM 
 locales_item,
 locales_creature,
 npc_vendor

WHERE locales_item.entry =  npc_vendor.item
AND locales_creature.entry = npc_vendor.entry

ORDER BY item, id DESC
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

file_put_contents($file, "vendorDB = { \n");

$lastitem = "";
$first = true;

while($fetch = $query->fetch_array(MYSQLI_ASSOC)){
	$item = $fetch["item"];
	$item = str_replace("'", "\'", $item);

	$mob = $fetch["mob"];
	$mob = str_replace("'", "\'", $mob);

	$maxcount = $fetch["maxcount"];

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
		file_put_contents($file, "    [" . $count . "] = '" . $mob . "," . $maxcount . "',\n", FILE_APPEND);
		$count = $count + 1;
	} else {
		file_put_contents($file, "    [" . $count . "] = '" . $mob . "," . $maxcount . "',\n", FILE_APPEND);
		$count = $count + 1;
	}
}
file_put_contents($file, "  }\n}\n", FILE_APPEND);

?>
