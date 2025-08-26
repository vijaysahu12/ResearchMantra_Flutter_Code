
class BasketDataModel {

  final num? id;
 
  final String? title;

  final bool? isFree;

  final String? description;

  final int? companyCount;
  const BasketDataModel(
      {this.id, this.title, this.isFree, this.description, this.companyCount});
  BasketDataModel copyWith(
      {num? id,
      String? title,
      bool? isFree,
      String? description,
      final int? companyCount}) {
    return BasketDataModel(
        id: id ?? this.id,
        title: title ?? this.title,
        companyCount: companyCount ?? this.companyCount,
        description: description ?? this.description,
        isFree: isFree ?? this.isFree);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isFree': isFree,
      'description': description,
      "companyCount": companyCount
    };
  }

  static BasketDataModel fromJson(Map<String, Object?> json) {
    return BasketDataModel(
      id: json['id'] == null ? null : json['id'] as num,
      title: json['title'] == null ? null : json['title'] as String,
      description:
          json['description'] == null ? null : json['description'] as String,
      isFree: json['isFree'] == null ? null : json['isFree'] as bool,
      companyCount:
          json['companyCount'] == null ? null : json["companyCount"] as int,
    );
  }
}
