<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "db_app_leaflet";
$table = "location";

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
    $sql = "SELECT locat_id,locat_no,locat_name FROM $table ORDER BY locat_no ASC";
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

if('ADD_LOCAT' == $action){
    $locat_no = $_POST['locat_no'];
    $locat_name = $_POST['locat_name'];
    $sql = "INSERT INTO $table (locat_no,locat_name) VALUES('$locat_no','$locat_name')";
    $result = $conn->query($sql);
    echo 'success';
    return;
}

if('UPDATE_LOCAT' == $action){
    $locat_id = $_POST['locat_id'];
    $locat_no = $_POST['locat_no'];
    $locat_name = $_POST['locat_name'];
    $sql = "UPDATE $table SET locat_no = '$locat_no',locat_name = '$locat_name' WHERE locat_id = $locat_id";
    if ($conn->query($sql) === TRUE) {
        echo "success";
    } else {
        echo "error";
    }
    $conn->close();
    return;
}

if('DELETE_LOCAT' == $action){
    $locat_id = $_POST['locat_id'];
    $sql = "DELETE FROM $table WHERE locat_id = $locat_id";
    if ($conn->query($sql) === TRUE) {
        echo "success";
    } else {
        echo "error";
    }
    $conn->close();
    return;
}


?>