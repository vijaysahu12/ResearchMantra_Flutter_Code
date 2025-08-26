import 'package:research_mantra_official/data/models/product_api_response_model.dart';

class ProductListState {
  final List<ProductApiResponseModel> productApiResponseModel;
  final dynamic error;
  final bool isLoading;

  ProductListState({
    required this.productApiResponseModel,
    required this.isLoading,
    this.error,
  });

  factory ProductListState.initial() => ProductListState(
        productApiResponseModel: [],
        isLoading: false,
      );
  factory ProductListState.loading() => ProductListState(
        productApiResponseModel: [],
        isLoading: true,
      );

  factory ProductListState.loaded(
          List<ProductApiResponseModel> productApiResponseModel) =>
      ProductListState(
        productApiResponseModel: productApiResponseModel,
        isLoading: false,
      );
  factory ProductListState.error(dynamic error) => ProductListState(
        productApiResponseModel: [],
        isLoading: false,
        error: error,
      );

}
