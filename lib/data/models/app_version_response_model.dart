class AppVersionResponseModel {
  final bool updateRequired;
  final String message;
  const AppVersionResponseModel(
      {required this.updateRequired, required this.message});

  Map<String, dynamic> toJson() {
    return {'updateRequired': updateRequired, 'message': message};
  }

  static AppVersionResponseModel fromJson(Map<String, dynamic> json) {
    return AppVersionResponseModel(
        updateRequired: json['updateRequired'] ?? false,
        message: json['message'] ?? '');
  }
}
