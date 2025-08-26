import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/advertisement/advertisement_response.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IProfile_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/profileadvertisements/advertisement_state.dart';

class ProfileAdvertisementStateNotifier
    extends StateNotifier<AdvertisementState> {
  ProfileAdvertisementStateNotifier(this._profileRepository)
      : super(AdvertisementState.initail());
  final IProfileRepository _profileRepository;

  //Method to get Advertisementlist
  Future<void> getAdvertisementImageWithUrl() async {
    state = AdvertisementState.loading();
    try {
      final AdvertisementResponseModel? getAdvertisementDetails =
          await _profileRepository.getAdvertisementList();

      state = AdvertisementState.success(getAdvertisementDetails);
    } catch (error) {
      state = AdvertisementState.error(error);
    }
  }
}

final getAdvertisementStateNotifierProvider = StateNotifierProvider<
    ProfileAdvertisementStateNotifier, AdvertisementState>((ref) {
  final IProfileRepository getProfileAdvertisementDetails =
      getIt<IProfileRepository>();
  return ProfileAdvertisementStateNotifier(getProfileAdvertisementDetails);
});
