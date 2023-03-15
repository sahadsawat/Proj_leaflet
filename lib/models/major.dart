class major {
  String Major_id;
  String Major_name;
  String Fac_id;
  String Fac_name;

  major(
      {required this.Major_id,
      required this.Major_name,
      required this.Fac_id,
      required this.Fac_name});

  factory major.fromJson(Map<String, dynamic> json) {
    return major(
        Major_id: json['major_id'] as String,
        Major_name: json['major_name'] as String,
        Fac_id: json['fac_id'] as String,
        Fac_name: json['fac_name'] as String);
  }
}
