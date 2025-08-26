class PreMarketAnalysisData {
  String? id;
  GlobalIndices? globalIndices;
  IndianIndices? indianIndices;
  Commodities? commodities;
  List<FiiDiiData>? fiiDiiData;
  SupportResistance? supportResistance;
  MarketBulletins? newsBulletins;
  MarketSentiment?marketSentiment;
  NiftyGiftNiftyData? niftyGiftNiftyData;
  List<IndicatorSupport>? indicatorSupport;
  IndiaVix? indiaVix;
  String? createdOn;
  double? bullish;
  double? bearish;

  PreMarketAnalysisData({
    this.id,
    this.globalIndices,
    this.indianIndices,
    this.commodities,
    this.fiiDiiData,
    this.supportResistance,
    this.newsBulletins,
    this.niftyGiftNiftyData,
    this.indicatorSupport,
    this.indiaVix,
    this.createdOn,
    this.bullish,
    this.bearish,
    this.marketSentiment,
  });

  factory PreMarketAnalysisData.fromJson(Map<String, dynamic> json) {

    return PreMarketAnalysisData(
      id: json['id'],
      globalIndices: json['globalIndices'] != null
          ? GlobalIndices.fromJson(json['globalIndices'])
          : null,
      indianIndices: json['indianIndices'] != null
          ? IndianIndices.fromJson(json['indianIndices'])
          : null,
      commodities: json['commodities'] != null
          ? Commodities.fromJson(json['commodities'])
          : null,
      fiiDiiData: (json['fiiDiiData'] as List?)
          ?.map((e) => FiiDiiData.fromJson(e))
          .toList(),
      supportResistance: json['supportResistance'] != null
          ? SupportResistance.fromJson(json['supportResistance'])
          : null,
      newsBulletins: json['newsBulletins'] != null
          ? MarketBulletins.fromJson(json['newsBulletins'])
          : null,
        marketSentiment: json['marketSentiment'] != null
          ? MarketSentiment.fromJson(json['marketSentiment'])
          : null,
      niftyGiftNiftyData: json['niftyGiftNiftyData'] != null
          ? NiftyGiftNiftyData.fromJson(json['niftyGiftNiftyData'])
          : null,
      indicatorSupport: (json['indicatorSupport'] as List?)
          ?.map((e) => IndicatorSupport.fromJson(e))
          .toList(),
      indiaVix: json['indiaVix'] != null
          ? IndiaVix.fromJson(json['indiaVix'])
          : null,
      createdOn: json['createdOn'],
      bullish: json['bullish']?.toDouble(),
      bearish: json['bearish']?.toDouble(),
    );
    
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'globalIndices': globalIndices?.toJson(),
      'indianIndices': indianIndices?.toJson(),
      'commodities': commodities?.toJson(),
      'fiiDiiData': fiiDiiData?.map((e) => e.toJson()).toList(),
      'supportResistance': supportResistance?.toJson(),
      'marketBulletins': newsBulletins?.toJson(),
      'niftyGiftNiftyData': niftyGiftNiftyData?.toJson(),
      'indicatorSupport': indicatorSupport?.map((e) => e.toJson()).toList(),
      'indiaVix': indiaVix?.toJson(),
      'createdOn': createdOn,
      'bullish': bullish,
      'bearish': bearish,
      'marketSentiment':marketSentiment?.toJson(),
    };
  }
}

class GlobalIndices {
  double? bullish;
  double? bearish;
  List<Index>? data;

  GlobalIndices({
    this.bullish,
    this.bearish,
    this.data,
  });

