class PartnerNamesModel {
  final String data;

  PartnerNamesModel({required this.data});

  factory PartnerNamesModel.fromJson(String json) {
    return PartnerNamesModel(
      data: json,
    );
  }
}
