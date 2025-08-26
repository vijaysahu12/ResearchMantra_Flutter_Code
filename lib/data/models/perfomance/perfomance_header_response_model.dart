
class GetPerformanceHeaderResponseModel {
  final int? id;
  final String? code;
  final String? name;
  const GetPerformanceHeaderResponseModel({this.id, this.code, this.name});

// Factory constructor for JSON deserialization

  factory GetPerformanceHeaderResponseModel.fromJson(
      Map<String, dynamic> json) {

    return GetPerformanceHeaderResponseModel(
      id: json['id'] ?? 1,
      code: json['code'] ?? '',
      name: json['name'] ?? "",
    );
  }
}
