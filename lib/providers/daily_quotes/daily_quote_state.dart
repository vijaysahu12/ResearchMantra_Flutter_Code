import 'package:research_mantra_official/data/models/quote_model/subscription_response.dart';

class SubscriptionTopicsState {
  final GetSubscriptionTopicsAndQuoteResponse? quotes;

  // final FreeTrialResponse? freeTrialResponse;
  final bool isLoading;
  final dynamic error;

  SubscriptionTopicsState({
    required this.quotes,
    required this.error,
    required this.isLoading,
  });

  factory SubscriptionTopicsState.initial() =>
      SubscriptionTopicsState(error: null, isLoading: false, quotes: null);

  factory SubscriptionTopicsState.loading() =>
      SubscriptionTopicsState(error: null, isLoading: true, quotes: null);

  factory SubscriptionTopicsState.success(
          GetSubscriptionTopicsAndQuoteResponse quotes) =>
      SubscriptionTopicsState(
        error: null,
        isLoading: false,
        quotes: quotes,
      );

  factory SubscriptionTopicsState.error(dynamic error) =>
      SubscriptionTopicsState(error: error, isLoading: false, quotes: null);
}
