class GetPlansResponseModel {
  final String planName;
  final int id;
  final String? ageTitle;
  final String? ageLabel;
  final int? retirementAge;
  final String? retirementTitle;
  final String? currentExpensesTitle;
  final String? currentExpensesLabel;
  final String? apiName;
  final bool visible;

  const GetPlansResponseModel(
      {required this.planName,
      required this.id,
      this.ageTitle,
      this.ageLabel,
      this.retirementAge,
      this.retirementTitle,
      this.currentExpensesTitle,
      this.currentExpensesLabel,
      this.apiName,
      required this.visible});

  factory GetPlansResponseModel.fromJson(Map<String, dynamic> json) {
    return GetPlansResponseModel(
      planName: json['planName'] as String? ?? '',
      id: json['id'] as int? ?? 0,
      ageTitle: json['ageTitle'] as String?,
      ageLabel: json['ageLabel'] as String?,
      retirementAge: json['retirementAge'] as int?,
      retirementTitle: json['retirementTitle'] as String?,
      currentExpensesTitle: json['currentExpensesTitle'] as String?,
      currentExpensesLabel: json['currentExpensesLabel'] as String?,
      apiName: json['apiName'] ?? '',
      visible: json['visible'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'planName': planName,
      'id': id,
      'ageTitle': ageTitle,
      'ageLabel': ageLabel,
      'retirementAge': retirementAge,
      'retirementTitle': retirementTitle,
      'currentExpensesTitle': currentExpensesTitle,
      'currentExpensesLabel': currentExpensesLabel,
      'visible': visible,
      'apiName': apiName
    };
  }
}
