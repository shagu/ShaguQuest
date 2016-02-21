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
$file = "../resources/questDB.lua_$locale";
$mysql = new mysqli("localhost", "shagu", "shagu", "shagu");
if($mysql->connect_errno != 0){	echo "cant connect to database"; }
$mysql->set_charset("utf8");

$qGameobject = "
SELECT
	\"Object\" as type,
	locales_quest.Title_loc2,
	locales_quest.Title_loc3,
	quest_template.entry as qid,
	quest_template.Title as Title,
	gameobject_template.name as name,
	locales_gameobject.name_loc2 as name_loc2,
	locales_gameobject.name_loc3 as name_loc3

FROM
	quest_template

INNER JOIN gameobject_questrelation ON (quest_template.entry = gameobject_questrelation.quest )
INNER JOIN locales_quest ON (quest_template.entry = locales_quest.entry )
INNER JOIN gameobject_template ON (gameobject_questrelation.id = gameobject_template.entry )
INNER JOIN locales_gameobject ON (locales_gameobject.entry = gameobject_template.entry )

UNION

SELECT
	\"Object\" as type,
	locales_quest.Title_loc2,
	locales_quest.Title_loc3,
	quest_template.entry as qid,
	quest_template.Title as Title,
	gameobject_template.name as name,
	locales_gameobject.name_loc2 as name_loc2,
	locales_gameobject.name_loc3 as name_loc3

FROM
	quest_template

INNER JOIN gameobject_involvedrelation ON (quest_template.entry = gameobject_involvedrelation.quest )
INNER JOIN locales_quest ON (quest_template.entry = locales_quest.entry )
INNER JOIN gameobject_template ON (gameobject_involvedrelation.id = gameobject_template.entry )
INNER JOIN locales_gameobject ON (locales_gameobject.entry = gameobject_template.entry )

UNION

SELECT
	\"NPC\" as type,
	locales_quest.Title_loc2,
	locales_quest.Title_loc3,
	quest_template.entry as qid,
	quest_template.Title as Title,
	creature_template.name as name,
	locales_creature.name_loc2 as name_loc2,
	locales_creature.name_loc3 as name_loc3

FROM
	quest_template

INNER JOIN creature_involvedrelation ON (quest_template.entry = creature_involvedrelation.quest )
INNER JOIN locales_quest ON (quest_template.entry = locales_quest.entry )
INNER JOIN creature_template ON (creature_involvedrelation.id = creature_template.entry )
INNER JOIN locales_creature ON (locales_creature.entry = creature_template.entry )

UNION

SELECT
	\"NPC\" as type,
	locales_quest.Title_loc2,
	locales_quest.Title_loc3,
	quest_template.entry as qid,
	quest_template.Title as Title,
	creature_template.name as name,
	locales_creature.name_loc2 as name_loc2,
	locales_creature.name_loc3 as name_loc3

FROM
	quest_template

INNER JOIN creature_questrelation ON (quest_template.entry = creature_questrelation.quest )
INNER JOIN locales_quest ON (quest_template.entry = locales_quest.entry )
INNER JOIN creature_template ON (creature_questrelation.id = creature_template.entry )
INNER JOIN locales_creature ON (locales_creature.entry = creature_template.entry )

ORDER BY Title
";

echo "sending mysql query...";
$query = $mysql->query($qGameobject);

$lquest = "";
$first = true;

file_put_contents($file, "questDB = { \n");

if(!empty($query)) {
	while($fetch = $query->fetch_array(MYSQLI_ASSOC)){
			if($locale == "enGB") {
	 			$quest = $fetch["Title"];
	 			$object = $fetch["name"];
			} elseif($locale == "frFR") {
				$quest = $fetch["Title_loc2"];
	 			$object = $fetch["name_loc2"];
			} else {
	 			$quest = $fetch["Title_loc3"];
	 			$object = $fetch["name_loc3"];
			}

			$type = $fetch["type"];
			$quest = str_replace("'", "\'", $quest);
			$object = str_replace("'", "\'", $object);

			if($lquest != $quest){
				echo $count - 1 . "x " . $lquest . "\n";
				$count = 1;

				if ($first != true){
		 	 		file_put_contents($file, "  },\n", FILE_APPEND);
				}else{
					$first = false;
				}
				file_put_contents($file, "  ['" . $quest . "'] = \n", FILE_APPEND);
				file_put_contents($file, "  { \n", FILE_APPEND);
			}
			file_put_contents($file, "    ['" . $object . "'] = '$type', \n", FILE_APPEND);
			$lquest = $quest;
			$count++;
	}
  file_put_contents($file, "  },\n", FILE_APPEND);
  file_put_contents($file, "}\n", FILE_APPEND);
}

?>
