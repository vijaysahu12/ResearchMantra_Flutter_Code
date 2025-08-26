// class ResearchDataModel {
//   final num? companyId;
//   final String? symbol;
//   final String? name;
//   final String? description;
//   final String? chartUrl;
//   final String? otherUrl;
//   final String? websiteUrl;
//   final int? companyCount;
//   int? commentCount;
//   final CompanyType? companyType;
//   final List<LastOneYearMonthlyPrices>? lastOneYearMonthlyPrices;
//   final List<LastTenYearSales>? lastTenYearSales;
//   final String? publishDate; // Added publishedDate

//   ResearchDataModel({
//     this.companyId,
//     this.symbol,
//     this.name,
//     this.description,
//     this.chartUrl,
//     this.otherUrl,
//     this.websiteUrl,
//     this.companyCount,
//     this.commentCount,
//     this.companyType,
//     this.lastOneYearMonthlyPrices,
//     this.lastTenYearSales,
//     this.publishDate, // Added publishedDate to constructor
//   });

//   ResearchDataModel copyWith({
//     num? companyId,
//     String? symbol,
//     String? name,
//     String? description,
//     String? chartUrl,
//     String? otherUrl,
//     String? websiteUrl,
//     int? companyCount,
//     int? commentCount,
//     CompanyType? companyType,
//     List<LastOneYearMonthlyPrices>? lastOneYearMonthlyPrices,
//     List<LastTenYearSales>? lastTenYearSales,
//     String? publishDate, // Added publishedDate to copyWith
//   }) {
//     return ResearchDataModel(
//       companyId: companyId ?? this.companyId,
//       symbol: symbol ?? this.symbol,
//       name: name ?? this.name,
//       description: description ?? this.description,
//       chartUrl: chartUrl ?? this.chartUrl,
//       otherUrl: otherUrl ?? this.otherUrl,
//       websiteUrl: websiteUrl ?? this.websiteUrl,
//       companyCount: companyCount ?? this.companyCount,
//       commentCount: commentCount ?? this.commentCount,
//       companyType: companyType ?? this.companyType,
//       lastOneYearMonthlyPrices:
//           lastOneYearMonthlyPrices ?? this.lastOneYearMonthlyPrices,
//       lastTenYearSales: lastTenYearSales ?? this.lastTenYearSales,
//       publishDate: publishDate ??
//           this.publishDate, // Updated to copy the value of publishedDate
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'companyId': companyId,
//       'symbol': symbol,
//       'name': name,
//       'description': description,
//       'chartUrl': chartUrl,
//       'otherUrl': otherUrl,
//       'websiteUrl': websiteUrl,
//       'companyCount': companyCount,
//       'commentCount': commentCount,
//       'companyType': companyType?.toJson(),
//       'lastOneYearMonthlyPrices': lastOneYearMonthlyPrices
//           ?.map<Map<String, dynamic>>((data) => data.toJson())
//           .toList(),
//       'lastTenYearSales': lastTenYearSales
//           ?.map<Map<String, dynamic>>((data) => data.toJson())
//           .toList(),
//       'publishDate': publishDate, // Converting DateTime to string
//     };
//   }

//   static ResearchDataModel fromJson(Map<String, dynamic> json) {
//     return ResearchDataModel(
//       companyId: json['companyId'],
//       symbol: json['symbol'],
//       name: json['name'],
//       description: json['description'],
//       chartUrl: json['chartUrl'],
//       otherUrl: json['otherUrl'],
//       websiteUrl: json['websiteUrl'],
//       companyCount: json['companyCount'],
//       commentCount: json['commentCount'],
//       companyType: json['companyType'] == null
//           ? null
//           : CompanyType.fromJson(json['companyType']),
//       lastOneYearMonthlyPrices: json['lastOneYearMonthlyPrices'] == null
//           ? null
//           : (json['lastOneYearMonthlyPrices'] as List)
//               .map<LastOneYearMonthlyPrices>(
//                   (data) => LastOneYearMonthlyPrices.fromJson(data))
//               .toList(),
//       lastTenYearSales: json['lastTenYearSales'] == null
//           ? null
//           : (json['lastTenYearSales'] as List)
//               .map<LastTenYearSales>((data) => LastTenYearSales.fromJson(data))
//               .toList(),
//       publishDate: json['publishDate'] == null
//           ? null
//           : json['publishDate'], // Parsing publishedDate
//     );
//   }
// }

