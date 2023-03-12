class major {
  String Major_id;
  String Major_name;
  String Fac_id;

  major(
      {required this.Major_id, required this.Major_name, required this.Fac_id});

  factory major.fromJson(Map<String, dynamic> json) {
    return major(
        Major_id: json['major_id'] as String,
        Major_name: json['major_name'] as String,
        Fac_id: json['fac_id'] as String);
  }
}
