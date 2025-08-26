
class AnalysisResponse {
  final int statusCode;
  final String? message;
  final List<AllPreMarketAnalysisDataModel>? data;
  final String? exceptions;
  final int total;

  AnalysisResponse({
    required this.statusCode,
    this.message,
    this.data,
    this.exceptions,
    required this.total,
  });

  factory AnalysisResponse.fromJson(Map<String, dynamic> json) {
    return AnalysisResponse(
      statusCode: json['statusCode'] as int,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => AllPreMarketAnalysisDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      exceptions: json['exceptions'] as String?,
      total: json['total'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'data': data?.map((e) => e.toJson()).toList(),
      'exceptions': exceptions,
      'total': total,
    };
  }
}

class AllPreMarketAnalysisDataModel {
  final String nifty;
  final String bnf;
  final String vix;
  final String? hotNews;
  final String diis;
  final String fiis;
  final String oi;
  final String buttonText;
  final String id;
  final String createdOn;

  AllPreMarketAnalysisDataModel({
    required this.nifty,
    required this.bnf,
    required this.vix,
    this.hotNews,
    required this.diis,
    required this.fiis,
    required this.oi,
    required this.buttonText,
    required this.id,
    required this.createdOn,
  });

  factory AllPreMarketAnalysisDataModel.fromJson(Map<String, dynamic> json) {
    return AllPreMarketAnalysisDataModel(
      nifty: json['nifty'] ?? "N/A",
      bnf: json['bnf'] ?? "N/A",
      vix: json['vix'] ?? "N/A",
      hotNews: json['hotNews'],
      diis: json['diis'] ?? "N/A",
      fiis: json['fiis'] ?? "N/A",
      oi: json['oi'] ?? "N/A",
      buttonText: json['buttonText'] ?? "Read More",
      id: json['id'] ?? "",
      createdOn: json['createdOn'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nifty': nifty,
      'bnf': bnf,
      'vix': vix,
      'hotNews': hotNews,
      'diis': diis,
      'fiis': fiis,
      'oi': oi,
      'buttonText': buttonText,
      'id': id,
      'createdOn': createdOn,
    };
  }
}


