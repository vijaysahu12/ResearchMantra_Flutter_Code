import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/repositories/interfaces/ILearning_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/learning/graph/graph_state.dart';

class GraphListNotifier extends StateNotifier<GrapthState> {
  GraphListNotifier(this._learningRepository)
      : super(GrapthState.initial());

  final ILearningRepository _learningRepository;

   Future<void> getGraphList(String endPoint ,int id) async {
        try {
    state = GrapthState.loading();

      final getAllLearningMaterial =
          await _learningRepository.getAllGraphMaterial(endPoint,id);


      state = GrapthState.loaded(getAllLearningMaterial);
    } catch (e) {
      state = GrapthState.error(e.toString());
    }
  }
}

final getGraphProvider =
    StateNotifierProvider<GraphListNotifier, GrapthState>(((ref) {
  final ILearningRepository  graphListRepository = getIt<ILearningRepository>();
  return GraphListNotifier(graphListRepository);
}));
