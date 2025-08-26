class CommonImagesResponseModel {
  final String? name;
  final int? id;
  final String? url;
  final String type;
  final String? expireOn;
  final String? productName;
  final dynamic productId;

  const CommonImagesResponseModel({
    this.name,
    this.id,
    this.url,
    required this.type,
    this.expireOn,
    this.productName,
    this.productId,
  });

  CommonImagesResponseModel copyWith(
      {String? name,
      int? id,
      String? url,
      String? type,
      String? expireOn,
      String? productName,
      dynamic productId}) {
    return CommonImagesResponseModel(
        name: name ?? this.name,
        url: url ?? this.url,
        id: id ?? this.id,
        expireOn: expireOn ?? this.expireOn,
        productName: productName ?? this.productName,
        productId: productId ?? this.productId,
        type: this.type);
  }

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'id': id,
      "url": url,
      "type": type,
      'expireOn': expireOn,
      'productName': productName,
      'productId': productId
    };
  }

  static CommonImagesResponseModel fromJson(Map<String, dynamic> json) {
    return CommonImagesResponseModel(
        name: json['name'] ?? '',
        url: json['url'] ?? '',
        id: json['id'] ?? "",
        expireOn: json['expireOn'],
        productName: json['productName'] ?? "",
        productId: json['productId'] ?? "",
        type: json['type']);
  }
}

//Dashboard Bottom top images
class DashBoardTopImagesModel {
  final int? id;
  final String? name;
  final String? listImage;
  final double price;
  final String? type;
  final String buyButtonText;

  const DashBoardTopImagesModel({
    this.id,
    this.name,
    this.listImage,
    this.type,
    required this.price,
    required this.buyButtonText,
  });

  static DashBoardTopImagesModel fromJson(Map<String, dynamic> json) {
    return DashBoardTopImagesModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        price: json['price'] ?? 0.0,
        type: json['type'] ?? '',
        buyButtonText: json['buyButtonText'] ?? "",
        listImage: json['listImage'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'listImage': listImage,
      'type': type,
      'price': price,
      'buyButtonText': buyButtonText,
    };
  }
}
