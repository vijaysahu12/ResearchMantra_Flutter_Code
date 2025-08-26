
import 'package:research_mantra_official/data/models/screeners/stock_data_model.dart';

class ScreenerStockState {
  final dynamic error;
  final bool isLoading;
  final  List<Stock> stockModel;

  ScreenerStockState({
    required this.isLoading,
    this.error,
    required this.stockModel,
  });

  factory ScreenerStockState.initial() => ScreenerStockState(
        isLoading: false,
        stockModel: []
      );
  factory ScreenerStockState.loading() => ScreenerStockState(
        isLoading: true,
        stockModel: [],
      );

  factory ScreenerStockState.loaded(List<Stock> stockModel) =>
      ScreenerStockState(
        isLoading: false,
        stockModel: stockModel,
      );
  factory ScreenerStockState.error(dynamic error) => ScreenerStockState(
        isLoading: false,
        error: error,
        stockModel: [],
      );
}
