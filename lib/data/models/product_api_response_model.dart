class ProductApiResponseModel {
  final int id;
  final String name;
  final String groupName;
  final double price;

  final String? buyButtonText;
  final String? description;
  final double? overAllRating;
  final int? heartsCount;
  final double userRating;
  final bool userHasHeart;
  final bool isInMyBucket;
  final String? isIosCouponEnabled;
  final bool isInValidity;
  final String listImage;

  ProductApiResponseModel({
    required this.id,
    required this.buyButtonText,
    required this.name,
    required this.price,
    required this.description,
    required this.overAllRating,
    required this.heartsCount,
    required this.userRating,
    required this.userHasHeart,
    required this.isInMyBucket,
    required this.isInValidity,
    required this.listImage,
    required this.groupName,
    this.isIosCouponEnabled,
  });

  factory ProductApiResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductApiResponseModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      buyButtonText: json['buyButtonText'] ?? '',
      price: json['price'] ?? 0.0,
      groupName: json['groupName'] ?? '',
      description: json['description'] ?? '',
      overAllRating: (json['overAllRating'] ?? 0.0).toDouble(),
      heartsCount: json['heartsCount'] ?? 0,
      listImage: json['listImage'] ?? "",
      userRating: (json['userRating'] ?? 0.0).toDouble(),
      userHasHeart: json['userHasHeart'] ?? false,
      isInMyBucket: json['isInMyBucket'] ?? false,
      isInValidity: json['isInValidity'] ?? false,
      isIosCouponEnabled: json['isIosCouponEnabled'] ?? 'false',
    );
  }

  ProductApiResponseModel copyWith({
    int? id,
    String? name,
    String? description,
    String? listImage,
    String? groupName,
    int? heartsCount,
    int? thumbsUpCount,
    bool? userHasHeart,
    bool? isInMyBucket,
    bool? isInValidity,
    double? overAllRating,
    String? buyButtonText,
    String? isIosCouponEnabled,
    double? price,
  }) {
    return ProductApiResponseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      buyButtonText: buyButtonText ?? this.buyButtonText,
      price: price ?? this.price,
      description: description ?? this.description,
      listImage: listImage ?? this.listImage,
      heartsCount: heartsCount ?? this.heartsCount,
      userHasHeart: userHasHeart ?? this.userHasHeart,
      isInMyBucket: isInMyBucket ?? this.isInMyBucket,
      isInValidity: isInValidity ?? this.isInValidity,
      overAllRating: overAllRating ?? this.overAllRating,
      userRating: userRating,
      isIosCouponEnabled: isIosCouponEnabled ?? this.isIosCouponEnabled,
      groupName: this.groupName,
    );
  }
}

class BonusProduct {
  final int? id;
  final String? bonusProductName;
  final int? validity;
  final String? bonusMessgae;
  final String? productCategory;

  BonusProduct({
    required this.id,
    required this.bonusProductName,
    required this.validity,
    required this.bonusMessgae,
    required this.productCategory,
  });

  // Factory method to create a BonusProduct from a JSON map
  factory BonusProduct.fromJson(Map<String, dynamic> json) {
    return BonusProduct(
        id: json['Id'] ?? 0,
        bonusProductName: json['BonusProductName'] ?? '',
        validity: json['Validity'],
        bonusMessgae: json['BonusMessage'] ?? '',
        productCategory: json['Category'] ?? '');
  }

  // Method to convert BonusProduct to JSON
  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'BonusProductName': bonusProductName,
      'Validity': validity,
      'BonusMessage': bonusMessgae,
      'Category': productCategory
    };
  }
}
