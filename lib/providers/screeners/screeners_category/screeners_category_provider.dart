import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IScreeners_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/screeners/screeners_category/screeners_category_state.dart';

class ScreenerCategoryNotifier extends StateNotifier<ScreenerCategoryState> {
  ScreenerCategoryNotifier(this._screenersRepository) : super(ScreenerCategoryState.initial());

  final IScreenersRepository _screenersRepository;

  Future<void> getCategory() async {
    try {
    
        state = ScreenerCategoryState.loading();
      // }
      final getCategory = await _screenersRepository.getCategoryScreeners();
      state = ScreenerCategoryState.loaded(getCategory);
    } catch (e) {
      state = ScreenerCategoryState.error(e.toString());
    }
  }
}

final screenerCategoryProvider =
    StateNotifierProvider<ScreenerCategoryNotifier, ScreenerCategoryState>(((ref) {
  final IScreenersRepository screenersRepository =
      getIt<IScreenersRepository>();
  return ScreenerCategoryNotifier(screenersRepository);
}));
