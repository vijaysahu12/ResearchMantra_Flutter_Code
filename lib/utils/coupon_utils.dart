import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/generic_message.dart';

import 'package:research_mantra_official/providers/get_support_mobile/support_mobile_provider.dart';
import 'package:research_mantra_official/providers/payment_bypass/payment_bypass_provider.dart';
import 'package:research_mantra_official/providers/products/single/single_product_provider.dart';
import 'package:research_mantra_official/ui/components/popupscreens/subscription_pop_up.dart/is_free_subscription_pop_up.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';

class CouponUtils {
  /// Applies a coupon code for iOS users.
  static Future<void> applyIosCouponCode({
    required context,
    required String couponCodeText,
    required String productId,
    required String mobileUserKey,
    required dynamic ref,
    required TextEditingController textEditingController,
  }) async {
    if (couponCodeText.length > 4) {
      await ref.read(paymentByPassStateProvider.notifier).applyCoucponCode(
            mobileUserKey,
            productId,
            couponCodeText,
            "apply",
          );
      await ref
          .read(singleProductStateNotifierProvider.notifier)
          .getSingleProductDetails(productId, mobileUserKey, true);
    } else {
      ToastUtils.showToast("Please enter a valid coupon code.", "");
      return;
    }

    if (ref.read(paymentByPassStateProvider).applyCouponcode) {
      ref.read(singleProductStateNotifierProvider.notifier).updateBuyButton();
      Navigator.pop(context);
    }
  }

  /// Fetches the WhatsApp coupon code link.
  static Future<void> getWhatsAppCouponCode({
    required context,
    required String productId,
    required String mobileUserKey,
    required dynamic ref,
  }) async {
    await ref.read(paymentByPassStateProvider.notifier).getCouponCodeLink(
          mobileUserKey,
          productId,
          "TOGetCoupon",
          "get",
        );
    Navigator.pop(context);
  }

  /// Shows the iOS payment popup.
  Future<void> handleToShowIosPopUp({
    required context,
    required String productId,
    required String mobileUserKey,
    required dynamic ref,
    required TextEditingController textEditingController,
    required String applyCouponCodePopupForIos,
    required String applyButtonText,
    required String getCouponText,
  }) async {
    await ref
        .read(paymentByPassStateProvider.notifier)
        .getCouponCodeCheckStatus(
          mobileUserKey,
          productId,
          "GETSTATUS",
          "checkStatus",
        );
    await ref
        .read(getSupportMobileStateProvider.notifier)
        .getSupportMobileData();
    final getCheckStatus = ref.watch(paymentByPassStateProvider);
    final getMobileNumber = ref.watch(getSupportMobileStateProvider);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: IosSubscriptionPopup(
            getCheckStatus: getCheckStatus,
            message: "$applyCouponCodePopupForIos$applyCouponCodePopupForIos2",
            apply: () async {
              await CouponUtils.applyIosCouponCode(
                context: context,
                couponCodeText: textEditingController.text.trim(),
                productId: productId,
                mobileUserKey: mobileUserKey,
                ref: ref,
                textEditingController: textEditingController,
              );
            },
            getCoupon: () async {
              await CouponUtils.getWhatsAppCouponCode(
                context: context,
                productId: productId,
                mobileUserKey: mobileUserKey,
                ref: ref,
              );
            },
            applyButtonText: applyButtonText,
            getCouponButtonText: getCouponText,
            isSupportMobileNumber: getMobileNumber.data.toString(),
            textEditingController: textEditingController,
          ),
        );
      },
    );
  }
}
