import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IScreeners_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/screeners/screeners_stock/screeners_stock_state.dart';

class ScreenerStockProvider extends StateNotifier<ScreenerStockState> {
  ScreenerStockProvider(this._screenersRepository)
      : super(ScreenerStockState.initial());

  final IScreenersRepository _screenersRepository;

  Future<void> getStock(int id, String code) async {
    try {
      state = ScreenerStockState.loading();
      // }
      final getStock = await _screenersRepository.getStockScreeners(id, code);

      state = ScreenerStockState.loaded(getStock);
    } catch (e) {
      print(e);
      print('thisss iss theee loggggeeeed daaataaaaaaa');
      state = ScreenerStockState.error(e.toString());
    }
  }
}

final screenerStockProvider =
    StateNotifierProvider<ScreenerStockProvider, ScreenerStockState>(((ref) {
  final IScreenersRepository screenersStockRepository =
      getIt<IScreenersRepository>();
  return ScreenerStockProvider(screenersStockRepository);
}));
