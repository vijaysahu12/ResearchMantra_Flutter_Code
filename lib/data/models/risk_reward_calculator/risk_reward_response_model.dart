class RiskRewardResponseModel {
  final double? riskAmount;
  final double? recommendedQuantity;
  final double? targetPrice;
  final double? profitAndLoss;
  final String? riskRewardRatio;

  RiskRewardResponseModel({
    this.riskAmount,
    this.recommendedQuantity,
    this.targetPrice,
    this.profitAndLoss,
    this.riskRewardRatio,
  });

  factory RiskRewardResponseModel.fromJson(Map<String, dynamic> json) {
    return RiskRewardResponseModel(
      riskAmount: (json['riskAmount'] as num?)?.toDouble() ?? 0.0,
      recommendedQuantity:
          (json["recommendedQuantity"] as num?)?.toDouble() ?? 0.0,
      targetPrice: (json['targetPrice'] as num?)?.toDouble() ?? 0.0,
      profitAndLoss: (json['profitAndLoss'] as num?)?.toDouble() ?? 0.0,
      riskRewardRatio: json['riskRewardRatio'] ?? "",
    );
  }
}
