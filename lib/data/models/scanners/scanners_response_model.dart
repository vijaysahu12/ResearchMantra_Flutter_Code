class ScannersResponseModel {
  final bool? isRead;
  final String? objectId;
  final dynamic tradingSymbol;
  final dynamic message;
  final dynamic title;
  final dynamic createdOn;
  final dynamic price;
  final dynamic transactionType;
  final dynamic topic;
  final String? viewChart;

  const ScannersResponseModel(
      {this.isRead,
      this.objectId,
      this.tradingSymbol,
      this.message,
      this.title,
      this.createdOn,
      this.price,
      this.transactionType,
      this.topic,
      this.viewChart});

  Map<String, Object?> toJson() {
    return {
      'isRead': isRead,
      'objectId': objectId,
      'tradingSymbol': tradingSymbol,
      'message': message,
      'title': title,
      'createdOn': createdOn,
      'price': price,
      'transactionType': transactionType,
      'topic': topic,
      'viewChart': viewChart
    };
  }

  static ScannersResponseModel fromJson(Map<String, dynamic> json) {
    return ScannersResponseModel(
        isRead: json['isRead'] == null ? null : json['isRead'] as bool,
        objectId: json['objectId'] ?? "",
        tradingSymbol: json['tradingSymbol'] ?? "",
        message: json['message'] ?? "",
        title: json['title'] ?? "",
        createdOn: json['createdOn'] ?? "",
        price: json['price'] ?? "",
        transactionType: json['transactionType'] ?? "",
        topic: json['topic'] ?? "",
        viewChart: json['viewChart'] == null ? null : json['viewChart'] ?? "");
  }
}
