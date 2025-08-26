
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/repositories/interfaces/ITickets_respository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/get_support_mobile/support_mobile_state.dart';

class GetSupportMobileNumberProvider extends StateNotifier<GetSupportState> {
  GetSupportMobileNumberProvider(this._iTicketRespository)
      : super(GetSupportState.init());

  final ITicketRespository _iTicketRespository;

  //Method to get Support mobile Data
  Future<void> getSupportMobileData() async {
    try {
      state = GetSupportState.isLoading();
      final String response =
          await _iTicketRespository.getSupportMobileDetails();

      state = GetSupportState.loaded(response);
    } catch (e) {
      state = GetSupportState.error(e);
    }
  }
}

final getSupportMobileStateProvider =
    StateNotifierProvider<GetSupportMobileNumberProvider, GetSupportState>(
        (ref) {
  final ITicketRespository getSupportMobileData = getIt<ITicketRespository>();
  return GetSupportMobileNumberProvider(getSupportMobileData);
});