// class LastTenYearSales {
//   final num? id;
//   final num? companyId;
//   final String? year;
//   final String? symbol;
//   final String? sales;
//   final String? opProfit;
//   final String? netProfit;
//   final String? otm;
//   final String? npm;
//   final String? promotersPercent;

//   const LastTenYearSales({
//     this.id,
//     this.companyId,
//     this.year,
//     this.symbol,
//     this.sales,
//     this.opProfit,
//     this.netProfit,
//     this.otm,
//     this.npm,
//     this.promotersPercent,
//   });

//   LastTenYearSales copyWith({
//     num? id,
//     num? companyId,
//     String? year,
//     String? symbol,
//     String? sales,
//     String? opProfit,
//     String? netProfit,
//     String? otm,
//     String? npm,
//     String? promotersPercent,
//   }) {
//     return LastTenYearSales(
//       id: id ?? this.id,
//       companyId: companyId ?? this.companyId,
//       year: year ?? this.year,
//       symbol: symbol ?? this.symbol,
//       sales: sales ?? this.sales,
//       opProfit: opProfit ?? this.opProfit,
//       netProfit: netProfit ?? this.netProfit,
//       otm: otm ?? this.otm,
//       npm: npm ?? this.npm,
//       promotersPercent: promotersPercent ?? this.promotersPercent,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'companyId': companyId,
//       'year': year,
//       'symbol': symbol,
//       'sales': sales,
//       'opProfit': opProfit,
//       'netProfit': netProfit,
//       'otm': otm,
//       'npm': npm,
//       'promotersPercent': promotersPercent,
//     };
//   }

//   static LastTenYearSales fromJson(Map<String, dynamic> json) {
//     return LastTenYearSales(
//       id: json['id'],
//       companyId: json['companyId'],
//       year: json['year'],
//       symbol: json['symbol'],
//       sales: json['sales'],
//       opProfit: json['opProfit'],
//       netProfit: json['netProfit'],
//       otm: json['otm'],
//       npm: json['npm'],
//       promotersPercent: json['promotersPercent'],
//     );
//   }
// }

// class LastOneYearMonthlyPrices {
//   final num? id;
//   final num? companyId;
//   final String? symbol;
//   final String? month;
//   final num? price;

//   const LastOneYearMonthlyPrices({
//     this.id,
//     this.companyId,
//     this.symbol,
//     this.month,
//     this.price,
//   });

//   LastOneYearMonthlyPrices copyWith({
//     num? id,
//     num? companyId,
//     String? symbol,
//     String? month,
//     num? price,
//   }) {
//     return LastOneYearMonthlyPrices(
//       id: id ?? this.id,
//       companyId: companyId ?? this.companyId,
//       symbol: symbol ?? this.symbol,
//       month: month ?? this.month,
//       price: price ?? this.price,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'companyId': companyId,
//       'symbol': symbol,
//       'month': month,
//       'price': price,
//     };
//   }

//   static LastOneYearMonthlyPrices fromJson(Map<String, dynamic> json) {
//     return LastOneYearMonthlyPrices(
//       id: json['id'],
//       companyId: json['companyId'],
//       symbol: json['symbol'],
//       month: json['month'],
//       price: json['price'],
//     );
//   }
// }

// class CompanyType {
//   final num? id;
//   final num? companyId;
//   final String? symbol;
//   final bool? ltopUptrend;
//   final bool? stopOpUpTrend;
//   final bool? futuristicSector;
//   final bool? hniInstitutionalPromotersBuy;
//   final bool? specialSituations;
//   final bool? futureVisibility;

//   const CompanyType({
//     this.id,
//     this.companyId,
//     this.symbol,
//     this.ltopUptrend,
//     this.stopOpUpTrend,
//     this.futuristicSector,
//     this.hniInstitutionalPromotersBuy,
//     this.specialSituations,
//     this.futureVisibility,
//   });

