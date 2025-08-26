import 'package:research_mantra_official/data/models/sip_calculator/sip_response_model.dart';

class SipCalculatorState {
  final bool isLoading;
  final dynamic error;
  final SipResponseModel? sipResponseModel;

  SipCalculatorState({required this.isLoading,required this.error,required this.sipResponseModel}); 
    
    factory SipCalculatorState.initial() => SipCalculatorState(isLoading: false, error: null, sipResponseModel: null);

    factory SipCalculatorState.loading() => SipCalculatorState(isLoading: true, error: null, sipResponseModel: null);

    factory SipCalculatorState.success(SipResponseModel sipResponseModel) => SipCalculatorState(isLoading: false, error: null, sipResponseModel: sipResponseModel);

    factory SipCalculatorState.error(dynamic error) => SipCalculatorState(isLoading: false, error: error, sipResponseModel: null);
  }



