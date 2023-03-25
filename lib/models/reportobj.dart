import 'dart:io';

class reportobj {
  String Repobj_id;
  String Repobj_name;
  String urlPathImage;
  String Repobj_status;
  String Repobj_detail;
  String Repobj_date;
  String Cate_id;
  String Locat_id;
  String User_id;
  String Locat_name;
  String User_email;

  reportobj({
    required this.Repobj_id,
    required this.Repobj_name,
    required this.urlPathImage,
    required this.Repobj_status,
    required this.Repobj_detail,
    required this.Repobj_date,
    required this.Cate_id,
    required this.Locat_id,
    required this.User_id,
    required this.Locat_name,
    required this.User_email,
  });
  factory reportobj.fromJson(Map json) {
    return reportobj(
      Repobj_id: json['reportobj_id'] as String,
      Repobj_name: json['reportobj_name'] as String,
      urlPathImage: json['reportobj_photo'] as String,
      Repobj_status: json['reportobj_status'] as String,
      Repobj_detail: json['reportobj_detail'] as String,
      Repobj_date: json['reportobj_date'] as String,
      Cate_id: json['cate_id'] as String,
      Locat_id: json['locat_id'] as String,
      User_id: json['user_id'] as String,
      Locat_name: json['locat_name'] as String,
      User_email: json['user_email'] as String,
    );
  }
}
