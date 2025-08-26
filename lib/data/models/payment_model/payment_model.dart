class PaymentResponseModel {
  final int productId;
  final String? name;
  final String? code;
  final String? startDate;
  final String? endDate;
  final int? productValidity;
  final String? message;
  final String? paymentStatus; // Uncomment if needed
  const PaymentResponseModel({
    this.name,
    this.code,
    this.startDate,
    this.endDate,
    this.productValidity,
    this.message,
    this.paymentStatus,
    required this.productId,
  });
  PaymentResponseModel copyWith(
      {String? name,
      String? code,
      String? startDate,
      String? endDate,
      int? productValidity,
      String? message,
      String? paymentStatus, // Uncomment if needed
      int? productId}) {
    return PaymentResponseModel(
        name: name ?? this.name,
        code: code ?? this.code,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        productValidity: productValidity ?? this.productValidity,
        message: message ?? this.message,
        paymentStatus: paymentStatus ?? this.paymentStatus,
        productId: productId ?? this.productId);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'startDate': startDate,
      'endDate': endDate,
      'productValidity': productValidity,
      'message': message,
      'paymentStatus': paymentStatus, // Uncomment if needed
      'productId': productId
    };
  }

  static PaymentResponseModel fromJson(Map<String, dynamic> json) {
    return PaymentResponseModel(
        name: json['name'] == null ? null : json['name'] as String,
        code: json['code'] == null ? null : json['code'] as String,
        startDate:
            json['startDate'] == null ? null : json['startDate'] as String,
        endDate: json['endDate'] == null ? null : json['endDate'] as String,
        productValidity: json['productValidity'] == null
            ? null
            : json['productValidity'] as int,
        productId: json['productId'] ?? 0,
        message: json['message'] == null ? null : json['message'] as String,
        paymentStatus: json['paymentStatus'] ?? "NOT_FOUND ");
  }
}