//   CompanyType copyWith({
//     num? id,
//     num? companyId,
//     String? symbol,
//     bool? ltopUptrend,
//     bool? stopOpUpTrend,
//     bool? futuristicSector,
//     bool? hniInstitutionalPromotersBuy,
//     bool? specialSituations,
//     bool? futureVisibility,
//   }) {
//     return CompanyType(
//       id: id ?? this.id,
//       companyId: companyId ?? this.companyId,
//       symbol: symbol ?? this.symbol,
//       ltopUptrend: ltopUptrend ?? this.ltopUptrend,
//       stopOpUpTrend: stopOpUpTrend ?? this.stopOpUpTrend,
//       futuristicSector: futuristicSector ?? this.futuristicSector,
//       hniInstitutionalPromotersBuy:
//           hniInstitutionalPromotersBuy ?? this.hniInstitutionalPromotersBuy,
//       specialSituations: specialSituations ?? this.specialSituations,
//       futureVisibility: futureVisibility ?? this.futureVisibility,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'companyId': companyId,
//       'symbol': symbol,
//       'ltopUptrend': ltopUptrend,
//       'stopOpUpTrend': stopOpUpTrend,
//       'futuristicSector': futuristicSector,
//       'hniInstitutionalPromotersBuy': hniInstitutionalPromotersBuy,
//       'specialSituations': specialSituations,
//       'futureVisibility': futureVisibility,
//     };
//   }

//   static CompanyType fromJson(Map<String, dynamic> json) {
//     return CompanyType(
//       id: json['id'],
//       companyId: json['companyId'],
//       symbol: json['symbol'],
//       ltopUptrend: json['ltopUptrend'],
//       stopOpUpTrend: json['stopOpUpTrend'],
//       futuristicSector: json['futuristicSector'],
//       hniInstitutionalPromotersBuy: json['hniInstitutionalPromotersBuy'],
//       specialSituations: json['specialSituations'],
//       futureVisibility: json['futureVisibility'],
//     );
//   }
// }
class ResearchDataModel {
  final num? companyId;
  final String? symbol;
  final String? name;
  final String? description;
  final String? chartUrl;
  final String? otherUrl;
  final String? websiteUrl;
  final int? companyCount;
  int? commentCount;

  final String? publishDate;
  final double? faceValue;
  final double? promotersHolding;
  final double? profitGrowth;
  final double? currentPrice;
  final CompanyType? companyType;
  final List<LastOneYearMonthlyPrices>? lastOneYearMonthlyPrices;
  final List<LastTenYearSales>? lastTenYearSales;
  ResearchDataModel({
    this.companyId,
    this.name,
    this.description,
    this.chartUrl,
    this.otherUrl,
    this.websiteUrl,
    this.companyType,
    this.lastOneYearMonthlyPrices,
    this.companyCount,
    this.symbol,
    this.lastTenYearSales,
    this.commentCount,
    this.publishDate,
    this.faceValue,
    this.promotersHolding,
    this.profitGrowth,
    this.currentPrice,
  });
  ResearchDataModel copyWith(
      {num? companyId,
      String? name,
      String? description,
      String? chartUrl,
      String? otherUrl,
      String? websiteUrl,
      int? companyCount,
      int? commentCount,
      String? symbol,
      CompanyType? companyType,
      String? publishDate,
      double? faceValue,
      double? promotersHolding,
      double? profitGrowth,
      double? currentPrice,
      List<LastOneYearMonthlyPrices>? lastOneYearMonthlyPrices,
      List<LastTenYearSales>? lastTenYearSales}) {
    return ResearchDataModel(
      symbol: symbol ?? this.symbol,
      companyId: companyId ?? this.companyId,
      name: name ?? this.name,
      description: description ?? this.description,
      chartUrl: chartUrl ?? this.chartUrl,
      otherUrl: otherUrl ?? this.otherUrl,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      companyType: companyType ?? this.companyType,
      lastOneYearMonthlyPrices:
          lastOneYearMonthlyPrices ?? this.lastOneYearMonthlyPrices,
      companyCount: companyCount ?? this.companyCount,
      lastTenYearSales: lastTenYearSales ?? this.lastTenYearSales,
      commentCount: commentCount ?? this.commentCount,
      publishDate: publishDate ?? this.publishDate,
      faceValue: faceValue ?? this.faceValue,
      promotersHolding: promotersHolding ?? this.promotersHolding,
      profitGrowth: profitGrowth ?? this.profitGrowth,
      currentPrice: currentPrice ?? this.currentPrice,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'companyId': companyId,
      'name': name,
      'description': description,
      'chartUrl': chartUrl,
      'otherUrl': otherUrl,
      'websiteUrl': websiteUrl,
      'companyType': companyType?.toJson(),
      "companyCount": companyCount,
      'symbol': symbol,
      'lastOneYearMonthlyPrices': lastOneYearMonthlyPrices
          ?.map<Map<String, dynamic>>((data) => data.toJson())
          .toList(),
      'lastTenYearSales': lastTenYearSales
          ?.map<Map<String, dynamic>>((data) => data.toJson())
          .toList(),
      'commentCount': commentCount
    };
  }

