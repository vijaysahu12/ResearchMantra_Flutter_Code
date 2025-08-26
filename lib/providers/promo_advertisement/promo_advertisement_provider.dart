import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IPromo_card_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/promo_advertisement/promo_advertisement_state.dart';
import 'package:research_mantra_official/utils/utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PromoStateNotifier extends StateNotifier<PromoState> {
  final IPromoRepository _promoRepository;

  PromoStateNotifier(this._promoRepository) : super(PromoState.initial());

  Future<void> fetchPromos() async {
    await FirebaseMessaging.instance.deleteToken();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final fcmToken = await FirebaseMessaging.instance.getToken() ?? "";
    String info = await getDevice() ?? "";

    try {
      state = PromoState.loading();
      final promos = await _promoRepository.fetchPromos(
        fcmToken,
        info,
        packageInfo.version,
      );
      state = PromoState.success(promos);
    } catch (e) {
      state = PromoState.error(e);
    }
  }

//clearing the state
  void clear() {
    state = PromoState.initial();
  }
}

final promoStateNotifierProvider =
    StateNotifierProvider<PromoStateNotifier, PromoState>((ref) {
  final repo = getIt<IPromoRepository>();
  return PromoStateNotifier(repo);
});
