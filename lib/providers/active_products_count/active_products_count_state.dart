import 'package:research_mantra_official/data/models/total_products/active_product_count_model.dart';

class ActiveProductsCountState {
  final bool isLoading;
  final dynamic error;
  final ActiveProductCountModel? activeProductCountModel;

  ActiveProductsCountState(
      {required this.isLoading,
      required this.error,
      required this.activeProductCountModel});

  factory ActiveProductsCountState.initial() => ActiveProductsCountState(
      isLoading: false, error: null, activeProductCountModel: null);

  factory ActiveProductsCountState.loading() => ActiveProductsCountState(
      isLoading: true, error: null, activeProductCountModel: null);
  factory ActiveProductsCountState.success(
          ActiveProductCountModel activeProductCountModel) =>
      ActiveProductsCountState(
          isLoading: false,
          error: null,
          activeProductCountModel: activeProductCountModel);
  factory ActiveProductsCountState.error(dynamic error) =>
      ActiveProductsCountState(
          isLoading: false, error: error, activeProductCountModel: null);
}
