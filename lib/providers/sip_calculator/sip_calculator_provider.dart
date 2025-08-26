

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/sip_calculator/sip_request_model.dart';
import 'package:research_mantra_official/data/repositories/interfaces/ISip_calculator_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/sip_calculator/sip_calculator_state.dart';

class SipCalculatorStateNotifier extends StateNotifier<SipCalculatorState>{
  SipCalculatorStateNotifier(this._sipCalculatorRepository):super(SipCalculatorState.initial());

  final ISipCalculatorRepository _sipCalculatorRepository;

  Future<void> postSipCalculator(SipRequestModel model) async {
    try { 
      state = SipCalculatorState.loading();
      final postSip = await _sipCalculatorRepository.postSipCalculator(model);
   
      state = SipCalculatorState.success(postSip);
    } catch (e) {
      state = SipCalculatorState.error(state.error);
    }
  }
}

final sipCalculatorStateNotifierProvider = StateNotifierProvider<SipCalculatorStateNotifier, SipCalculatorState>((ref) {
  final ISipCalculatorRepository sipCalculatorRepository = getIt<ISipCalculatorRepository>();
  return SipCalculatorStateNotifier(sipCalculatorRepository); 
});
