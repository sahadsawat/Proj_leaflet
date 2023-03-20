<?php 
	$db = mysqli_connect('localhost','root','','db_app_leaflet');

	$useremail = $_POST['user_email'];
	$password = $_POST['user_password'];

	$sql = "SELECT * FROM user WHERE user_email = '$useremail' AND user_password = '$password'";
	$result = mysqli_query($db,$sql);
	$count = mysqli_num_rows($result);

	if ($count == 1) {
		echo json_encode("Success");
	}else{
		echo json_encode("Error");
	}

?>