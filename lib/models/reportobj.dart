class reportbj {
  String Repobj_id;
  String Repobj_name;
  String Repobj_photo;
  String Repobj_status;
  String Repobj_detail;
  String Repobj_date;
  String Cate_id;
  String Locat_id;
  String User_id;

  reportbj({
    required this.Repobj_id,
    required this.Repobj_name,
    required this.Repobj_photo,
    required this.Repobj_status,
    required this.Repobj_detail,
    required this.Repobj_date,
    required this.Cate_id,
    required this.Locat_id,
    required this.User_id,
  });
  factory reportbj.fromJson(Map<String, dynamic> json) {
    return reportbj(
        Repobj_id: json['reportobj_id'] as String,
        Repobj_name: json['reportobj_name'] as String,
        Repobj_photo: json['reportobj_photo'] as String,
        Repobj_status: json['reportobj_status'] as String,
        Repobj_detail: json['reportobj_detail'] as String,
        Repobj_date: json['reportobj_date'] as String,
        Cate_id: json['cate_id'] as String,
        Locat_id: json['locat_id'] as String,
        User_id: json['user_id'] as String);
  }
}
