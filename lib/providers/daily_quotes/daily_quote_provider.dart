import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IGetsubscription_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/daily_quotes/daily_quote_state.dart';


class DailyQuotesStateNotifier extends StateNotifier<SubscriptionTopicsState> {
  DailyQuotesStateNotifier(this._getSubscriptionRepository)
      : super(SubscriptionTopicsState.initial());

  final IGetSubscriptionRepository _getSubscriptionRepository;

//method for manageSubscriptionTopics
  Future<void> manageSubscriptionTopics(String mobileUserPublicKey,String version) async {
    state = SubscriptionTopicsState.loading();
    try {
      final getSubscriptionTopics = await _getSubscriptionRepository
          .manageSubscriptionTopics(mobileUserPublicKey,version);
      
      state = SubscriptionTopicsState.success(getSubscriptionTopics);
    } catch (error) {
      state = SubscriptionTopicsState.error(error);
    }
  }
}

final getDailyQuoteStateNotifierProvider =
    StateNotifierProvider<DailyQuotesStateNotifier, SubscriptionTopicsState>(
        (ref) {
  final IGetSubscriptionRepository gettopicsRepository =
      getIt<IGetSubscriptionRepository>();
  return DailyQuotesStateNotifier(gettopicsRepository);
});
