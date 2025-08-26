class MyBucketListApiResponseModel {
  final int id;
  final String name;
  final double price;
  final String buyButtonText;
  final int daysToGo;
  final DateTime startdate;
  final DateTime enddate;
  final String categoryName;
  final String listImage;
  final bool notificationEnabled;

  final bool showReminder;
  bool isHeart;

  MyBucketListApiResponseModel({
    required this.id,
    required this.daysToGo,
    required this.price,
    required this.buyButtonText,
    required this.startdate,
    required this.enddate,
    required this.categoryName,
    required this.listImage,
    required this.name,
    required this.showReminder,
    required this.isHeart,
    required this.notificationEnabled,
  });

  MyBucketListApiResponseModel copyWith({
    int? id,
    String? name,
    double? price,
    String? listImage,
    int? daysToGo,
    DateTime? startdate,
    DateTime? enddate,
    String? categoryName,
    String? buyButtonText,
    bool? showReminder,
    bool? isHeart,
    bool? notificationEnabled,
  }) {
    return MyBucketListApiResponseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      listImage: listImage ?? this.listImage,
      daysToGo: daysToGo ?? this.daysToGo,
      categoryName: categoryName ?? this.categoryName,
      startdate: startdate ?? this.startdate,
      buyButtonText: buyButtonText ?? this.buyButtonText,
      enddate: enddate ?? this.enddate,
      showReminder: showReminder ?? this.showReminder,
      isHeart: isHeart ?? this.isHeart,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
    );
  }

  factory MyBucketListApiResponseModel.fromJson(Map<String, dynamic> json) {
    return MyBucketListApiResponseModel(
        id: json['id'] ?? 0,
        daysToGo: json['daysToGo'] ?? 0,
        price: json['price'] ?? 0,
        name: json['name'] ?? '',
        buyButtonText: json['buyButtonText'] ?? '',
        categoryName: json['categoryName'] ?? '',
        showReminder: json['showReminder'] ?? false,
        isHeart: json['isHeart'] ?? false,
        startdate: json['startdate'] != null
            ? DateTime.parse(json['startdate'])
            : DateTime.now(),
        enddate: json['enddate'] != null
            ? DateTime.parse(json['enddate'])
            : DateTime.now(),
        listImage: json['listImage'] ?? '',
        notificationEnabled: json['notificationEnabled'] ?? '');
  }
}
