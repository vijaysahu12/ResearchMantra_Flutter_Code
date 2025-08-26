import 'package:research_mantra_official/data/models/product_details_content_api_response_model.dart';

class ProductDetailsContentState {
  final List<ProductDetailsItemApiResponseModel?>
      productItemContentApiResponseModel;
  final bool isLoading;
  final dynamic error;

  ProductDetailsContentState({
    required this.productItemContentApiResponseModel,
    required this.isLoading,
    this.error,
  });

  factory ProductDetailsContentState.initial() => ProductDetailsContentState(
        productItemContentApiResponseModel: [],
        isLoading: false,
      );
  factory ProductDetailsContentState.loading() => ProductDetailsContentState(
        productItemContentApiResponseModel: [],
        isLoading: true,
      );

  factory ProductDetailsContentState.loaded(
          List<ProductDetailsItemApiResponseModel>
              productItemContentApiResponseModel) =>
      ProductDetailsContentState(
        productItemContentApiResponseModel: productItemContentApiResponseModel,
        isLoading: false,
      );
  factory ProductDetailsContentState.error(dynamic error) =>
      ProductDetailsContentState(
        productItemContentApiResponseModel: [],
        isLoading: false,
        error: error,
      );
}
