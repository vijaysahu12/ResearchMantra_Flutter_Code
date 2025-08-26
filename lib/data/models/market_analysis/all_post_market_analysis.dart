import 'package:research_mantra_official/data/models/market_analysis/specifc_postmarket_analysis.dart';

class AllPostMarketStockReport {
  String? id;
  String? createdOn;
  BestPerformer? bestPerformer;
  WorstPerformer? worstPerformer;
  List<VolumeShocker>? volumeShocker;

  AllPostMarketStockReport({
    this.id,
    this.createdOn,
    this.bestPerformer,
    this.worstPerformer,
    this.volumeShocker,
  });

  factory AllPostMarketStockReport.fromJson(Map<String, dynamic> json) {
    return AllPostMarketStockReport(
      id: json['id'] as String?,
      createdOn: json['createdOn'] as String?,
      bestPerformer: json['bestPerformer'] != null
          ? BestPerformer.fromJson(json['bestPerformer'])
          : null,
      worstPerformer: json['worstPerformer'] != null
          ? WorstPerformer.fromJson(json['worstPerformer'])
          : null,
      volumeShocker: (json['volumeShocker'] as List<dynamic>?)
          ?.map((e) => VolumeShocker.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdOn': createdOn,
      'bestPerformer': bestPerformer?.toJson(),
      'worstPerformer': worstPerformer?.toJson(),
      'volumeShocker': volumeShocker?.map((e) => e.toJson()).toList(),
    };
  }
}

class BestPerformer {
  String? name;
  double? close;
  double? changePercentage;

  BestPerformer({
    this.name,
    this.close,
    this.changePercentage,
  });

  factory BestPerformer.fromJson(Map<String, dynamic> json) {
    return BestPerformer(
      name: json['name'] as String?,
      close: (json['close'] as num?)?.toDouble(),
      changePercentage: (json['changePercentage'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'close': close,
      'changePercentage': changePercentage,
    };
  }
}

class WorstPerformer {
  String? name;
  double? close;
  double? changePercentage;

  WorstPerformer({
    this.name,
    this.close,
    this.changePercentage,
  });

  factory WorstPerformer.fromJson(Map<String, dynamic> json) {
    return WorstPerformer(
      name: json['name'] as String?,
      close: (json['close'] as num?)?.toDouble(),
      changePercentage: (json['changePercentage'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'close': close,
      'changePercentage': changePercentage,
    };
  }
}
