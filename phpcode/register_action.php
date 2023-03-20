<?php
	$db = mysqli_connect('localhost','root','','db_app_leaflet');
	if (!$db) {
		echo "Database connection faild";
	}
    mysqli_set_charset($db, "utf8");

	$userid = $_POST['user_id'];
	$password = $_POST['user_password'];
    $firstname = $_POST['first_name'];
	$lastname = $_POST['last_name'];
    $usertel = $_POST['user_tel'];
    $useremail = $_POST['user_email'];
    $majorid = $_POST['major_id'];




	$sql = "SELECT user_id FROM user WHERE user_id = '$userid'";

	$result = mysqli_query($db,$sql);
	$count = mysqli_num_rows($result);

	if ($count == 1) {
		echo json_encode("Error");
	}else{
		$insert = "INSERT INTO user(user_id,user_password,first_name,last_name,user_tel,user_email,major_id)VALUES('$userid','$password','$firstname','$lastname','$usertel','$useremail','$majorid')";
		$query = mysqli_query($db,$insert);
		if ($query) {
			echo json_encode("Success");
		}
	}

?>