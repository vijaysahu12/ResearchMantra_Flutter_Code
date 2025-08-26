import 'package:research_mantra_official/data/models/research/get_basket_data_model.dart';

class BasketState {
  final dynamic error;
  final bool isLoading;
  final List<BasketDataModel> getAllBasketDataModel;

  BasketState({
    required this.isLoading,
    this.error,
    required this.getAllBasketDataModel,
  });

  factory BasketState.initial() => BasketState(
        isLoading: false,
        getAllBasketDataModel: [],
      );
  factory BasketState.loading() => BasketState(
        isLoading: true,
        getAllBasketDataModel: [],
      );

  factory BasketState.loaded(List<BasketDataModel> getAllBasketDataModel) =>
      BasketState(
        isLoading: false,
        getAllBasketDataModel: getAllBasketDataModel,
      );
  factory BasketState.error(dynamic error) => BasketState(
        isLoading: false,
        error: error,
        getAllBasketDataModel: [],
      );
}
