// class CouponCodeResponseModel {
//   final List<CouponCodes> data;

//   CouponCodeResponseModel({required this.data});

//   // Factory constructor for creating an instance from JSON
//   factory CouponCodeResponseModel.fromJson(Map<String, dynamic> json) {
//     return CouponCodeResponseModel(
//       data: (json['data'] as List<dynamic>)
//           .map((item) => CouponCodes.fromJson(item as Map<String, dynamic>))
//           .toList(),
//     );
//   }

// }

class CouponCodeResponseModel {
  final String couponName;
  final String description;
  final double discountAmount;

  CouponCodeResponseModel({
    required this.couponName,
    required this.description,
    required this.discountAmount,
  });

  // Factory constructor for creating an instance from JSON
  factory CouponCodeResponseModel.fromJson(Map<String, dynamic> json) {
    return CouponCodeResponseModel(
      couponName: json['couponName'] ?? '',
      description:
          json['description'] ?? '🏷️  Limited Stock! Grab Your Savings Today!',
      discountAmount: json['discountAmount'] ?? 0.0,
    );
  }

  // Method for converting an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'couponName': couponName,
      'description': description,
      'discountAmount': discountAmount,
    };
  }
}
