class TradingJournalMessageResponse {
  final String? message;
  final int? statusCode;
  final String? error;
  TradingJournalMessageResponse(
      {required this.message, required this.statusCode, this.error});

  factory TradingJournalMessageResponse.fromJson(Map<String, dynamic> json) {
    return TradingJournalMessageResponse(
      message: json['message'] as String,
      statusCode: json['statusCode'],
      error: json['error'],
    );
  }
}
