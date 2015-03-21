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


$query = $mysql->query($qGameobject);

$lquest = "";
$first = true;

echo "questData = { \n";

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
	 	
			$quest = str_replace("'", "\'", $quest);
			$object = str_replace("'", "\'", $object);

			if($lquest != $quest){
				if ($first != true){
					echo "  },\n";
				}else{ $first = false; }
				echo "  ['" . $quest . "'] = \n";
				echo "  { \n";
			}
				echo "    ['" . $object . "'] = '$type', \n";
			$lquest = $quest;
	}
  echo "  },\n";
  echo "}\n";
}

?>
