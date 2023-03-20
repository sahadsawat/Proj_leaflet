<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "db_app_leaflet";
$table = "category";

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
    $sql = "SELECT cate_id,cate_no,cate_name FROM $table ORDER BY cate_no ASC";
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

if('ADD_CATE' == $action){
    $cate_no = $_POST['cate_no'];
    $cate_name = $_POST['cate_name'];
    $sql = "INSERT INTO $table (cate_no,cate_name) VALUES('$cate_no','$cate_name')";
    $result = $conn->query($sql);
    echo 'success';
    return;
}

if('UPDATE_CATE' == $action){
    $cate_id = $_POST['cate_id'];
    $cate_no = $_POST['cate_no'];
    $cate_name = $_POST['cate_name'];
    $sql = "UPDATE $table SET cate_no = '$cate_no',cate_name = '$cate_name' WHERE cate_id = $cate_id";
    if ($conn->query($sql) === TRUE) {
        echo "success";
    } else {
        echo "error";
    }
    $conn->close();
    return;
}

if('DELETE_CATE' == $action){
    $cate_id = $_POST['cate_id'];
    $sql = "DELETE FROM $table WHERE cate_id = $cate_id";
    if ($conn->query($sql) === TRUE) {
        echo "success";
    } else {
        echo "error";
    }
    $conn->close();
    return;
}


?>