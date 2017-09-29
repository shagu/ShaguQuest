#!/usr/bin/php
<?php
ini_set('memory_limit', '-1');

$locales = array("enUS", "koKR", "frFR", "deDE", "zhCN", "zhTW", "esES", "esMX", "ruRU" );

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

  echo "Building zoneDB for $loc_name (loc_$loc_id) ... ";

  $count = 0;
  $file = "../resources/zoneDB.lua_$loc_name";
  $mysql = new mysqli("127.0.0.1", "mangos", "mangos", "mangos");
  $mysql->set_charset("utf8");

  $area_loc = "";

  // extended query for localized clients
  if ( $loc_id > 0 ) {
  $area_loc = ",
    elysium.locales_area.NameLoc$loc_id as name_locale
  ";
  }


  $qGameobject = "
  SELECT
    elysium.area_template.Entry as id,
    elysium.area_template.Name as name
    $area_loc

  FROM
    elysium.area_template

  INNER JOIN elysium.locales_area ON (elysium.area_template.Entry = elysium.locales_area.Entry )

  ORDER BY id
  ";

  $query = $mysql->query($qGameobject);

  $max_entry = 0;

  file_put_contents($file, "zoneDB = {\n");

  if(!empty($query)) {
    while($fetch = $query->fetch_array(MYSQLI_ASSOC)){
      $max_entry = $max_entry + 1;
      $id = $fetch["id"];
      $name = $fetch["name"];

      if ($loc_id > 0) {
        $name_locale = $fetch["name_locale"];

        if($name_locale != "") {
          $name = $name_locale;
        }
      }

      $name = str_replace("'", "\'", $name);

      file_put_contents($file, "    [" . $id . "] = '$name',\n", FILE_APPEND);

    }
    file_put_contents($file, "}\n", FILE_APPEND);
  }
  echo " $max_entry entries.\n";
}

?>
