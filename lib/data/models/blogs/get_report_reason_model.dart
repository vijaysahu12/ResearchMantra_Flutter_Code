class GetReportReasonModel {
  final String? id;
  final String? reason;
  const GetReportReasonModel({this.id, this.reason});
  GetReportReasonModel copyWith({String? id, String? reason}) {
    return GetReportReasonModel(
        id: id ?? this.id, reason: reason ?? this.reason);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'reason': reason};
  }

  static GetReportReasonModel fromJson(Map<String, dynamic> json) {
    return GetReportReasonModel(
        id: json['id'] == null ? null : json['id'] as String,
        reason: json['reason'] == null ? null : json['reason'] as String);
  }
}
