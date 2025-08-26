import 'package:research_mantra_official/data/models/research/research_detail_data_model.dart';

class ResearchDetailsState {
  final dynamic error;
  final bool isLoading;
  final ResearchDataModel? researchDataModel;

  ResearchDetailsState({
    required this.isLoading,
    this.error,
    this.researchDataModel,
  });

  factory ResearchDetailsState.initial() => ResearchDetailsState(
        isLoading: false,
        researchDataModel: null,
      );
  factory ResearchDetailsState.loading() => ResearchDetailsState(
        isLoading: true,
      );

  factory ResearchDetailsState.loaded(ResearchDataModel researchDataModel) =>
      ResearchDetailsState(
        isLoading: false,
        researchDataModel: researchDataModel,
      );
  factory ResearchDetailsState.error(dynamic error) => ResearchDetailsState(
        isLoading: false,
        error: error,
        researchDataModel: null,
      );
}
