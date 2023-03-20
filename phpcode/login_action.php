<?php 
	$db = mysqli_connect('localhost','root','','db_app_leaflet');

	$userid = $_POST['user_id'];
	$password = $_POST['user_password'];

	$sql = "SELECT * FROM user WHERE user_id = '$userid' AND user_password = '$password'";
	$result = mysqli_query($db,$sql);
	$count = mysqli_num_rows($result);

	if ($count == 1) {
		echo json_encode("Success");
	}else{
		echo json_encode("Error");
	}

?>