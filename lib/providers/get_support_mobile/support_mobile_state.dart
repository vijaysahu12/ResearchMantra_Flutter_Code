class GetSupportState {
  final bool isLoading;
  final dynamic error;
  final String? data;

  const GetSupportState(
      {required this.error, required this.isLoading, this.data});

  factory GetSupportState.init() =>
      const GetSupportState(error: null, isLoading: false, data: null);
  factory GetSupportState.isLoading() =>
      const GetSupportState(error: null, isLoading: true, data: null);
  factory GetSupportState.error(dynamic error) =>
      GetSupportState(error: error, isLoading: false, data: null);

  factory GetSupportState.loaded(String? data) =>
      GetSupportState(error: null, isLoading: false, data: data);
}
