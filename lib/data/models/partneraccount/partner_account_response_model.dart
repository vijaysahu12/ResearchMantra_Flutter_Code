

class PartnerAccountModel {
  final int id;
  final String partnerId;
  final String api;
  final String partnerName;

  final String secretKey;
  const PartnerAccountModel(
      {required this.id,
      required this.partnerId,
      required this.api,
      required this.partnerName,
      required this.secretKey});
  PartnerAccountModel copyWith({
    int? id,
    String? partnerId,
    String? api,
    String? partnerName,
    String? secretKey,
  }) {
    return PartnerAccountModel(
        id: id ?? this.id,
        partnerId: partnerId ?? this.partnerId,
        partnerName: partnerName ?? this.partnerName,
        api: api ?? this.api,
        secretKey: secretKey ?? this.secretKey);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'partnerId': partnerId,
      'partnerName': partnerName,
      'api': api,
      'secretKey': secretKey,
    };
  }

  factory PartnerAccountModel.fromJson(Map<String, dynamic> json) {
    return PartnerAccountModel(
      id: json['id'],
      partnerId: json['partnerId'],
      partnerName: json['partnerName'],
      api: json['api'],
      secretKey: json['secretKey'],
    );
  }
}
