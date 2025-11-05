import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:research_mantra_official/ui/screens/subscription_screen/widgets/extra_discount_bottom_sheet.dart';
import 'package:research_mantra_official/ui/screens/subscription_screen/widgets/pay_button.dart';

class PaymentPlanModel {
  final String id;
  final String title;
  final String badge;
  final double price;
  final double originalPrice;
  final String duration;
  final List<String> features;
  final bool isSelected;
  final bool isHighestSelling;

  PaymentPlanModel({
    required this.id,
    required this.title,
    required this.badge,
    required this.price,
    required this.originalPrice,
    required this.duration,
    required this.features,
    this.isSelected = false,
    this.isHighestSelling = false,
  });

  factory PaymentPlanModel.fromJson(Map<String, dynamic> json) {
    return PaymentPlanModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      badge: json['badge'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      originalPrice: (json['originalPrice'] ?? 0).toDouble(),
      duration: json['duration'] ?? '',
      features: List<String>.from(json['features'] ?? []),
      isSelected: json['isSelected'] ?? false,
      isHighestSelling: json['isHighestSelling'] ?? false,
    );
  }

  PaymentPlanModel copyWith({
    String? id,
    String? title,
    String? badge,
    double? price,
    double? originalPrice,
    String? duration,
    List<String>? features,
    bool? isSelected,
    bool? isHighestSelling,
  }) {
    return PaymentPlanModel(
      id: id ?? this.id,
      title: title ?? this.title,
      badge: badge ?? this.badge,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      duration: duration ?? this.duration,
      features: features ?? this.features,
      isSelected: isSelected ?? this.isSelected,
      isHighestSelling: isHighestSelling ?? this.isHighestSelling,
    );
  }
}

class CouponModel {
  final String code;
  final double discount;
  final String description;
  final bool isApplied;

  CouponModel({
    required this.code,
    required this.discount,
    required this.description,
    this.isApplied = false,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      code: json['code'] ?? '',
      discount: (json['discount'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      isApplied: json['isApplied'] ?? false,
    );
  }
}

class PaymentSummaryModel {
  final String planName;
  final String expiryDate;
  final double originalPrice;
  final double couponDiscount;
  final double finalPrice;
  final double totalSavings;

  PaymentSummaryModel({
    required this.planName,
    required this.expiryDate,
    required this.originalPrice,
    required this.couponDiscount,
    required this.finalPrice,
    required this.totalSavings,
  });
}

// ============================================================================
// SAMPLE JSON DATA
// ============================================================================

class PaymentScreenData {
  static Map<String, dynamic> getSampleData() {
    return {
      "plans": [
        {
          "id": "plan_3m",
          "title": "Basic Plan",
          "badge": "Trial Period",
          "price": 999.0,
          "originalPrice": 3999.0,
          "duration": "for 3 months",
          "durationMonths": 3,
          "features": [
            "Access to Basic Portfolio",
            "Email support",
            "Market insights & tips"
          ],
          "isHighestSelling": false,
          "isSelected": false
        },
        {
          "id": "plan_6m",
          "title": "Standard Plan",
          "badge": "Highest Selling",
          "price": 7499.0,
          "originalPrice": 22999.0,
          "duration": "for 6 months",
          "durationMonths": 6,
          "features": [
            "Everything in Basic Plan",
            "Perfect for investors and traders",
            "Advanced analytics dashboard"
          ],
          "isHighestSelling": true,
          "isSelected": true
        },
        {
          "id": "plan_12m",
          "title": "Advanced Plan",
          "badge": "Most Popular",
          "price": 12999.0,
          "originalPrice": 39999.0,
          "duration": "for 12 months",
          "durationMonths": 12,
          "features": [
            "Access to all 3 Readymade Portfolios",
            "Unlimited portfolio rebalancing",
            "Dedicated relationship manager",
          ],
          "isHighestSelling": false,
          "isSelected": false
        },
        {
          "id": "plan_36m",
          "title": "Elite Plan",
          "badge": "Best Value",
          "price": 48999.0,
          "originalPrice": 89999.0,
          "duration": "for 3 years",
          "durationMonths": 36,
          "features": [
            "Everything in Advanced Plan",
            "Ideal for long-term investing",
            "Free portfolio health checkup (Quarterly)"
          ],
          "isHighestSelling": false,
          "isSelected": false
        }
      ],
      "coupons": [
        {
          "code": "WELCOME50",
          "discount": 500.0,
          "description": "₹500 saved with WELCOME50",
          "isApplied": false,
          "validForPlans": ["plan_3m", "plan_6m"]
        },
        {
          "code": "GOLD",
          "discount": 5000.0,
          "description": "₹5000 saved with GOLD",
          "isApplied": false,
          "validForPlans": ["plan_6m", "plan_12m"]
        },
        {
          "code": "PLATINUM",
          "discount": 31000.0,
          "description": "₹31000 saved with PLATINUM",
          "isApplied": true,
          "validForPlans": ["plan_36m"]
        },
        {
          "code": "SAVE20",
          "discount": 2000.0,
          "description": "₹2000 saved with SAVE20",
          "isApplied": false,
          "validForPlans": ["plan_12m", "plan_36m"]
        }
      ]
    };
  }
}

// ============================================================================
// PAYMENT SCREEN WIDGET
// ============================================================================

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic>? jsonData;

  const PaymentScreen({super.key, this.jsonData});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late List<PaymentPlanModel> plans;
  late List<CouponModel> coupons;
  late PaymentPlanModel selectedPlan;
  late CouponModel? appliedCoupon;

  bool isExtraDiscountBottomSheetVisible = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    final data = widget.jsonData ?? PaymentScreenData.getSampleData();

    plans = (data['plans'] as List)
        .map((json) => PaymentPlanModel.fromJson(json))
        .toList();

    coupons = (data['coupons'] as List)
        .map((json) => CouponModel.fromJson(json))
        .toList();

    selectedPlan = plans.firstWhere(
      (plan) => plan.isSelected,
      orElse: () => plans.first,
    );

    appliedCoupon = coupons.firstWhere(
      (coupon) => coupon.isApplied,
      orElse: () => coupons.first,
    );
  }

