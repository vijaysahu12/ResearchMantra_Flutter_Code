
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/get_subscription_data/subscription_topics_model.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IScanners_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/subscriptions_topics_providers/subscription_topics_states.dart';

class ActiveSubscriptionTopicsStateNotifier
    extends StateNotifier<ActiveSubscriptionTopicsState> {
  ActiveSubscriptionTopicsStateNotifier(this._iScannersRepository)
      : super(ActiveSubscriptionTopicsState.inital());

  final IScannersRepository _iScannersRepository;

//to get all the subscriptiontopis list
  Future<void> getAllActiveSubscriptionList(String mobileUserPublicKey) async {
    state = ActiveSubscriptionTopicsState.loading();
    try {
      final List<GetMyActiveSubscriptionModel> getMyActiveSubscriptionModel =
          await _iScannersRepository
              .getActiveSubscriptionTopics(mobileUserPublicKey);
      state =
          ActiveSubscriptionTopicsState.success(getMyActiveSubscriptionModel);
        } catch (e) {
      print(e);
      state = ActiveSubscriptionTopicsState.error(e);
    }
  }
}

final getActiveSubscriptionTopicsStateNotifierProvider = StateNotifierProvider<
    ActiveSubscriptionTopicsStateNotifier,
    ActiveSubscriptionTopicsState>((ref) {
  final IScannersRepository getlAllActiveTopics = getIt<IScannersRepository>();
  return ActiveSubscriptionTopicsStateNotifier(getlAllActiveTopics);
});
