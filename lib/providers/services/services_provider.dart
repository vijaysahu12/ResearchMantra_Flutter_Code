import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IServices_repositry.dart';
import 'package:research_mantra_official/main.dart';

import 'package:research_mantra_official/providers/services/services_state.dart';

class ServicesStateNotifier extends StateNotifier<ServicesState> {
  ServicesStateNotifier(this._iServicesRepository)
      : super(ServicesState.initial());

  final IServicesReposity _iServicesRepository;
  
  Future<void> getServicesList() async {
    try {
      state = ServicesState.loading();
      final servicesList = await _iServicesRepository.getServicesList();
      state = ServicesState.success(servicesList);
    } catch (error) {
      state = ServicesState.error(error.toString());
    }
  }
}

final getServicesStateNotifierProvider =
    StateNotifierProvider<ServicesStateNotifier, ServicesState>((ref) {
  final IServicesReposity iServicesRepository = getIt<IServicesReposity>();
  return ServicesStateNotifier(iServicesRepository);
});
