class TradingJournalModel {
  int? id;
   String? startDate;
  final String? mobileUserKey;
  final String? symbol;
  final bool? buySellButton;
  final double? capitalAmount;
  final double? riskPercentage;
  final double? riskAmount;
  final double? entryPrice;
  final double? stopLoss;
  final double? target1;
  final double? target2;
  final double? positionSize;
  final double? actualExit;
  final String? profitLoss;
  final String? riskReward;
  final String? notes;

  TradingJournalModel(
      {this.mobileUserKey,
      this.id,
      this.symbol,
      this.buySellButton,
      this.startDate,
      this.capitalAmount,
      this.riskPercentage,
      this.riskAmount,
      this.entryPrice,
      this.stopLoss,
      this.target1,
      this.target2,
      this.positionSize,
      this.profitLoss,
      this.riskReward,
      this.notes,
      this.actualExit});

  factory TradingJournalModel.fromJson(Map<String, dynamic> json) {
    return TradingJournalModel(
      id: json['id'] ?? 0,
      mobileUserKey: json['mobileUserKey'] ?? '',
      symbol: json['symbol'] ?? '',
      buySellButton: json['buySellButton'] ?? false,
      startDate: json['startDate'] ?? '',
      capitalAmount: json['capitalAmount'] ?? 0.0,
      riskPercentage: json['riskPercentage'] ?? 0.0,
      riskAmount: json['riskAmount'] ?? 0.0,
      entryPrice: json['entryPrice'] ?? 0.0,
      stopLoss: json['stopLoss'] ?? 0.0,
      target1: json['target1'] ?? 0.0,
      target2: json['target2'] ?? 0.0,
      positionSize: json['positionSize'] ?? 0.0,
      actualExit: json['actualExitPrice'] ?? 0.0,
      profitLoss: json['profitLoss'] ?? '',
      riskReward: json['riskReward'] ?? '',
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startDate': startDate,
      'mobileUserKey': mobileUserKey,
      'symbol': symbol,
      'buySellButton': buySellButton,
      'capitalAmount': capitalAmount,
      'riskPercentage': riskPercentage,
      'riskAmount': riskAmount,
      'entryPrice': entryPrice,
      'stopLoss': stopLoss,
      'target1': target1,
      'target2': target2,
      'positionSize': positionSize,
      'profitLoss': profitLoss,
      'riskReward': riskReward,
      'actualExitPrice': actualExit,
      'notes': notes
    };
  }

  copyWith({
    int? id,
    String? startDate,
    String? mobileUserKey,
    String? symbol,
    bool? buySellButton,
    double? capitalAmount,
    double? riskPercentage,
    double? riskAmount,
    double? entryPrice,
    double? stopLoss,
    double? target1,
    double? target2,
    double? positionSize,
    double? actualExit,
    String? profitLoss,
    String? riskReward,
    String? notes,
  }) {
    return TradingJournalModel(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      mobileUserKey: mobileUserKey ?? this.mobileUserKey,
      symbol: symbol ?? this.symbol,
      buySellButton: buySellButton ?? this.buySellButton,
      capitalAmount: capitalAmount ?? this.capitalAmount,
      riskPercentage: riskPercentage ?? this.riskPercentage,
      riskAmount: riskAmount ?? this.riskAmount,
      entryPrice: entryPrice ?? this.entryPrice,
      stopLoss: stopLoss ?? this.stopLoss,
      target1: target1 ?? this.target1,
      target2: target2 ?? this.target2,
      positionSize: positionSize ?? this.positionSize,
      actualExit: actualExit ?? this.actualExit,
      profitLoss: profitLoss ?? this.profitLoss,
      riskReward: riskReward ?? this.riskReward,
      notes: notes ?? this.notes,
    );
  }
}


