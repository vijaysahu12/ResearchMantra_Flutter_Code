class GetMyActiveSubscriptionModel {
  final int? myBucketId;
  final int? productId;
  final String? productName;
  final String productCode;
  const GetMyActiveSubscriptionModel(
      {this.myBucketId,
      this.productId,
      this.productName,
      required this.productCode});
  GetMyActiveSubscriptionModel copyWith(
      {int? myBucketId,
      int? productId,
      String? productCode,
      String? productName}) {
    return GetMyActiveSubscriptionModel(
        myBucketId: myBucketId ?? this.myBucketId,
        productId: productId ?? this.productId,
        productName: productName ?? this.productName,
        productCode: this.productCode);
  }

  Map<String, dynamic> toJson() {
    return {
      'myBucketId': myBucketId,
      'productId': productId,
      'productName': productName,
      'productCode': productCode
    };
  }

  static GetMyActiveSubscriptionModel fromJson(Map<String, dynamic> json) {
    return GetMyActiveSubscriptionModel(
      myBucketId: json['myBucketId'] ?? 0,
      productId: json['productId'] ?? 0,
      productName: json['productName'] ?? '',
      productCode: json['productCode'] ?? '',
    );
  }
}
