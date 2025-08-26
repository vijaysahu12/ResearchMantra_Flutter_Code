class ActivateFreeTrialResponseModel {
  final String? result;
  final String? message;
  const ActivateFreeTrialResponseModel({this.result, this.message});
  ActivateFreeTrialResponseModel copyWith({String? result, String? message}) {
    return ActivateFreeTrialResponseModel(
        result: result ?? this.result, message: message ?? this.message);
  }

  Map<String, dynamic> toJson() {
    return {'result': result, 'message': message};
  }

  static ActivateFreeTrialResponseModel fromJson(Map<String,dynamic> json) {
    return ActivateFreeTrialResponseModel(
        result: json['result'] == null ? null : json['result'] as String,
        message: json['message'] == null ? null : json['message'] as String);
  }
}
