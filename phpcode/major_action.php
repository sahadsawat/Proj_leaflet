<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "db_app_leaflet";
$table = "major";

$action = isset($_POST['action']) ? $_POST['action'] : '';

// Create connection
$conn = mysqli_connect($servername, $username, $password, $dbname);
mysqli_set_charset($conn, "utf8");
// Check connection

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
    
}

if('GET_ALL' == $action){
    $dbdata = array();
    $sql = "SELECT t1.major_id,t1.major_no,t1.major_name,t1.fac_id ,t2.fac_name
            FROM major  t1
            INNER JOIN faculty t2 ON t1.fac_id  =  t2.fac_id
            --  WHERE t1.major_id = '' 
            ORDER BY major_no ASC ";
    $result = mysqli_query($conn,$sql);
    $numrows = mysqli_num_rows($result);


   
    if ($numrows > 0) {
        while($row = $result->fetch_object()) {
            $dbdata[]=$row;
        }
        echo json_encode($dbdata);
    } else {
        echo "error1";
    }
    $conn->close();
    return;
}

if('GET_ALL2' == $action){
    $dbdata = array();
    $sql = "SELECT *
            FROM faculty";
    $result = mysqli_query($conn,$sql);
    $numrows = mysqli_num_rows($result);

    if ($numrows > 0) {
        while($row = $result->fetch_object()) {
            $dbdata[]=$row;
        }
        echo json_encode($dbdata);
    } else {
        echo "error1";
    }
    $conn->close();
    return;
}

if('GET_ALL3' == $action){
    $fac_id = $_POST['fac_id'];
    $dbdata = array();
    $sql = "SELECT t1.major_id,t1.major_no,t1.major_name,t1.fac_id ,t2.fac_name
            FROM major  t1
            INNER JOIN faculty t2 ON t1.fac_id  =  t2.fac_id
             WHERE t2.fac_id = $fac_id
            ";
    $result = mysqli_query($conn,$sql);
    $numrows = mysqli_num_rows($result);


   
    if ($numrows > 0) {
        while($row = $result->fetch_object()) {
            $dbdata[]=$row;
        }
        echo json_encode($dbdata);
    } else {
        echo "error1";
    }
    $conn->close();
    return;
}


if('ADD_MAJOR' == $action){
    $major_no = $_POST['major_no'];
    $major_name = $_POST['major_name'];
    $fac_id = $_POST['fac_id'];
    $sql = "INSERT INTO $table (major_no,major_name,fac_id) VALUES('$major_no','$major_name','$fac_id')";
    $result = $conn->query($sql);
    echo 'success';
    return;
}

if('UPDATE_MAJOR' == $action){
    $major_id = $_POST['major_id'];
    $major_no = $_POST['major_no'];
    $major_name = $_POST['major_name'];
    $fac_id = $_POST['fac_id'];
    $sql = "UPDATE $table SET major_no = '$major_no',major_name = '$major_name',fac_id = '$fac_id' WHERE major_id = $major_id";
    if ($conn->query($sql) === TRUE) {
        echo "success";
    } else {
        echo "error";
    }
    $conn->close();
    return;
}

if('DELETE_MAJOR' == $action){
    $major_id = $_POST['major_id'];
    $sql = "DELETE FROM $table WHERE major_id = $major_id";
    if ($conn->query($sql) === TRUE) {
        echo "success";
    } else {
        echo "error";
    }
    $conn->close();
    return;
}


?>