class NotificationCategoryResponseModel {
  final int id;
  final String name;

  NotificationCategoryResponseModel({required this.id, required this.name});

  factory NotificationCategoryResponseModel.fromJson(
      Map<String, dynamic> json) {
    return NotificationCategoryResponseModel(
        id: json['id'], name: json['name']);
  }
}
