<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "db_app_leaflet";
$table = "faculty";

$action = isset($_POST['action']) ? $_POST['action'] : '';

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
mysqli_set_charset($conn, "utf8");
// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

if('GET_ALL' == $action){
    $dbdata = array();
    $sql = "SELECT fac_id,fac_no,fac_name FROM $table ORDER BY fac_no ASC";
    $result = $conn->query($sql);
    if ($result->num_rows > 0) {
        while($row = $result->fetch_assoc()) {
            $dbdata[]=$row;
        }
        echo json_encode($dbdata);
    } else {
        echo "error";
    }
    $conn->close();
    return;
}

if('ADD_FAC' == $action){
    $fac_no = $_POST['fac_no'];
    $fac_name = $_POST['fac_name'];
    $sql = "INSERT INTO $table (fac_name,fac_no) VALUES('$fac_name','$fac_no')";
    $result = $conn->query($sql);
    echo 'success';
    return;
}

if('UPDATE_FAC' == $action){
    $fac_id = $_POST['fac_id'];
    $fac_no = $_POST['fac_no'];
    $fac_name = $_POST['fac_name'];
    $sql = "UPDATE $table SET fac_no = '$fac_no',fac_name = '$fac_name' WHERE fac_id = $fac_id";
    if ($conn->query($sql) === TRUE) {
        echo "success";
    } else {
        echo "error";
    }
    $conn->close();
    return;
}

if('DELETE_FAC' == $action){
    $fac_id = $_POST['fac_id'];
    $sql = "DELETE FROM $table WHERE fac_id = $fac_id";
    if ($conn->query($sql) === TRUE) {
        echo "success";
    } else {
        echo "error";
    }
    $conn->close();
    return;
}


?>