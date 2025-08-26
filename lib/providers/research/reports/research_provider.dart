import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/research/research_detail_data_model.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IResearch_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/research/reports/research_state.dart';

class ResearchDetailsNotifier extends StateNotifier<ResearchDetailsState> {
  ResearchDetailsNotifier(this._researchRepository)
      : super(ResearchDetailsState.initial());

  final IResearchRepository _researchRepository;

  Future<void> getReportDataModel(Map<String, dynamic> body) async {
    try {
      state = ResearchDetailsState.loading();

      final ResearchDataModel researchDataModel =
          await _researchRepository.getReport(body);

      state = ResearchDetailsState.loaded(researchDataModel);
    } catch (e) {
      state = ResearchDetailsState.error(e.toString());
    }
  }

Future<void> updateCommentCount(String operation) async {
  try {
    ResearchDataModel researchDataModel =
        state.researchDataModel ?? ResearchDataModel();

    switch (operation) {
      case "add":
        // Increment the comment count correctly
        researchDataModel.commentCount = (researchDataModel.commentCount ?? 0) + 1;
        break;

      case "del":
        // Decrement the comment count safely
        if (researchDataModel.commentCount != null && researchDataModel.commentCount! > 0) {
          researchDataModel.commentCount = researchDataModel.commentCount! - 1;
        } else {
          researchDataModel.commentCount = 0; // Set to 0 if it's already 0 or null
        }
        break;

      default:
        // Optionally handle the default case
        break;
    }

    // Update the state with the new model
    state = ResearchDetailsState.loaded(researchDataModel);
  } catch (e) {
    state = ResearchDetailsState.error(e.toString());
  }
}

}

final researchDetailsProvider =
    StateNotifierProvider<ResearchDetailsNotifier, ResearchDetailsState>(
        ((ref) {
  final IResearchRepository researchDetailsRepository =
      getIt<IResearchRepository>();
  return ResearchDetailsNotifier(researchDetailsRepository);
}));
