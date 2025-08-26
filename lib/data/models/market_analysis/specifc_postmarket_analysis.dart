
class PostMarketAnalysisStockData {
  List<Stock>? topGainers;
  List<Stock>? topLosers;
  List<Stock>? bestPerformer;
  List<Stock>? worstPerformer;
  List<VolumeShocker>? volumeShockerdata;

  PostMarketAnalysisStockData({
    this.topGainers,
    this.topLosers,
    this.bestPerformer,
    this.worstPerformer,
    this.volumeShockerdata,
  });

  factory PostMarketAnalysisStockData.fromJson(Map<String, dynamic> json) {
  
    return PostMarketAnalysisStockData(
      topGainers: (json['topGainers'] as List<dynamic>?)
          ?.map((e) => Stock.fromJson(e as Map<String, dynamic>))
          .toList(),
      topLosers: (json['topLosers'] as List<dynamic>?)
          ?.map((e) => Stock.fromJson(e as Map<String, dynamic>))
          .toList(),
      bestPerformer: (json['bestPerformer'] as List<dynamic>?)
          ?.map((e) => Stock.fromJson(e as Map<String, dynamic>))
          .toList(),
      worstPerformer: (json['worstPerformer'] as List<dynamic>?)
          ?.map((e) => Stock.fromJson(e as Map<String, dynamic>))
          .toList(),
      volumeShockerdata: (json['volumeShocker'] as List<dynamic>?)
          ?.map((e) => VolumeShocker.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'topGainers': topGainers?.map((e) => e.toJson()).toList(),
      'topLosers': topLosers?.map((e) => e.toJson()).toList(),
      'bestPerformer': bestPerformer?.map((e) => e.toJson()).toList(),
      'worstPerformer': worstPerformer?.map((e) => e.toJson()).toList(),
      'volumeShocker': volumeShockerdata?.map((e) => e.toJson()).toList(),
    };
  }
}

class Stock {
  String? name;
  double? close;
  double? changePercentage;
  

  Stock({
    this.name,
    this.close,
    this.changePercentage,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
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

class VolumeShocker {
  String? name;
  double? close;
  int? volume;

  VolumeShocker({
    this.name,
    this.close,
    this.volume,
  });

  factory VolumeShocker.fromJson(Map<String, dynamic> json) {
    return VolumeShocker(
      name: json['name'] as String?,
      close: (json['close'] as num?)?.toDouble(),
      volume: json['volume'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'close': close,
      'volume': volume,
    };
  }
}
