class GetProductImageState {
  final String? productImageEndpoint;
  final bool isLoading;
  final dynamic error;

  GetProductImageState(
      {required this.productImageEndpoint,
      required this.isLoading,
      required this.error});

  factory GetProductImageState.inital() => GetProductImageState(
      productImageEndpoint: null, isLoading: true, error: null);

  factory GetProductImageState.isLoading() => GetProductImageState(
      productImageEndpoint: null, isLoading: true, error: null);

  factory GetProductImageState.loaded(String productImageEndpoint) =>
      GetProductImageState(
          productImageEndpoint: productImageEndpoint,
          isLoading: false,
          error: null);

  factory GetProductImageState.error(dynamic error) => GetProductImageState(
      productImageEndpoint: null, isLoading: false, error: error);
}
