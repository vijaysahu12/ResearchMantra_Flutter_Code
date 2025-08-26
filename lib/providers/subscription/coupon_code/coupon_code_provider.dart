import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/repositories/interfaces/ISubscription_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/subscription/coupon_code/coupon_code_state.dart';

class CouponCodeNotifier extends StateNotifier<CouponCodeState> {
  CouponCodeNotifier(this.subscriptionRepository)
      : super(CouponCodeState.initail());

  final ISubscriptionRepository subscriptionRepository;

  Future<void> getAllCouponCodeList(
      int productId, int subscriptionDurationId) async {
    try {
      if (state.codeResponseModel.isEmpty) {
        state = CouponCodeState.loading();
      }

      final response = await subscriptionRepository.getAllCouponCodeList(
          productId, subscriptionDurationId);

      state = CouponCodeState.loaded(response);
    } catch (e) {
      state = CouponCodeState.error(state.codeResponseModel);
    }
  }
}

final getAllCouponCodeListProvider =
    StateNotifierProvider<CouponCodeNotifier, CouponCodeState>((ref) {
  final ISubscriptionRepository getAllCouponCodeData =
      getIt<ISubscriptionRepository>();
  return CouponCodeNotifier(getAllCouponCodeData);
});
