import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:research_mantra_official/data/repositories/interfaces/IGet_Free_trial_respositiry.dart';
import 'package:research_mantra_official/main.dart';

import 'package:research_mantra_official/providers/get_free_trial/get_free_trial_state.dart';

class GetFreeTrialNotifier extends StateNotifier<GetFreeTrialState> {
  GetFreeTrialNotifier(this._getFreeTrialRespository, this.ref)
      : super(GetFreeTrialState.initial());

  final IGetFreeTrialRepository _getFreeTrialRespository;
  final Ref ref;

  Future<void> getFreeTrialData(String mobileUserPublicKey) async {
    if (state.getFreeTrialDataModel == null) {
      state = GetFreeTrialState.loading();
    }

    try {
      final getFreeTrialData =
          await _getFreeTrialRespository.getFreeTrialData(mobileUserPublicKey);

      state = GetFreeTrialState.loaded(getFreeTrialData);
    } catch (e) {
      state = GetFreeTrialState.error(e.toString());
    }
  }

  void reset() {
    state = GetFreeTrialState.initial();
  }
}

final getFreeTrialNotifier =
    StateNotifierProvider<GetFreeTrialNotifier, GetFreeTrialState>(((ref) {
  final IGetFreeTrialRepository getFreeTrialRepository =
      getIt<IGetFreeTrialRepository>();
  return GetFreeTrialNotifier(getFreeTrialRepository, ref);
}));
