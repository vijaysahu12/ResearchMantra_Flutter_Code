import 'package:research_mantra_official/data/models/subscription/subscription_sinlge_product_model.dart';

class SingleProductSubscriptionState {
  final dynamic error;
  final bool isLoading;
  final List<SubscriptionSingleProductDataModel> singleproductSubscription;
  final SubscriptionDuration ? subscriptionDuration;

  SingleProductSubscriptionState({
    required this.isLoading,
    this.error,
    required this.singleproductSubscription,
   this.subscriptionDuration,
  });

  factory SingleProductSubscriptionState.initial() => SingleProductSubscriptionState(
        isLoading: false,
        singleproductSubscription: [],
        subscriptionDuration: null,
      );
  factory SingleProductSubscriptionState.loading() => SingleProductSubscriptionState(
        isLoading: true,
        singleproductSubscription: [],
      );

  factory SingleProductSubscriptionState.loaded(List<SubscriptionSingleProductDataModel> singleproductSubscription, SubscriptionDuration ?subscriptionDuration) =>
      SingleProductSubscriptionState(
        isLoading: false,
        singleproductSubscription: singleproductSubscription,
        subscriptionDuration: subscriptionDuration
      );
  factory SingleProductSubscriptionState.select(List<SubscriptionSingleProductDataModel> singleproductSubscription,SubscriptionDuration ?subscriptionDuration) =>
      SingleProductSubscriptionState(
        isLoading: false,
        singleproductSubscription: singleproductSubscription,
        subscriptionDuration: subscriptionDuration
      );


  factory SingleProductSubscriptionState.error(dynamic error) => SingleProductSubscriptionState(
        isLoading: false,
        error: error,
        singleproductSubscription: [],
      );
}
