

import 'package:research_mantra_official/data/models/learning_material.dart/indicator_description_data_model.dart';

class IndicatorDescriptionState {
  final dynamic error;
  final bool isLoading;

    IndicatorBindingDataModel? indicatorBindingDataModel;

  IndicatorDescriptionState({
    required this.isLoading,
    this.error,
        this.indicatorBindingDataModel,

  });

  factory IndicatorDescriptionState.initial() => IndicatorDescriptionState(
        isLoading: false,
        indicatorBindingDataModel: null,

      );
  factory IndicatorDescriptionState.loading() => IndicatorDescriptionState(
        isLoading: true,
      );

  factory IndicatorDescriptionState.loaded(IndicatorBindingDataModel? indicatorBindingDataModel) =>
      IndicatorDescriptionState(
        isLoading: false,
         indicatorBindingDataModel: indicatorBindingDataModel,
    
      );
  factory IndicatorDescriptionState.error(dynamic error) => IndicatorDescriptionState(
        isLoading: false,
        error: error,
        indicatorBindingDataModel:null,
        
 );
}