  factory GlobalIndices.fromJson(Map<String, dynamic> json) {
    return GlobalIndices(
      bullish: json['bullish']?.toDouble(),
      bearish: json['bearish']?.toDouble(),
      data: (json['data'] as List?)
          ?.map((e) => Index.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bullish': bullish,
      'bearish': bearish,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class IndianIndices {
  double? bullish;
  double? bearish;
  List<Index>? data;

  IndianIndices({
    this.bullish,
    this.bearish,
    this.data,
  });

  factory IndianIndices.fromJson(Map<String, dynamic> json) {
    return IndianIndices(
      bullish: json['bullish']?.toDouble(),
      bearish: json['bearish']?.toDouble(),
      data: (json['data'] as List?)
          ?.map((e) => Index.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bullish': bullish,
      'bearish': bearish,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class Index {
  String? name;
  String? continent;
  double? close;
  double? change;
  double? changePercentage;

  Index({
    this.name,
    this.continent,
    this.close,
    this.change,
    this.changePercentage,
  });

  factory Index.fromJson(Map<String, dynamic> json) {
    return Index(
      name: json['name'],
      continent: json['continent'],
      close: json['close']?.toDouble(),
      change: json['change']?.toDouble(),
      changePercentage: json['changePercentage']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'continent': continent,
      'close': close,
      'change': change,
      'changePercentage': changePercentage,
    };
  }
}

class Commodities {
  double? bullish;
  double? bearish;
  final Commodity ?gold;
  final Commodity ?silver;
  final Commodity ?crudeoil;

  Commodities({
    this.bullish,
    this.bearish,
     this.gold,
     this.silver,
   this.crudeoil
  });

  factory Commodities.fromJson(Map<String, dynamic> json) {
    return Commodities(
      bullish: json['bullish']?.toDouble(),
      bearish: json['bearish']?.toDouble(),
gold: json['commodity']?['gold'] != null ? Commodity.fromJson(json['commodity']['gold']) : null,
      silver: json['commodity']?['silver'] != null ? Commodity.fromJson(json['commodity']['silver']) : null,
      crudeoil: json['commodity']?['crudeoil'] != null ? Commodity.fromJson(json['commodity']['crudeoil']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bullish': bullish,
      'bearish': bearish,
     'commodity': {
        'gold': gold?.toJson(),
        'silver': silver?.toJson(),
        'crudeoil': crudeoil?.toJson(),
      },
    };
  }
}

class Commodity {
  String? name;
  double? close;
  double? change;
  double? changePercentage;

  Commodity({
    this.name,
    this.close,
    this.change,
    this.changePercentage,
  });

  factory Commodity.fromJson(Map<String, dynamic> json) {
    return Commodity(
      name: json['name'],
      close: json['close']?.toDouble(),
      change: json['change']?.toDouble(),
      changePercentage: json['changePercentage']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'ltp': close,
      'change': change,
      'changePercentage': changePercentage,
    };
  }
}

class FiiDiiData {
  String? name;
  String? date;
  String? buyValue;
  String? sellValue;
  String? netValue;

  FiiDiiData({
    this.name,
    this.date,
    this.buyValue,
    this.sellValue,
    this.netValue,
  });

  factory FiiDiiData.fromJson(Map<String, dynamic> json) {
    return FiiDiiData(
      name: json['name'],
      date: json['date'],
      buyValue: json['buyValue'],
      sellValue: json['sellValue'],
      netValue: json['netValue'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'date': date,
      'buyValue': buyValue,
      'sellValue': sellValue,
      'netValue': netValue,
    };
  }
}

class SupportResistance {
  String? name;
  double? support;
  double? resistance;
  double? pivot;

  SupportResistance({
    this.name,
    this.support,
    this.resistance,
    this.pivot,
  });

  factory SupportResistance.fromJson(Map<String, dynamic> json) {
    return SupportResistance(
      name: json['name'],
      support: json['support']?.toDouble(),
      resistance: json['resistance']?.toDouble(),
      pivot: json['pivot']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'support': support,
      'resistance': resistance,
      'pivot': pivot,
    };
  }
}

class MarketBulletins {
  List<String>? bulletins;

  MarketBulletins({
    this.bulletins,
  });

  factory MarketBulletins.fromJson(Map<String, dynamic> json) {
    return MarketBulletins(
      bulletins: (json['bulletins'] as List?)?.map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bulletins': bulletins,
    };
  }
}
class MarketSentiment {
  // Nullable fields
  List<String>? sentimentAnalysis;

  // Constructor
  MarketSentiment({this.sentimentAnalysis});

  // Factory method to create an instance from JSON
  factory MarketSentiment.fromJson(Map<String, dynamic> json) {
    return MarketSentiment(
      sentimentAnalysis: json['sentimentAnalysis'] != null
          ? (json['sentimentAnalysis'] as List?)?.map((e) => e as String).toList()
          : null,
    );
  }

  // Method to convert the object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'sentimentAnalysis': sentimentAnalysis,
    };
  }
}

class NiftyGiftNiftyData {
  double? niftyLastClose;
  double? giftniftyPrice;
  double? priceDifference;

  NiftyGiftNiftyData({
    this.niftyLastClose,
    this.giftniftyPrice,
    this.priceDifference,
  });

  factory NiftyGiftNiftyData.fromJson(Map<String, dynamic> json) {
    return NiftyGiftNiftyData(
      niftyLastClose: json['niftyLastClose']?.toDouble(),
      giftniftyPrice: json['giftniftyPrice']?.toDouble(),
      priceDifference: json['priceDifference']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'niftyLastClose': niftyLastClose,
      'giftniftyPrice': giftniftyPrice,
      'priceDifference': priceDifference,
    };
  }
}

class IndicatorSupport {
  String? name;
  double? ltp;
  double? emA_20;
  double? emA_50;
  double? rsi;

  IndicatorSupport({
    this.name,
    this.ltp,
    this.emA_20,
    this.emA_50,
    this.rsi,
  });

  factory IndicatorSupport.fromJson(Map<String, dynamic> json) {
    return IndicatorSupport(
      name: json['name'],
      ltp: json['ltp']?.toDouble(),
      emA_20: json['emA_20']?.toDouble(),
      emA_50: json['emA_50']?.toDouble(),
      rsi: json['rsi']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'ltp': ltp,
      'emA_20': emA_20,
      'emA_50': emA_50,
      'rsi': rsi,
    };
  }
}

class IndiaVix {
  String? name;
  double? ltp;
  double? change;

  IndiaVix({
    this.name,
    this.ltp,
    this.change,
  });

  factory IndiaVix.fromJson(Map<String, dynamic> json) {
    return IndiaVix(
      name: json['name'],
      ltp: json['ltp']?.toDouble(),
      change: json['change']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'ltp': ltp,
      'change': change,
    };
  }
}
