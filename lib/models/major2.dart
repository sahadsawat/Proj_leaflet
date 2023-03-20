class major2 {
  String Fac_id;
  String Fac_name;

  major2({required this.Fac_id, required this.Fac_name});

  factory major2.fromJson(Map<String, dynamic> json) {
    return major2(
        Fac_id: json['fac_id'] as String, Fac_name: json['fac_name'] as String);
  }
}
