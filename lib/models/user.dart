class User {
  String User_id;
  String User_email;
  String User_password;
  String First_name;
  String Last_name;
  String User_tel;
  String User_lineid;
  String Major_id;

  User({
    required this.User_id,
    required this.User_email,
    required this.User_password,
    required this.First_name,
    required this.Last_name,
    required this.User_tel,
    required this.User_lineid,
    required this.Major_id,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      User_id: json['user_id'] as String,
      User_email: json['user_email'] as String,
      User_password: json['user_password'] as String,
      First_name: json['first_name'] as String,
      Last_name: json['last_name'] as String,
      User_tel: json['user_tel'] as String,
      User_lineid: json['user_lineid'] as String,
      Major_id: json['major_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = User_id;
    data['user_email'] = User_email;
    data['user_password'] = User_password;
    data['first_name'] = First_name;
    data['last_name'] = Last_name;
    data['user_tel'] = User_tel;
    data['user_lineid'] = User_lineid;
    data['major_id'] = Major_id;
    return data;
  }
}
