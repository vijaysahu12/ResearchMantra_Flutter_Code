import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class PaymentDescriptionCard extends StatelessWidget {
  final ThemeData theme;
  final String subscriptionDurationName;
  final int subscriptionDurationId;
  final double discountPrice;
  final double defaultCouponDiscount;
  final String couponCode;
  final double actualPrice;
  final double netPayment;
  final String lastDate;
  final int months;
  final bool isCouponActivated;
  final double afterAppliedCouponDiscount;
  final Function(String couponCode, int subscriptionDurationId)? onApplyCoupon;
  final VoidCallback? onRemoveCoupon;
  final double Function({
    required double netPayment,
    required int months,
    required bool isCouponActivated,
    required double afterAppliedCouponDiscount,
    required double defaultCouponDiscount,
  }) calculateMonthlyPayment;

  const PaymentDescriptionCard({
    super.key,
    required this.theme,
    required this.subscriptionDurationName,
    required this.subscriptionDurationId,
    required this.discountPrice,
    required this.defaultCouponDiscount,
    required this.couponCode,
    required this.actualPrice,
    required this.netPayment,
    required this.lastDate,
    required this.months,
    required this.isCouponActivated,
    required this.afterAppliedCouponDiscount,
    required this.calculateMonthlyPayment,
    this.onApplyCoupon,
    this.onRemoveCoupon,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = MediaQuery.of(context).size.height;

    final grandTotal = isCouponActivated
        ? netPayment - afterAppliedCouponDiscount
        : netPayment;

    final totalSavings = isCouponActivated
        ? discountPrice + afterAppliedCouponDiscount
        : discountPrice;

    return AnimationConfiguration.staggeredList(
      position: 0,
      duration: const Duration(milliseconds: 500),
      child: SlideAnimation(
        verticalOffset: 200.0,
        child: FadeInAnimation(
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: theme.focusColor, width: 1),
              borderRadius: BorderRadius.circular(12),
              color: theme.appBarTheme.backgroundColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🎉 Savings
                _buildSavingsHeader(fontSize, totalSavings),

                const SizedBox(height: 15),

                /// 🗓 Subscription info
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: _buildSubscriptionDetails(fontSize),
                ),

                const SizedBox(height: 16),

                /// 🏷 Coupon discount
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: _buildCouponSection(fontSize),
                ),

                const SizedBox(height: 16),

                /// 🕒 Limited deal
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: _buildLimitedTimeDeal(fontSize),
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(thickness: 2, color: theme.shadowColor),
                ),

                /// 💰 Grand Total
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: _buildGrandTotal(fontSize, grandTotal),
                ),

                /// 📆 Monthly Info
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: _buildMonthlyInfo(fontSize),
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSavingsHeader(double fontSize, double totalSavings) {
    return Container(
      decoration: BoxDecoration(
        color: theme.shadowColor.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: fontSize * 0.018,
                  fontWeight: FontWeight.bold,
                  color: theme.indicatorColor,
                  fontFamily: "poppins",
                ),
                children: [
                  const TextSpan(text: " 🥳 Your total savings is of  "),
                  TextSpan(text: "₹${totalSavings.truncate()}"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionDetails(double fontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// Left side
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subscriptionDurationName,
              style: TextStyle(
                fontSize: fontSize * 0.017,
                fontWeight: FontWeight.bold,
                color: theme.primaryColorDark,
              ),
            ),
            Text(
              "Expires on $lastDate",
              style: TextStyle(
                fontSize: fontSize * 0.017,
                fontWeight: FontWeight.w600,
                color: theme.focusColor,
              ),
            ),
          ],
        ),

        /// Right side
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "₹ ${actualPrice.truncate()}",
              style: TextStyle(
                fontSize: fontSize * 0.017,
                color: theme.focusColor,
                decoration: TextDecoration.lineThrough,
                decorationColor: theme.disabledColor,
                decorationThickness: 3,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "₹${netPayment.truncate()}",
              style: TextStyle(
                fontSize: fontSize * 0.018,
                fontWeight: FontWeight.bold,
                color: theme.primaryColorDark,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCouponSection(double fontSize) {
    return Row(
      children: [
        Text(
          "Coupon discount",
          style: TextStyle(
            fontSize: fontSize * 0.016,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        if (!isCouponActivated && onApplyCoupon != null)
          GestureDetector(
            onTap: () =>
                onApplyCoupon?.call(couponCode, subscriptionDurationId),
            child: Text(
              "APPLY COUPON",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontSize * 0.016,
                color: theme.indicatorColor,
              ),
            ),
          ),
        if (isCouponActivated && afterAppliedCouponDiscount >= 0.0) ...[
          Text(
            "- ₹${afterAppliedCouponDiscount.truncate()}",
            style: TextStyle(
              fontSize: fontSize * 0.02,
              color: theme.secondaryHeaderColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 5),
          if (onRemoveCoupon != null)
            GestureDetector(
              onTap: onRemoveCoupon,
              child: Icon(
                Icons.cancel,
                color: theme.focusColor,
                size: fontSize * 0.026,
              ),
            ),
        ]
      ],
    );
  }

  Widget _buildLimitedTimeDeal(double fontSize) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: theme.disabledColor.withOpacity(0.7),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            "LIMITED TIME EXCLUSIVE DEAL",
            style: TextStyle(
              fontSize: fontSize * 0.014,
              fontWeight: FontWeight.bold,
              color: theme.floatingActionButtonTheme.foregroundColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGrandTotal(double fontSize, double grandTotal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Grand total",
          style: TextStyle(
            fontSize: fontSize * 0.016,
            fontWeight: FontWeight.bold,
            color: theme.primaryColorDark,
          ),
        ),
        Text(
          "₹${grandTotal.truncate()}",
          style: TextStyle(
            fontSize: fontSize * 0.016,
            fontWeight: FontWeight.bold,
            color: theme.primaryColorDark,
          ),
        )
      ],
    );
  }

  Widget _buildMonthlyInfo(double fontSize) {
    final monthly = calculateMonthlyPayment(
      netPayment: netPayment,
      months: months,
      isCouponActivated: !isCouponActivated,
      afterAppliedCouponDiscount: afterAppliedCouponDiscount,
      defaultCouponDiscount: defaultCouponDiscount,
    ).truncate();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Monthly",
          style: TextStyle(
            fontSize: fontSize * 0.014,
            fontWeight: FontWeight.bold,
            color: theme.focusColor,
          ),
        ),
        Text(
          "₹$monthly/m",
          style: TextStyle(
            fontSize: fontSize * 0.014,
            fontWeight: FontWeight.bold,
            color: theme.focusColor,
          ),
        ),
      ],
    );
  }
}
