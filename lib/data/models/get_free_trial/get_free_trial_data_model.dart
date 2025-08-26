class GetFreeTrialDataModel {
  final String trialName;
  final int trialInDays;
  final List<dynamic> data;
  const GetFreeTrialDataModel(
      {required this.trialName, required this.trialInDays, required this.data});

  Map<String, dynamic> toJson() {
    return {'trialName': trialName, 'trialInDays': trialInDays, 'data': data};
  }

  static GetFreeTrialDataModel fromJson(Map<String, dynamic> json) {
    return GetFreeTrialDataModel(
        trialName: json['trialName'] ?? "",
        trialInDays: json['trialInDays'] ?? '',
        data: json['data'] ?? []);
  }
}
