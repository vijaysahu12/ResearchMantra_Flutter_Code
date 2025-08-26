class NewVersionResponseModel {
  final int? id;
  final String value;
  final String? code;
  final bool? isActive;

  const NewVersionResponseModel({
    this.id,
    required this.value,
    this.code,
    this.isActive,
  });

  static NewVersionResponseModel fromJson(dynamic json) {
    return NewVersionResponseModel(
      id: json['id'],
      value: json['value'] ?? "",
      code: json['code'],
      isActive: json['isActive'],
    );
  }
}


