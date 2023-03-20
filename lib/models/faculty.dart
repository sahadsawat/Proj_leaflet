class faculty {
  String Fac_id;
  String Fac_no;
  String Fac_name;

  faculty({required this.Fac_id, required this.Fac_no, required this.Fac_name});

  factory faculty.fromJson(Map<String, dynamic> json) {
    return faculty(
        Fac_id: json['fac_id'] as String,
        Fac_no: json['fac_no'] as String,
        Fac_name: json['fac_name'] as String);
  }
}
