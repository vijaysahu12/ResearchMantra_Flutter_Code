class GetStrategiesResponseModel {
  final int id;
  final String name;
  final String code;
  final String groupName;
  final bool isActive;
  final bool isDeleted;

  const GetStrategiesResponseModel(
      {required this.id,
      required this.name,
      required this.code,
      required this.groupName,
      required this.isActive,
      required this.isDeleted});

  static GetStrategiesResponseModel fromJson(Map<String, dynamic> json) {
    return GetStrategiesResponseModel(
        id: json['id'],
        name: json['name'],
        code: json['code'],
        groupName: json['groupName'],
        isActive: json['isActive'],
        isDeleted: json['isDeleted']);
  }
}