  static ResearchDataModel fromJson(Map<String, dynamic> json) {
    return ResearchDataModel(
      commentCount:
          json['commentCount'] == null ? null : json['commentCount'] as int,
      symbol: json['symbol'] == null ? null : json['symbol'] as String,
      companyCount:
          json['companyCount'] == null ? null : json['companyCount'] as int,
      companyId: json['companyId'] == null ? null : json['companyId'] as num,
      name: json['name'] == null ? null : json['name'] as String,
      description:
          json['description'] == null ? null : json['description'] as String,
      chartUrl: json['chartUrl'] == null ? null : json['chartUrl'] as String,
      otherUrl: json['otherUrl'] == null ? null : json['otherUrl'] as String,
      websiteUrl:
          json['websiteUrl'] == null ? null : json['websiteUrl'] as String,
      companyType: json['companyType'] == null
          ? null
          : CompanyType.fromJson(json['companyType'] as Map<String, dynamic>),
      lastOneYearMonthlyPrices: json['lastOneYearMonthlyPrices'] == null
          ? null
          : (json['lastOneYearMonthlyPrices'] as List)
              .map<LastOneYearMonthlyPrices>((data) =>
                  LastOneYearMonthlyPrices.fromJson(
                      data as Map<String, dynamic>))
              .toList(),
      lastTenYearSales: json['lastTenYearSales'] == null
          ? null
          : (json['lastTenYearSales'] as List)
              .map<LastTenYearSales>((data) =>
                  LastTenYearSales.fromJson(data as Map<String, dynamic>))
              .toList(),
      publishDate:
          json['publishDate'] == null ? null : json['publishDate'] as String,
      faceValue: json['faceValue'] == null ? null : json['faceValue'] as double,
      promotersHolding: json['promotersHolding'] == null
          ? null
          : json['promotersHolding'] as double,
      profitGrowth:
          json['profitGrowth'] == null ? null : json['profitGrowth'] as double,
      currentPrice:
          json['currentPrice'] == null ? null : json['currentPrice'] as double,
    );
  }
}

class LastTenYearSales {
  final num? id;
  final num? companyId;
  final String? year;
  final String? symbol;
  final String? sales;
  final String? opProfit;
  final String? netProfit;
  final String? otm;
  final String? npm;
  final String? promotersPercent;
  const LastTenYearSales(
      {this.id,
      this.companyId,
      this.year,
      this.symbol,
      this.sales,
      this.opProfit,
      this.netProfit,
      this.otm,
      this.npm,
      this.promotersPercent});
  LastTenYearSales copyWith(
      {num? id,
      num? companyId,
      String? year,
      String? symbol,
      String? sales,
      String? opProfit,
      String? netProfit,
      String? otm,
      String? npm,
      String? promotersPercent}) {
    return LastTenYearSales(
        id: id ?? this.id,
        companyId: companyId ?? this.companyId,
        year: year ?? this.year,
        symbol: symbol ?? this.symbol,
        sales: sales ?? this.sales,
        opProfit: opProfit ?? this.opProfit,
        netProfit: netProfit ?? this.netProfit,
        otm: otm ?? this.otm,
        npm: npm ?? this.npm,
        promotersPercent: promotersPercent ?? this.promotersPercent);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyId': companyId,
      'year': year,
      'symbol': symbol,
      'sales': sales,
      'opProfit': opProfit,
      'netProfit': netProfit,
      'otm': otm,
      'npm': npm,
      'promotersPercent': promotersPercent
    };
  }

  static LastTenYearSales fromJson(Map<String, dynamic> json) {
    return LastTenYearSales(
        id: json['id'] == null ? null : json['id'] as num,
        companyId: json['companyId'] == null ? null : json['companyId'] as num,
        year: json['year'] == null ? null : json['year'] as String,
        symbol: json['symbol'] == null ? null : json['symbol'] as String,
        sales: json['sales'] == null ? null : json['sales'] as String,
        opProfit: json['opProfit'] == null ? null : json['opProfit'] as String,
        netProfit:
            json['netProfit'] == null ? null : json['netProfit'] as String,
        otm: json['otm'] == null ? null : json['otm'] as String,
        npm: json['npm'] == null ? null : json['npm'] as String,
        promotersPercent: json['promotersPercent'] == null
            ? null
            : json['promotersPercent'] as String);
  }
}

