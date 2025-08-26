class SipResponseModel {
  final double? expectedAmount;
  final double? amountInvested;
  final double? wealthGain;
  final double? inflationRate;
  final List<ProjectedSipReturns>? projectedSipReturnsTable;

  SipResponseModel({
    required this.expectedAmount,
    required this.amountInvested,
    required this.wealthGain,
    required this.projectedSipReturnsTable,
    this.inflationRate,
  });

  factory SipResponseModel.fromJson(Map<String, dynamic> json) {
    return SipResponseModel(
      expectedAmount: (json["expectedAmount"] as num?)?.toDouble() ?? 0.0,
      amountInvested: (json['amountInvested'] as num?)?.toDouble() ?? 0.0,
      wealthGain: (json['wealthGain'] as num?)?.toDouble() ?? 0.0,
      inflationRate: (json["inflationRate"] as num?)?.toDouble() ?? 0.0,
      projectedSipReturnsTable: (json['projectedSipReturnsTable'] as List?)
              ?.map((e) => ProjectedSipReturns.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'expectedAmount': expectedAmount,
      'amountInvested': amountInvested,
      'wealthGain': wealthGain,
      'projectedSipReturnsTable':
          projectedSipReturnsTable!.map((e) => e.toJson()).toList(),
    };
  }
}

//  {
//       "duration": 1,
//       "sipAmount": 1000,
//       "investedAmount": 12000,
//       "totalInvestedAmount": 12000,
//       "incrementalRateInFuture": 0,
//       "futureValue": 12565.57
//     },

class ProjectedSipReturns {
  final int duration;
  final double investedAmount;
  final double totalInvestedAmount;
  final double incrementalRateInFuture;
  final double sipAmount;
  final double futureValue;

  ProjectedSipReturns({
    required this.investedAmount,
    required this.totalInvestedAmount,
    required this.incrementalRateInFuture,
    required this.duration,
    required this.sipAmount,
    required this.futureValue,
  });

  factory ProjectedSipReturns.fromJson(Map<String, dynamic> json) {
    return ProjectedSipReturns(
      duration: json['duration'] as int? ?? 0,
      investedAmount: (json['investedAmount'] as num?)?.toDouble() ?? 0.0,
      totalInvestedAmount:
          (json['totalInvestedAmount'] as num?)?.toDouble() ?? 0.0,
      incrementalRateInFuture:
          (json['incrementalRateInFuture'] as num?)?.toDouble() ?? 0.0,
      sipAmount: (json['sipAmount'] as num?)?.toDouble() ?? 0.0,
      futureValue: (json['futureValue'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'duration': duration,
      'sipAmount': sipAmount,
      'futureValue': futureValue,
      'investedAmount': investedAmount,
      'totalInvestedAmount': totalInvestedAmount,
      'incrementalRateInFuture': incrementalRateInFuture
    };
  }
}
