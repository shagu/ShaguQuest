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

// {{{ creatureById
function getCreatureById ($currentID) {
	global $mysql;
  global $locale;

	$qCreature = "
	  SELECT 
	   \"NPC\" AS type,
       creature.id AS id,
       creature.guid AS uid,
       creature_template.Name AS name,
       locales_creature.name_loc2 AS name_loc2,
       locales_creature.name_loc3 AS name_loc3,
       creature.position_x AS x,
       creature.position_y AS y,
       creature.map AS map,
	   aowow_zones.mapID AS mapID,
	   aowow_zones.areatableID AS zone,
       aowow_zones.x_max AS x_max,
       aowow_zones.x_min AS x_min,
       aowow_zones.y_max AS y_max,
       aowow_zones.y_min AS y_min
      
      FROM creature
      INNER JOIN creature_template ON creature_template.Entry = creature.id
      INNER JOIN locales_creature ON locales_creature.entry = creature.id
      INNER JOIN aowow_zones ON (aowow_zones.mapID = creature.map
       AND aowow_zones.x_min < creature.position_x
       AND aowow_zones.x_max > creature.position_x
       AND aowow_zones.y_min < creature.position_y
       AND aowow_zones.y_max > creature.position_y
	   AND aowow_zones.areatableID > 0
	   AND aowow_zones.mapID < 2
      )
    
	  UNION

		  SELECT 
	   \"Object\" AS type,
       gameobject.id AS id,
       gameobject.guid AS uid,
       gameobject_template.Name AS name,
       locales_gameobject.name_loc2 AS name_loc2,
       locales_gameobject.name_loc3 AS name_loc3,
       gameobject.position_x AS x,
       gameobject.position_y AS y,
       gameobject.map AS map,
	   aowow_zones.mapID AS mapID,
	   aowow_zones.areatableID AS zone,
       aowow_zones.x_max AS x_max,
       aowow_zones.x_min AS x_min,
       aowow_zones.y_max AS y_max,
       aowow_zones.y_min AS y_min
      
      FROM gameobject
      INNER JOIN gameobject_template ON gameobject_template.Entry = gameobject.id
      INNER JOIN locales_gameobject ON locales_gameobject.entry = gameobject.id
      INNER JOIN aowow_zones ON (aowow_zones.mapID = gameobject.map
       AND aowow_zones.x_min < gameobject.position_x
       AND aowow_zones.x_max > gameobject.position_x
       AND aowow_zones.y_min < gameobject.position_y
       AND aowow_zones.y_max > gameobject.position_y
	   AND aowow_zones.areatableID > 0
	   AND aowow_zones.mapID < 2
      )

      ORDER BY name,id
			";

		$creature_query = $mysql->query($qCreature);
		$first = true;
		$lzone = null;
		$lname = null;

		if(!empty($creature_query)) {
		while($creature_fetch = $creature_query->fetch_array(MYSQLI_ASSOC)){

			if($locale == "enGB") {
				$name = $creature_fetch["name"];	
			} elseif($locale == "frFR"){
	 			$name = $creature_fetch["name_loc2"];
				if($name == ""){
					$name = $creature_fetch["name"];
				}

			} else {
	 			$name = $creature_fetch["name_loc3"];
				if($name == ""){
					$name = $creature_fetch["name"];
				}
			}

//			if($creature_fetch["id"] >= 47 && $creature_fetch["id"] <= 49) {
			if($name != null) {
		 		$type = $creature_fetch["type"];
		 		$x = $creature_fetch["x"];
		 		$y = $creature_fetch["y"];
		 		$x_max = $creature_fetch["x_max"];
		 		$x_min = $creature_fetch["x_min"];
		 		$y_max = $creature_fetch["y_max"];
		 		$y_min = $creature_fetch["y_min"];
				$zone = $creature_fetch["zone"];
				$tx = round(100 - ($y - $y_min) / (($y_max - $y_min)/100),1);
				$ty = round(100 - ($x - $x_min) / (($x_max - $x_min)/100),1);

				// write position delta [a²+b²=c²]
				$delta_x = abs($tx-50);
				$delta_y = abs($ty-50);
				$delta = round(sqrt($delta_x * $delta_x + $delta_y * $delta_y),2);
		
				$name = str_replace("'", "\'", $name);

				if($name != null && $lname != $name){
					if($first == true){	
						echo "spawnData = { \n";
						$first = false; 
					}else{
						$maxcount = 0;
						echo "    },\n";
						echo "  },\n";
					}

					echo "  ['$name'] = \n";
					echo "  {\n";
					echo "    ['type'] = '$type',\n";
					echo "    ['coords'] = \n";
					echo "    { \n";
					$count = 1;
				}
				echo "      [$count] = '$tx,$ty,$zone,$delta', \n";
				$lname = $name;
				$lzone = $zone;
				$count++;
      }
		}
		echo "    },\n";
		echo "  },\n";
		echo "}\n";
		}
}
// }}}

getCreatureById(null);

?>
