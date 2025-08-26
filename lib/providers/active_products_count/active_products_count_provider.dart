import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IActive_product_count_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/active_products_count/active_products_count_state.dart';

class ActiveProductsCountStateNotifier
    extends StateNotifier<ActiveProductsCountState> {
  ActiveProductsCountStateNotifier(this._activeProductCountRepository)
      : super(ActiveProductsCountState.initial());
  final IActiveProductCountRepository _activeProductCountRepository;

  Future<void> getActiveProducts() async {
    try {
      state = ActiveProductsCountState.loading();
      final activeProducts =
          await _activeProductCountRepository.getActiveProducts();
      state = ActiveProductsCountState.success(activeProducts);
    } catch (e) {
      state = ActiveProductsCountState.error(state.error);
    }
  }
}

final activeProductsCountStateNotifierProvider = StateNotifierProvider<
    ActiveProductsCountStateNotifier, ActiveProductsCountState>((ref) {
  final IActiveProductCountRepository activeProductCountRepository =
      getIt<IActiveProductCountRepository>();
  return ActiveProductsCountStateNotifier(activeProductCountRepository);
});
