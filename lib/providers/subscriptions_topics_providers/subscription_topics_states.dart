import 'package:research_mantra_official/data/models/get_subscription_data/subscription_topics_model.dart';

class ActiveSubscriptionTopicsState {
  final List<GetMyActiveSubscriptionModel>? subscriptionTopicsList;
  final bool isLoading;
  final dynamic error;

  ActiveSubscriptionTopicsState(
      {required this.error,
      required this.isLoading,
      required this.subscriptionTopicsList});

  factory ActiveSubscriptionTopicsState.inital() =>
      ActiveSubscriptionTopicsState(
          error: null, isLoading: false, subscriptionTopicsList: null);

  factory ActiveSubscriptionTopicsState.loading() =>
      ActiveSubscriptionTopicsState(
          error: null, isLoading: true, subscriptionTopicsList: null);

  factory ActiveSubscriptionTopicsState.success(
          List<GetMyActiveSubscriptionModel>? subscriptionTopicsList) =>
      ActiveSubscriptionTopicsState(
          error: null,
          isLoading: false,
          subscriptionTopicsList: subscriptionTopicsList);

  factory ActiveSubscriptionTopicsState.error(dynamic error) =>
      ActiveSubscriptionTopicsState(
          error: error, isLoading: false, subscriptionTopicsList: null);
}
