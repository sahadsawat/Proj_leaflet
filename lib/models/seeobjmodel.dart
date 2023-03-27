import 'dart:io';

class seeobjmodel {
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
  String Cate_name;
  String User_email;

  seeobjmodel({
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
    required this.Cate_name,
    required this.User_email,
  });
  factory seeobjmodel.fromJson(Map json) {
    return seeobjmodel(
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
      Cate_name: json['cate_name'] as String,
      User_email: json['user_email'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['seeobj_id'] = Seeobj_id;
    data['seeobj_name'] = Seeobj_name;
    data['seeobj_photo'] = urlPathImage;
    data['seeobj_status'] = Seeobj_status;
    data['seeobj_detail'] = Seeobj_detail;
    data['seeobj_date'] = Seeobj_date;
    data['cate_id'] = Cate_id;
    data['locat_id'] = Locat_id;
    data['user_id'] = User_id;
    data['locat_name'] = Locat_name;
    data['cate_name'] = Cate_name;
    data['user_email'] = User_email;
    return data;
  }
}
