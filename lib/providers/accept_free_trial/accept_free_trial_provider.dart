
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IGet_Free_trial_respositiry.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/accept_free_trial/accept_free_trial_state.dart';


class AcceptFreeTrialNotifier extends StateNotifier<AcceptFreeTrialState> {
  AcceptFreeTrialNotifier(this._acceptFreeTrialRepository, this.ref)
      : super(AcceptFreeTrialState.initial());

  final IGetFreeTrialRepository _acceptFreeTrialRepository;
  final Ref ref;
  Future<void> acceptFreeTrialData(String mobileUserPublicKey) async {
    try {
      state = AcceptFreeTrialState.loading();

      final acceptFreeTrialResponseData = await _acceptFreeTrialRepository
          .acceptFreeTrialData(mobileUserPublicKey);

      if (acceptFreeTrialResponseData.result == "FreeTrialActivated") {
        state = AcceptFreeTrialState.loaded(acceptFreeTrialResponseData);
      }
    } catch (e) {
      state = AcceptFreeTrialState.error(e.toString());
    }
  }
}

final acceptFreeTrialNotifier =
    StateNotifierProvider<AcceptFreeTrialNotifier, AcceptFreeTrialState>(
        ((ref) {
  final IGetFreeTrialRepository acceptFreeTrialRepository =
      getIt<IGetFreeTrialRepository>();
  return AcceptFreeTrialNotifier(acceptFreeTrialRepository, ref);
}));
