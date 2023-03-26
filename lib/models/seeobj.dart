import 'dart:io';

class seeobj {
  String Seeobj_id;
  String Seeobj_name;
  String urlPathImage;
  String Seeobj_status;
  String Seeobj_detail;
  String Seeobj_date;
  String Cate_id;
  String Locat_id;
  String User_id;
  String Locat_name;
  String User_email;

  seeobj({
    required this.Seeobj_id,
    required this.Seeobj_name,
    required this.urlPathImage,
    required this.Seeobj_status,
    required this.Seeobj_detail,
    required this.Seeobj_date,
    required this.Cate_id,
    required this.Locat_id,
    required this.User_id,
    required this.Locat_name,
    required this.User_email,
  });
  factory seeobj.fromJson(Map json) {
    return seeobj(
      Seeobj_id: json['seeobj_id'] as String,
      Seeobj_name: json['seeobj_name'] as String,
      urlPathImage: json['seeobj_photo'] as String,
      Seeobj_status: json['seeobj_status'] as String,
      Seeobj_detail: json['seeobj_detail'] as String,
      Seeobj_date: json['seeobj_date'] as String,
      Cate_id: json['cate_id'] as String,
      Locat_id: json['locat_id'] as String,
      User_id: json['user_id'] as String,
      Locat_name: json['locat_name'] as String,
      User_email: json['user_email'] as String,
    );
  }
}
