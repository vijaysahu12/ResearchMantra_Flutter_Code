class PerformanceResponseModel {
  final String? balance;
  final Statistics? statistics;
  final List<Trades>? trades;
  const PerformanceResponseModel({this.balance, this.statistics, this.trades});
  PerformanceResponseModel copyWith(
      {String? balance, Statistics? statistics, List<Trades>? trades}) {
    return PerformanceResponseModel(
        balance: balance ?? this.balance,
        statistics: statistics ?? this.statistics,
        trades: trades ?? this.trades);
  }

  Map<String, Object?> toJson() {
    return {
      'balance': balance,
      'statistics': statistics?.toJson(),
      'trades':
          trades?.map<Map<String, dynamic>>((data) => data.toJson()).toList()
    };
  }

  static PerformanceResponseModel fromJson(Map<String, dynamic> json) {
    return PerformanceResponseModel(
        balance: json['balance'] == null ? null : json['balance'] ?? '',
        statistics: json['statistics'] == null
            ? null
            : Statistics.fromJson(json['statistics'] as Map<String, Object?>),
        trades: json['trades'] == null
            ? null
            : (json['trades'] as List)
                .map<Trades>(
                    (data) => Trades.fromJson(data as Map<String, Object?>))
                .toList());
  }
}

class Trades {
  final String? symbol;
  final String? roi;
  final String? entryPrice;
  final String? status;
  final String? duration;
  final dynamic cmp;
  final String? investmentMessage;
  const Trades(
      {this.symbol,
      this.roi,
      this.entryPrice,
      this.status,
      this.duration,
      this.cmp,
      this.investmentMessage});
  Trades copyWith(
      {String? symbol,
      String? roi,
      String? entryPrice,
      String? status,
      String? duration,
      dynamic cmp,
      String? investmentMessage}) {
    return Trades(
        symbol: symbol ?? this.symbol,
        roi: roi ?? this.roi,
        entryPrice: entryPrice ?? this.entryPrice,
        status: status ?? this.status,
        duration: duration ?? this.duration,
        cmp: cmp ?? this.cmp,
        investmentMessage: investmentMessage ?? this.investmentMessage);
  }

  Map<String, Object?> toJson() {
    return {
      'symbol': symbol,
      'roi': roi,
      'entryPrice': entryPrice,
      'status': status,
      'duration': duration,
      'cmp': cmp,
      'investmentMessage': investmentMessage
    };
  }

  static Trades fromJson(Map<String, dynamic> json) {
    return Trades(
        symbol: json['symbol'] == null ? null : json['symbol'] ?? '',
        roi: json['roi'] == null ? null : json['roi'] ?? "0.0",
        entryPrice:
            json['entryPrice'] == null ? null : json['entryPrice'] ?? '',
        status: json['status'] == null ? null : json['status'] ?? '',
        duration: json['duration'] == null ? null : json['duration'] ?? '',
        cmp: json['cmp'] as dynamic,
        investmentMessage: json['investmentMessage'] ?? '');
  }
}

class Statistics {
  final int? totalTrades;
  final int? totalProfitable;
  final int? totalLoss;
  final int? tradeClosed;
  final int? tradeOpen;

  const Statistics(
      {this.totalTrades,
      this.totalProfitable,
      this.totalLoss,
      this.tradeOpen,
      this.tradeClosed});
  Statistics copyWith(
      {int? totalTrades,
      int? totalProfitable,
      int? totalLoss,
      int? tradeOpen,
      int? tradeClosed}) {
    return Statistics(
        totalTrades: totalTrades ?? this.totalTrades,
        totalProfitable: totalProfitable ?? this.totalProfitable,
        totalLoss: totalLoss ?? this.totalLoss,
        tradeOpen: tradeOpen ?? this.tradeOpen,
        tradeClosed: tradeClosed ?? this.tradeClosed);
  }

  Map<String, Object?> toJson() {
    return {
      'totalTrades': totalTrades,
      'totalProfitable': totalProfitable,
      'totalLoss': totalLoss,
      'tradeClosed': tradeClosed,
      'tradeOpen': tradeOpen
    };
  }

  static Statistics fromJson(Map<String, dynamic> json) {
    return Statistics(
        totalTrades:
            json['totalTrades'] == null ? null : json['totalTrades'] ?? 0,
        totalProfitable: json['totalProfitable'] == null
            ? null
            : json['totalProfitable'] as int,
        totalLoss: json['totalLoss'] == null ? null : json['totalLoss'] ?? 0,
        tradeOpen: json['tradeOpen'] == null ? null : json['tradeOpen'] ?? 0,
        tradeClosed:
            json['tradeClosed'] == null ? null : json['tradeClosed'] ?? 0);
  }
}
