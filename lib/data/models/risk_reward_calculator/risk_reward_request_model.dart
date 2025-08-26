
class RiskRewardRequestModel {
  final double? capitalAmount;
  final double? entryPrice;
  final double? stopLoss;
  final double? targetPrice;
  final double? riskFactor;
  final bool? isBuy;

  RiskRewardRequestModel({
    required this.capitalAmount,
    required this.riskFactor,
    required this.targetPrice,
    required this.entryPrice,
    required this.stopLoss,
    this.isBuy,
  });

  Map<String, dynamic> toJson() => {
        'capitalAmount': capitalAmount,
        'riskFactor': riskFactor,
        'entryPrice': entryPrice,
        'stopLoss': stopLoss,
        'targetPrice': targetPrice,
        'isBuy': isBuy
      };

}

