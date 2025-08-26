import 'package:research_mantra_official/data/models/dynamic_bottom_sheet/dynamic_promo_model.dart';

abstract class IPromoRepository {
  Future<List<PromoModel>> fetchPromos(
      String fcmToken, String deviceType, String version);
}
