import 'package:research_mantra_official/data/models/quote_model/subscription_response.dart';

abstract class IGetSubscriptionRepository {
  Future<GetSubscriptionTopicsAndQuoteResponse> manageSubscriptionTopics(
      String mobileUserPublicKey,String version);
}
