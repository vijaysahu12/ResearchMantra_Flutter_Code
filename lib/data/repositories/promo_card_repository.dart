import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/data/models/dynamic_bottom_sheet/dynamic_promo_model.dart';
import 'package:research_mantra_official/data/network/http_client.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IPromo_card_repository.dart';
import 'package:research_mantra_official/main.dart';

class PromoRepository implements IPromoRepository {
  final HttpClient _httpClient = getIt<HttpClient>();

  @override
  Future<List<PromoModel>> fetchPromos(
      String fcmToken, String deviceType, String version) async {
    try {
      //Todo: Need to pass body
      Map<String, dynamic> body = {
        'Version': version,
        'DeviceType': deviceType,
        'FcmToken': fcmToken
      };

      final response = await _httpClient.post(getPromoAdvertisementList, body);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => PromoModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to fetch promos: $e');
    }
  }
}
