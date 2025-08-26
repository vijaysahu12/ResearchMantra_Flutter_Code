import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/data/models/quote_model/subscription_response.dart';
import 'package:research_mantra_official/data/network/http_client.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IGetsubscription_repository.dart';
import 'package:research_mantra_official/main.dart';

class GetSubscriptionRepository implements IGetSubscriptionRepository {
  final HttpClient _httpClient = getIt<HttpClient>();
  @override
  Future<GetSubscriptionTopicsAndQuoteResponse> manageSubscriptionTopics(
      String mobileUserPublicKey, String version) async {
    try {
      final response = await _httpClient.get(
          "$getSubscriptionTopics?userKey=$mobileUserPublicKey&updateVersion=$version");

      if (response.statusCode == 200) {
        final dynamic responseData = response.data;
        final quotesResponse =
            GetSubscriptionTopicsAndQuoteResponse.fromJson(responseData);
        return quotesResponse;
      } else {
        // Handle non-200 status code
        return throw Exception("${response.statusCode} ${response.message}");
      }
    } catch (error) {
      // Handle error
      print(error);
      return throw Exception('An error occurred $error');
    }
  }
}
