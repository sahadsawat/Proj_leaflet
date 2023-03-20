class major3 {
  String Major_id;
  String Major_no;
  String Major_name;
  String Fac_id;
  major3(
      {required this.Fac_id,
      required this.Major_id,
      required this.Major_name,
      required this.Major_no});

  factory major3.fromJson(Map<String, dynamic> json) {
    return major3(
      Major_id: json['major_id'] as String,
      Major_no: json['major_no'] as String,
      Major_name: json['major_name'] as String,
      Fac_id: json['fac_id'] as String,
    );
  }
}
