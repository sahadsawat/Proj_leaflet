class user {
  String User_no;
  String User_id;
  String User_password;
  String First_name;
  String Last_name;
  String User_tel;
  String User_email;
  String Major_id;

  user(
      {required this.User_no,
      required this.User_id,
      required this.User_password,
      required this.First_name,
      required this.Last_name,
      required this.User_tel,
      required this.User_email,
      required this.Major_id});

  factory user.fromJson(Map<String, dynamic> json) {
    return user(
      User_no: json['user_no'] as String,
      User_id: json['user_id'] as String,
      User_password: json['user_password'] as String,
      First_name: json['first_name'] as String,
      Last_name: json['last_name'] as String,
      User_tel: json['user_tel'] as String,
      User_email: json['user_email'] as String,
      Major_id: json['major_id'] as String,
    );
  }
}
