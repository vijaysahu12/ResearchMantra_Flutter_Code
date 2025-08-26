import 'package:research_mantra_official/data/models/scanners/scanners_model.dart';

class ScannersTodayState {
  final ScannerNotificationResponseModel? scannersResponseModel;
  final bool isLoading;
  final dynamic error;
  final bool isLoadmore;

  const ScannersTodayState({
    required this.scannersResponseModel,
    required this.isLoading,
    required this.isLoadmore,
    required this.error,
  });

  factory ScannersTodayState.initial() => const ScannersTodayState(
        scannersResponseModel: null,
        error: null,
        isLoading: false,
        isLoadmore: false,
      );

  factory ScannersTodayState.loading() => const ScannersTodayState(
      scannersResponseModel: null,
      error: null,
      isLoading: true,
      isLoadmore: false);

  factory ScannersTodayState.loaded(
    final ScannerNotificationResponseModel scannersResponseModel,
  ) =>
      ScannersTodayState(
          scannersResponseModel: scannersResponseModel,
          error: null,
          isLoading: false,
          isLoadmore: false);

  factory ScannersTodayState.error(dynamic error) => ScannersTodayState(
      scannersResponseModel: null,
      error: error,
      isLoading: false,
      isLoadmore: false);
}
