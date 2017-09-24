#!/usr/bin/php
<?php
ini_set('memory_limit', '-1');

$locales = array("enGB", "koKR", "frFR", "deDE", "zhCN", "zhTW", "esES", "esMX", "ruRU" );

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

  echo "Building questDB for $loc_name (loc_$loc_id) ... ";

  $count = 0;
  $file = "../resources/questDB.lua_$loc_name";
  $mysql = new mysqli("127.0.0.1", "mangos", "mangos", "mangos");
  $mysql->set_charset("utf8");

  $gameobject_loc = "";
  $creature_loc = "";

  // extended query for localized clients
  if ( $loc_id > 0 ) {
  $gameobject_loc = ",
    elysium.locales_gameobject.name_loc$loc_id as name_locale,
    elysium.locales_quest.Title_loc$loc_id as Title_locale
  ";

  $creature_loc = ",
    elysium.locales_creature.name_loc$loc_id as name_locale,
    elysium.locales_quest.Title_loc$loc_id as Title_locale
  ";
  }


  $qGameobject = "
  SELECT
    \"Object\" as type,
    quest_template.entry as qid,
    quest_template.Title as Title,
    gameobject_template.name as name
    $gameobject_loc

  FROM
    quest_template

  INNER JOIN gameobject_questrelation ON (quest_template.entry = gameobject_questrelation.quest )
  INNER JOIN elysium.locales_quest ON (quest_template.entry = elysium.locales_quest.entry )
  INNER JOIN gameobject_template ON (gameobject_questrelation.id = gameobject_template.entry )
  INNER JOIN elysium.locales_gameobject ON (elysium.locales_gameobject.entry = gameobject_template.entry )

  UNION

  SELECT
    \"Object\" as type,
    quest_template.entry as qid,
    quest_template.Title as Title,
    gameobject_template.name as name
    $gameobject_loc

  FROM
    quest_template

  INNER JOIN gameobject_involvedrelation ON (quest_template.entry = gameobject_involvedrelation.quest )
  INNER JOIN elysium.locales_quest ON (quest_template.entry = elysium.locales_quest.entry )
  INNER JOIN gameobject_template ON (gameobject_involvedrelation.id = gameobject_template.entry )
  INNER JOIN elysium.locales_gameobject ON (elysium.locales_gameobject.entry = gameobject_template.entry )

  UNION

  SELECT
    \"NPC\" as type,
    quest_template.entry as qid,
    quest_template.Title as Title,
    creature_template.name as name
    $creature_loc

  FROM
    quest_template

  INNER JOIN creature_involvedrelation ON (quest_template.entry = creature_involvedrelation.quest )
  INNER JOIN elysium.locales_quest ON (quest_template.entry = elysium.locales_quest.entry )
  INNER JOIN creature_template ON (creature_involvedrelation.id = creature_template.entry )
  INNER JOIN elysium.locales_creature ON (elysium.locales_creature.entry = creature_template.entry )

  UNION

  SELECT
    \"NPC\" as type,

    quest_template.entry as qid,
    quest_template.Title as Title,
    creature_template.name as name
    $creature_loc

  FROM
    quest_template

  INNER JOIN creature_questrelation ON (quest_template.entry = creature_questrelation.quest )
  INNER JOIN elysium.locales_quest ON (quest_template.entry = elysium.locales_quest.entry )
  INNER JOIN creature_template ON (creature_questrelation.id = creature_template.entry )
  INNER JOIN elysium.locales_creature ON (elysium.locales_creature.entry = creature_template.entry )

  ORDER BY Title
  ";

  $query = $mysql->query($qGameobject);

  $max_entry = 0;
  $lquest = "";
  $first = true;

  file_put_contents($file, "questDB = { \n");

  if(!empty($query)) {
    while($fetch = $query->fetch_array(MYSQLI_ASSOC)){
      $max_entry = $max_entry + 1;
      $quest = $fetch["Title"];
      $object = $fetch["name"];

      if ($loc_id > 0) {
        $quest_locale = $fetch["Title_locale"];
        $object_locale = $fetch["name_locale"];

        if($quest_locale != "") {
          $quest = $quest_locale;
        }

        if($object_locale != "") {
          $object = $object_locale;
        }
      }


      $type = $fetch["type"];
      $quest = str_replace("'", "\'", $quest);
      $object = str_replace("'", "\'", $object);
      $quest = str_replace("[DEPRECATED] ", "", $quest);

      if($lquest != $quest){
        // echo $count - 1 . "x " . $lquest . "\n";
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
  echo " $max_entry entries.\n";
}

?>
