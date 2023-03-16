class location {
  String Locat_id;
  String Locat_no;
  String Locat_name;

  location(
      {required this.Locat_id,
      required this.Locat_no,
      required this.Locat_name});

  factory location.fromJson(Map<String, dynamic> json) {
    return location(
        Locat_id: json['locat_id'] as String,
        Locat_no: json['locat_no'] as String,
        Locat_name: json['locat_name'] as String);
  }
}