class LastOneYearMonthlyPrices {
  final num? id;
  final num? companyId;
  final String? symbol;
  final String? month;
  final num? price;
  const LastOneYearMonthlyPrices(
      {this.id, this.companyId, this.symbol, this.month, this.price});
  LastOneYearMonthlyPrices copyWith(
      {num? id, num? companyId, String? symbol, String? month, num? price}) {
    return LastOneYearMonthlyPrices(
        id: id ?? this.id,
        companyId: companyId ?? this.companyId,
        symbol: symbol ?? this.symbol,
        month: month ?? this.month,
        price: price ?? this.price);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyId': companyId,
      'symbol': symbol,
      'month': month,
      'price': price
    };
  }

  static LastOneYearMonthlyPrices fromJson(Map<String, dynamic> json) {
    return LastOneYearMonthlyPrices(
        id: json['id'] == null ? null : json['id'] as num,
        companyId: json['companyId'] == null ? null : json['companyId'] as num,
        symbol: json['symbol'] == null ? null : json['symbol'] as String,
        month: json['month'] == null ? null : json['month'] as String,
        price: json['price'] == null ? null : json['price'] as num);
  }
}

class CompanyType {
  final num? id;
  final num? companyId;
  final String? symbol;
  final bool? ltopUptrend;
  final bool? stopOpUpTrend;
  final bool? futuristicSector;
  final bool? hniInstitutionalPromotersBuy;
  final bool? specialSituations;
  final bool? futureVisibility;
  const CompanyType(
      {this.id,
      this.companyId,
      this.symbol,
      this.ltopUptrend,
      this.stopOpUpTrend,
      this.futuristicSector,
      this.hniInstitutionalPromotersBuy,
      this.specialSituations,
      this.futureVisibility});
  CompanyType copyWith(
      {num? id,
      num? companyId,
      String? symbol,
      bool? ltopUptrend,
      bool? stopOpUpTrend,
      bool? futuristicSector,
      bool? hniInstitutionalPromotersBuy,
      bool? specialSituations,
      bool? futureVisibility}) {
    return CompanyType(
        id: id ?? this.id,
        companyId: companyId ?? this.companyId,
        symbol: symbol ?? this.symbol,
        ltopUptrend: ltopUptrend ?? this.ltopUptrend,
        stopOpUpTrend: stopOpUpTrend ?? this.stopOpUpTrend,
        futuristicSector: futuristicSector ?? this.futuristicSector,
        hniInstitutionalPromotersBuy:
            hniInstitutionalPromotersBuy ?? this.hniInstitutionalPromotersBuy,
        specialSituations: specialSituations ?? this.specialSituations,
        futureVisibility: futureVisibility ?? this.futureVisibility);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyId': companyId,
      'symbol': symbol,
      'ltopUptrend': ltopUptrend,
      'stopOpUpTrend': stopOpUpTrend,
      'futuristicSector': futuristicSector,
      'hniInstitutionalPromotersBuy': hniInstitutionalPromotersBuy,
      'specialSituations': specialSituations,
      'futureVisibility': futureVisibility
    };
  }

  static CompanyType fromJson(Map<String, dynamic> json) {
    return CompanyType(
        id: json['id'] == null ? null : json['id'] as num,
        companyId: json['companyId'] == null ? null : json['companyId'] as num,
        symbol: json['symbol'] == null ? null : json['symbol'] as String,
        ltopUptrend:
            json['ltopUptrend'] == null ? null : json['ltopUptrend'] as bool,
        stopOpUpTrend: json['stopOpUpTrend'] == null
            ? null
            : json['stopOpUpTrend'] as bool,
        futuristicSector: json['futuristicSector'] == null
            ? null
            : json['futuristicSector'] as bool,
        hniInstitutionalPromotersBuy:
            json['hniInstitutionalPromotersBuy'] == null
                ? null
                : json['hniInstitutionalPromotersBuy'] as bool,
        specialSituations: json['specialSituations'] == null
            ? null
            : json['specialSituations'] as bool,
        futureVisibility: json['futureVisibility'] == null
            ? null
            : json['futureVisibility'] as bool);
  }
}
