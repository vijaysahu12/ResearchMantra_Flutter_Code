class ScannerNotificationResponseModel {
  final Map<String, List<ScannerNotificationModel>> notifications;

  ScannerNotificationResponseModel({required this.notifications});

  factory ScannerNotificationResponseModel.fromJson(Map<String, dynamic> json) {
    final Map<String, List<ScannerNotificationModel>> parsedNotifications = {};

    json.forEach((topic, dataList) {
      parsedNotifications[topic] = (dataList as List)
          .map((data) => ScannerNotificationModel.fromJson(data))
          .toList();
    });

    return ScannerNotificationResponseModel(notifications: parsedNotifications);
  }
}

class ScannerNotificationModel {
  final bool isRead;
  final String objectId;
  final String tradingSymbol;
  final String createdOn;
  final String title;
  final String message;
  final double price;
  final String transactionType;
  final String topic;
  final String viewChart;

  ScannerNotificationModel({
    required this.isRead,
    required this.objectId,
    required this.tradingSymbol,
    required this.createdOn,
    required this.title,
    required this.message,
    required this.price,
    required this.transactionType,
    required this.topic,
    required this.viewChart,
  });

  factory ScannerNotificationModel.fromJson(Map<String, dynamic> json) {
    return ScannerNotificationModel(
      isRead: json["isRead"] ?? false,
      objectId: json["objectId"] ?? "",
      tradingSymbol: json["tradingSymbol"] ?? "",
      createdOn: json["createdOn"] ?? "",
      title: json["title"] ?? "",
      message: json["message"] ?? "",
      price: (json["price"] ?? 0).toDouble(),
      transactionType: json["transactionType"] ?? "",
      topic: json["topic"] ?? "",
      viewChart: json["viewChart"] ?? "",
    );
  }
}
