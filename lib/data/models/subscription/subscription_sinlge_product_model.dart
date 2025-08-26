class SubscriptionSingleProductDataModel {
  String? productNameOrSubscriptionPlanId;
  String? name;
  int? productId;
  int? subscriptionPlanId;
  String? paymentGatewayName;

  List<SubscriptionDuration>? subscriptionDurations;

  SubscriptionSingleProductDataModel({
    this.productNameOrSubscriptionPlanId,
    this.name,
    this.subscriptionDurations,
    this.productId,
    this.subscriptionPlanId,
    this.paymentGatewayName,
  });

  // Convert JSON to SubscriptionSingleProductDataModel
  factory SubscriptionSingleProductDataModel.fromJson(
      Map<String, dynamic> json) {
    return SubscriptionSingleProductDataModel(
      productNameOrSubscriptionPlanId: json['productNameOrSubscriptionPlanId'],
      name: json['name'],
      paymentGatewayName: json['paymentGatewayName'] ?? '',
      productId: json['productId'],
      subscriptionPlanId: json['subscriptionPlanId'],
      subscriptionDurations: json['subscriptionDurations'] != null
          ? List<SubscriptionDuration>.from(json['subscriptionDurations']
              .map((x) => SubscriptionDuration.fromJson(x)))
          : null,
    );
  }

  // Convert SubscriptionSingleProductDataModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'productNameOrSubscriptionPlanId': productNameOrSubscriptionPlanId,
      'name': name,
      'subscriptionPlanId': subscriptionPlanId,
      'productId': productId,
      'paymentGatewayName': paymentGatewayName,
      'subscriptionDurations':
          subscriptionDurations?.map((x) => x.toJson()).toList(),
    };
  }
}

// Model for SubscriptionDuration
class SubscriptionDuration {
  int? subscriptionDurationId;
  String? subscriptionDurationName;
  int? months;
  double? discountPrice;
  double? defaultCouponDiscount;
  bool? subscriptionDurationActive;
  String? couponCode;
  double netPayment;
  double? actualPrice;
  String? expireOn;
  String? perMonth;
  bool? isRecommended;
  int subscriptionMappingId;

  SubscriptionDuration(
      {this.subscriptionDurationId,
      this.subscriptionDurationName,
      this.months,
      this.discountPrice,
      this.subscriptionDurationActive,
      this.couponCode,
      required this.netPayment,
      this.actualPrice,
      this.expireOn,
      this.perMonth,
      this.isRecommended,
      required this.subscriptionMappingId,
      required this.defaultCouponDiscount});

  // Convert JSON to SubscriptionDuration
  factory SubscriptionDuration.fromJson(Map<String, dynamic> json) {
    return SubscriptionDuration(
      subscriptionDurationId: json['subscriptionDurationId'],
      subscriptionDurationName: json['subscriptionDurationName'],
      months: json['months'],
      discountPrice: json['discountPrice']?.toDouble(),
      subscriptionDurationActive: json['subscriptionDurationActive'],
      couponCode: json['couponCode'],
      netPayment: json['netPayment'].toDouble() ?? 0.0,
      actualPrice: json['actualPrice']?.toDouble(),
      expireOn: json['expireOn'],
      perMonth: json['perMonth'],
      defaultCouponDiscount: json['defaultCouponDiscount'] ?? 0.0,
      subscriptionMappingId: json['subscriptionMappingId'] ?? 0,
      isRecommended: json['isRecommended'],
    );
  }

  // Convert SubscriptionDuration to JSON
  Map<String, dynamic> toJson() {
    return {
      'subscriptionDurationId': subscriptionDurationId,
      'subscriptionDurationName': subscriptionDurationName,
      'months': months,
      'discountPrice': discountPrice,
      'subscriptionDurationActive': subscriptionDurationActive,
      'couponCode': couponCode,
      'netPayment': netPayment,
      'actualPrice': actualPrice,
      'defaultCouponDiscount': defaultCouponDiscount,
      'expireOn': expireOn,
      'perMonth': perMonth,
      'subscriptionMappingId': subscriptionMappingId,
      'isRecommended': isRecommended,
    };
  }
}