  PaymentSummaryModel _calculateSummary() {
    final discount = appliedCoupon?.discount ?? 0;
    final finalPrice = selectedPlan.price - discount;
    final totalSavings = selectedPlan.originalPrice - finalPrice;

    return PaymentSummaryModel(
      planName: selectedPlan.title,
      expiryDate: 'Expires on 08 Oct \'30',
      originalPrice: selectedPlan.originalPrice,
      couponDiscount: discount,
      finalPrice: finalPrice,
      totalSavings: totalSavings,
    );
  }

  void _onPlanSelected(PaymentPlanModel plan) {
    setState(() {
      selectedPlan = plan;
    });
  }

  void _onPaymentPressed() {
    // Handle payment logic
    final summary = _calculateSummary();
    debugPrint('Processing payment: ₹${summary.finalPrice}');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final summary = _calculateSummary();

    return Scaffold(
      backgroundColor: theme.appBarTheme.backgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    /// ❌ Close Button (scrolls with content)
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () async {
                          if (!isExtraDiscountBottomSheetVisible) {
                            showExtraDiscountSheet(context);
                            setState(() {
                              isExtraDiscountBottomSheetVisible = true;
                            });
                          } else {
                            Navigator.of(context).pop();
                            setState(() {
                              isExtraDiscountBottomSheetVisible = false;
                            });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 12.w,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    // Plan Cards
                    ...plans.map((plan) => _PlanCard(
                          plan: plan,
                          isSelected: plan.id == selectedPlan.id,
                          onTap: () => _onPlanSelected(plan),
                        )),

                    const SizedBox(height: 16),

                    // Coupon Section
                    if (appliedCoupon != null)
                      _CouponCard(coupon: appliedCoupon!),

                    const SizedBox(height: 16),

                    // Payment Summary
                    _PaymentSummaryCard(summary: summary),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: PaymentBottomBar(
        amount: summary.finalPrice,
        onPressed: _onPaymentPressed,
      ),
    );
  }
}

// ============================================================================
// REUSABLE COMPONENTS
// ============================================================================

class _PlanCard extends StatelessWidget {
  final PaymentPlanModel plan;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlanCard({
    required this.plan,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.primaryColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? theme.indicatorColor : theme.shadowColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            plan.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.indicatorColor,
                            ),
                          ),
                          if (plan.isHighestSelling) ...[
                            SizedBox(width: 8.w),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: theme.disabledColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Highest Selling',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10.sp,
                                  color: theme.floatingActionButtonTheme
                                      .foregroundColor,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Text(
                            '₹${plan.price.toStringAsFixed(1)}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.primaryColorDark,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '₹${plan.originalPrice.toStringAsFixed(0)}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.focusColor,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            plan.duration,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.focusColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          isSelected ? theme.indicatorColor : theme.shadowColor,
                      width: 2,
                    ),
                    color:
                        isSelected ? theme.indicatorColor : Colors.transparent,
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          size: 16,
                          color:
                              theme.floatingActionButtonTheme.foregroundColor,
                        )
                      : null,
                ),
              ],
            ),
            SizedBox(height: 4.h),
            ...plan.features.map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: theme.indicatorColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feature,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.focusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _CouponCard extends StatelessWidget {
  final CouponModel coupon;

  const _CouponCard({required this.coupon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.local_offer,
              color: Colors.orange,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coupon.description,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'View all coupons >',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 20,
          ),
          const SizedBox(width: 4),
          const Text(
            'Applied',
            style: TextStyle(
              fontSize: 12,
              color: Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentSummaryCard extends StatelessWidget {
  final PaymentSummaryModel summary;

  const _PaymentSummaryCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                '🎉',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 8),
              Text(
                'Your total savings is of ₹${summary.totalSavings.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E5BFF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SummaryRow(
            label: summary.planName,
            value: '₹${summary.originalPrice.toStringAsFixed(0)}',
            strikethrough: true,
            subtitle: summary.expiryDate,
          ),
          const Divider(height: 24),
          const Text(
            'Payment schedule',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          _SummaryRow(
            label: 'Coupon discount',
            value: '+₹${summary.couponDiscount.toStringAsFixed(0)}',
            valueColor: Colors.green,
          ),
          const SizedBox(height: 8),
          _SummaryRow(
            label: 'Grand total',
            value: '₹${summary.finalPrice.toStringAsFixed(0)}',
            isBold: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final String? subtitle;
  final bool strikethrough;
  final bool isBold;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.subtitle,
    this.strikethrough = false,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: Colors.grey[700],
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
            ],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            decoration: strikethrough ? TextDecoration.lineThrough : null,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }
}
