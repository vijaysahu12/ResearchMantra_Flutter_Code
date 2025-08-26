import 'package:flutter_riverpod/flutter_riverpod.dart';

//apply coupon code state notifier
class CouponCodeStateNotifier extends StateNotifier<bool> {
  CouponCodeStateNotifier() : super(false);

  void setValid(bool isValid) {
    state = isValid;
  }
}

final couponCodeStateNotifierProvider =
    StateNotifierProvider<CouponCodeStateNotifier, bool>((ref) {
  return CouponCodeStateNotifier();
});
