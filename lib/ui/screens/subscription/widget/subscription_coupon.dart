import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/providers/payment_bypass/payment_bypass_states.dart';
import 'package:research_mantra_official/ui/components/popupscreens/subscription_pop_up.dart/is_free_subscription_pop_up.dart';

class ApplyCouponCodeScreen extends StatelessWidget {
  final String applyCouponCodePopupForIos;
  final String applyCouponCodePopupForIos2;
  final TextEditingController couponCodeController;
  final VoidCallback applyIosCouponCode;
  final VoidCallback getWhatsAppCouponCode;
  final String getCouponText;
  final String applyButtonText;
  final PaymentByPassState getCheckStatus;
  final String? getMobileNumber;

  const ApplyCouponCodeScreen({
    super.key,
    required this.applyCouponCodePopupForIos,
    required this.applyCouponCodePopupForIos2,
    required this.couponCodeController,
    required this.applyIosCouponCode,
    required this.getWhatsAppCouponCode,
    required this.getCouponText,
    required this.applyButtonText,
    required this.getCheckStatus,
    required this.getMobileNumber,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(15.0),
      children: [
        if (getMobileNumber != null)
          AspectRatio(
            aspectRatio: 4 / 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(profileScreenDefaultImage),
            ),
          ),
        if (getMobileNumber != null)
          IosSubscriptionPopup(
            message: "$applyCouponCodePopupForIos$applyCouponCodePopupForIos2",
            applyButtonText: applyButtonText,
            getCouponButtonText: getCouponText,
            textEditingController: couponCodeController,
            apply: applyIosCouponCode,
            isSupportMobileNumber: getMobileNumber ?? contactUsContactNumber,
            getCoupon: getWhatsAppCouponCode,
            getCheckStatus: getCheckStatus,
          ),
      ],
    );
  }
}
