import 'package:research_mantra_official/data/models/advertisement/advertisement_response.dart';

class AdvertisementState {
  final AdvertisementResponseModel? advertisementResponseModel;
  final dynamic error;
  final bool isLoading;

  AdvertisementState(
      {required this.advertisementResponseModel,
      required this.error,
      required this.isLoading});

  factory AdvertisementState.initail() => AdvertisementState(
      advertisementResponseModel: null, error: null, isLoading: false);

  factory AdvertisementState.loading() => AdvertisementState(
      advertisementResponseModel: null, error: null, isLoading: true);

  factory AdvertisementState.success(
          AdvertisementResponseModel? advertisementResponseModel) =>
      AdvertisementState(
          advertisementResponseModel: advertisementResponseModel,
          error: null,
          isLoading: false);

  factory AdvertisementState.error(dynamic error) => AdvertisementState(
      advertisementResponseModel: null, error: error, isLoading: false);
}
