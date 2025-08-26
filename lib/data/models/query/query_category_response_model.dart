class QueryCategory {
  final int id;
  final String name;

  QueryCategory({required this.id, required this.name});

  factory QueryCategory.fromJson(Map<String, dynamic> json) {
    return QueryCategory(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
