class category {
  String Cate_id;
  String Cate_name;

  category({required this.Cate_id, required this.Cate_name});

  factory category.fromJson(Map<String, dynamic> json) {
    return category(
        Cate_id: json['cate_id'] as String,
        Cate_name: json['cate_name'] as String);
  }
}
