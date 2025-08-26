class NotificationModel {
  final String? objectId;
  final String? title;
  final String? message;
  final String screenName;
  //Todo: In future We have to dispaly one button inside notification popup based on below properties.
  final dynamic productId;
  final String? productName;

  // final String? receivedBy;
  // final bool? enableTradingButton;
  // final dynamic token;
  // final dynamic appCode;
  // final dynamic exchange;
  // final dynamic tradingSymbol;
  // final dynamic transactionType;
  // final int? quantity;
  // final dynamic orderType;
  // final int? price;
  // final dynamic validity;
  // final dynamic product;
  // final dynamic complexity;
  // final int? categoryId;
 bool? isRead;
  final bool isPinned;

  // final bool? isDelete;
  // final dynamic readDate;
  final String? topic;
  final String? createdOn;
   NotificationModel(
      {this.objectId,
      this.title,
      this.message,
      required this.screenName,
      this.productName,
      this.productId,
      // this.receivedBy,
      // this.enableTradingButton,
      // this.token,
      // this.appCode,
      // this.exchange,
      // this.tradingSymbol,
      // this.transactionType,
      // this.quantity,
      // this.orderType,
      // this.price,
      // this.validity,
      // this.product,
      // this.complexity,
      // this.categoryId,
      this.isRead,
      // this.isDelete,
      // this.readDate,
      this.topic,
      required this.isPinned,
      this.createdOn});
  NotificationModel copyWith(
      {String? objectId,
      String? title,
      String? message,
      dynamic productId,
      String? productName,
      // String? receivedBy,
      // bool? enableTradingButton,
      // dynamic token,
      // dynamic appCode,
      // dynamic exchange,
      // dynamic tradingSymbol,
      // dynamic transactionType,
      // int? quantity,
      // dynamic orderType,
      // int? price,
      // dynamic validity,
      // dynamic product,
      // dynamic complexity,
      // int? categoryId,
      bool? isRead,
      bool? isPinned,
      // bool? isDelete,
      // dynamic readDate,
      String? topic,
      String? screenName,
      String? createdOn}) {
    return NotificationModel(
        objectId: objectId ?? this.objectId,
        title: title ?? this.title,
        message: message ?? this.message,
        productName: productName ?? this.productName,
        // receivedBy: receivedBy ?? this.receivedBy,
        // enableTradingButton: enableTradingButton ?? this.enableTradingButton,
        // token: token ?? this.token,
        // appCode: appCode ?? this.appCode,
        // exchange: exchange ?? this.exchange,
        // tradingSymbol: tradingSymbol ?? this.tradingSymbol,
        // transactionType: transactionType ?? this.transactionType,
        // quantity: quantity ?? this.quantity,
        // orderType: orderType ?? this.orderType,
        // price: price ?? this.price,
        // validity: validity ?? this.validity,
        // product: product ?? this.product,
        // complexity: complexity ?? this.complexity,
        // categoryId: categoryId ?? this.categoryId,
        isRead: isRead ?? this.isRead,
        // isDelete: isDelete ?? this.isDelete,
        // readDate: readDate ?? this.readDate,
        productId: productId ?? this.productId,
        topic: topic ?? this.topic,
        screenName: screenName ?? this.screenName,
        isPinned: isPinned ?? this.isPinned,
        createdOn: createdOn ?? this.createdOn);
  }

  Map<String, Object?> toJson() {
    return {
      'objectId': objectId,
      'title': title,
      'message': message,
      'productId': productId,
      'productName': productName,
      // 'receivedBy': receivedBy,
      // 'enableTradingButton': enableTradingButton,
      // 'token': token,
      // 'appCode': appCode,
      // 'exchange': exchange,
      // 'tradingSymbol': tradingSymbol,
      // 'transactionType': transactionType,
      // 'quantity': quantity,
      // 'orderType': orderType,
      // 'price': price,
      // 'validity': validity,
      // 'product': product,
      // 'complexity': complexity,
      // 'categoryId': categoryId,
      'isRead': isRead,
      // 'isDelete': isDelete,
      // 'readDate': readDate,
      'topic': topic,
      'isPinned': isPinned,
      'createdOn': createdOn,
      'screenName': screenName
    };
  }

  static NotificationModel fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      objectId: json['objectId'],
      title: json['title'],
      message: json['message'],
      productName: json['productName'] ?? '', //by default
      // receivedBy: json['receivedBy'],
      // enableTradingButton: json['enableTradingButton'],
      // token: json['token'],
      // appCode: json['appCode'],
      // exchange: json['exchange'],
      // tradingSymbol: json['tradingSymbol'],
      // transactionType: json['transactionType'],
      // quantity: json['quantity'],
      // orderType: json['orderType'],
      // price: json['price'],
      // validity: json['validity'],
      // product: json['product'],
      // complexity: json['complexity'],
      // categoryId: json['categoryId'],
      isRead: json['isRead'],
      // isDelete: json['isDelete'],
      // readDate: json['readDate'],
      productId: json['productId'] ?? 0,
      isPinned: json['isPinned'] ?? false,
      topic: json['topic'],
      screenName: json['screenName'] ?? '',
      createdOn: json['createdOn'],
    );
  }
}
