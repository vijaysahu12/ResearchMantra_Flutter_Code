import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IResearch_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/research/baskets/baskets_state.dart';

class GetBasketNotifier extends StateNotifier<BasketState> {
  GetBasketNotifier(this._researchRepository) : super(BasketState.initial());

  final IResearchRepository _researchRepository;

  Future<void> getBasket(bool isRefresh) async {
    try {
      if (isRefresh || state.getAllBasketDataModel.isEmpty) {
        state = BasketState.loading();
      }

      final getAllBasket = await _researchRepository.getBasket();
      state = BasketState.loaded(getAllBasket);
    } catch (e) {
      state = BasketState.error(e.toString());
    }
  }
}

final getBasketProvider =
    StateNotifierProvider<GetBasketNotifier, BasketState>(((ref) {
  final IResearchRepository researchDetailsRepository =
      getIt<IResearchRepository>();
  return GetBasketNotifier(researchDetailsRepository);
}));
