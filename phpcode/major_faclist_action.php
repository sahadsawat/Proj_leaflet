<?php

$db = mysqli_connect('localhost','root','','db_app_leaflet');
mysqli_set_charset($db, "utf8");

if (!$db) {
    echo "database connect faild";
}

$person = $db->query("SELECT * FROM faculty");
$list = array();

while ($rowdata = $person->fetch_assoc()) {
    $list[] = $rowdata;
}

echo json_encode($list);