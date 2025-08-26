

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/subscription/subscription_sinlge_product_model.dart';
import 'package:research_mantra_official/data/repositories/interfaces/ISubscription_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/subscription/single_product_subscription/single_product_subscription_state.dart';

class SingleProductNotifier
    extends StateNotifier<SingleProductSubscriptionState> {
  SingleProductNotifier(this._subscriptionRepository)
      : super(SingleProductSubscriptionState.initial());

  final ISubscriptionRepository _subscriptionRepository;

  Future<void> getSingleProductSubscription(bool isRefresh, int planId,
      int productID, String mobileUserKey, String isDeviceType) async {
    try {
      // if (isRefresh || state.singleproductSubscription.isEmpty) {
      state = SingleProductSubscriptionState.loading();
      // }

      final getsubscription =
          await _subscriptionRepository.singleProductsubscription(
              planId, productID, mobileUserKey, isDeviceType);
      SubscriptionDuration subscriptionDurationDataModel = SubscriptionDuration(
        actualPrice: 0.0,
        subscriptionDurationId: 0,
        subscriptionDurationName: "",
        months: 0,
        discountPrice: 0.0,
        subscriptionDurationActive: false,
        couponCode: "",
        netPayment: 0.0,
        expireOn: "",
        perMonth: "",
        isRecommended: false,
        subscriptionMappingId: 0,
        defaultCouponDiscount: 0.0,
      );

      if (getsubscription.isNotEmpty) {
        if (getsubscription[0].subscriptionDurations?.length != 0) {
          SubscriptionDuration subscriptionDuration = SubscriptionDuration(
            actualPrice:
                getsubscription[0].subscriptionDurations?[0].actualPrice ?? 0.0,
            subscriptionDurationId: getsubscription[0]
                    .subscriptionDurations?[0]
                    .subscriptionDurationId ??
                0,
            subscriptionDurationName: getsubscription[0]
                    .subscriptionDurations?[0]
                    .subscriptionDurationName ??
                "",
            months: getsubscription[0].subscriptionDurations?[0].months ?? 0,
            discountPrice:
                getsubscription[0].subscriptionDurations?[0].discountPrice ??
                    0.0,
            subscriptionDurationActive: getsubscription[0]
                    .subscriptionDurations?[0]
                    .subscriptionDurationActive ??
                false,
            couponCode:
                getsubscription[0].subscriptionDurations?[0].couponCode ?? "",
            netPayment:
                getsubscription[0].subscriptionDurations?[0].netPayment ?? 0.0,
            expireOn:
                getsubscription[0].subscriptionDurations?[0].expireOn ?? "",
            perMonth:
                getsubscription[0].subscriptionDurations?[0].perMonth ?? "",
            isRecommended:
                getsubscription[0].subscriptionDurations?[0].isRecommended ??
                    false,
            subscriptionMappingId: getsubscription[0]
                    .subscriptionDurations?[0]
                    .subscriptionMappingId ??
                0,
            defaultCouponDiscount: getsubscription[0]
                .subscriptionDurations?[0]
                .defaultCouponDiscount,
          );
          state = SingleProductSubscriptionState.loaded(
              getsubscription, subscriptionDuration);
        } else {
          state = SingleProductSubscriptionState.loaded(
              getsubscription, subscriptionDurationDataModel);
        }
      } else {
        state = SingleProductSubscriptionState.loaded(
            getsubscription, subscriptionDurationDataModel);
      }
    } catch (e) {
      state = SingleProductSubscriptionState.error(e.toString());
    }
  }

  void addSubscription(SubscriptionDuration subscriptionDuration) {
    state = SingleProductSubscriptionState.select(
        state.singleproductSubscription, subscriptionDuration);
  }

  void getDiscount(double discount) {
    // Calculate the new discount price and net payment
    double newDiscountPrice = discount;
    double newNetPayment =
        state.subscriptionDuration!.actualPrice! - newDiscountPrice;

    // Create a new instance of SubscriptionDuration with updated values
    SubscriptionDuration updatedSubscriptionDuration = SubscriptionDuration(
      actualPrice: state.subscriptionDuration!.actualPrice,
      subscriptionDurationId:
          state.subscriptionDuration!.subscriptionDurationId,
      subscriptionDurationName:
          state.subscriptionDuration!.subscriptionDurationName,
      months: state.subscriptionDuration!.months,
      discountPrice: newDiscountPrice,
      subscriptionDurationActive:
          state.subscriptionDuration!.subscriptionDurationActive,
      couponCode: state.subscriptionDuration!.couponCode,
      netPayment: newNetPayment,
      expireOn: state.subscriptionDuration!.expireOn,
      perMonth: state.subscriptionDuration!.perMonth,
      isRecommended: state.subscriptionDuration!.isRecommended,
      subscriptionMappingId: state.subscriptionDuration!.subscriptionMappingId,
      defaultCouponDiscount: state.subscriptionDuration!.defaultCouponDiscount,
    );

    // Update the state with the new subscription duration
    state = SingleProductSubscriptionState.loaded(
        state.singleproductSubscription, updatedSubscriptionDuration);
  }
}

final getSingleProductSubscriptionProvider = StateNotifierProvider<
    SingleProductNotifier, SingleProductSubscriptionState>(((ref) {
  final ISubscriptionRepository subscriptionRepository =
      getIt<ISubscriptionRepository>();
  return SingleProductNotifier(subscriptionRepository);
}));
