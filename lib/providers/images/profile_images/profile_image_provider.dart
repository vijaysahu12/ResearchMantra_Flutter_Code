import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/dashboard/dashboard_slider_model.dart';
import 'package:research_mantra_official/providers/images/profile_images/profile_image_states.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IDashBoard_respository.dart';
import 'package:research_mantra_official/main.dart';

//profilescreen images notifier
class ProfileScreenImagesStateNotifier
    extends StateNotifier<ProfileScreenImagesState> {
  ProfileScreenImagesStateNotifier(this._boardRepository)
      : super(ProfileScreenImagesState.initail());

  final IDashBoardRepository _boardRepository;

  //Method to Get DashBoard Ihages
  Future<void> getProfileImagesList(String imageType) async {
    try {
      if (state.profileScreenImage.isEmpty) {
        state = ProfileScreenImagesState.loading();
      }

      final List<CommonImagesResponseModel> profileScreenImages =
          await _boardRepository.getDashBoardSliderImages(imageType);
      state = ProfileScreenImagesState.profileImages(profileScreenImages);
    } catch (error) {
      state = ProfileScreenImagesState.error(error.toString());
    }
  }
}

final profileScreenImagesProvider = StateNotifierProvider<
    ProfileScreenImagesStateNotifier, ProfileScreenImagesState>((ref) {
  final IDashBoardRepository profileScreenImages =
      getIt<IDashBoardRepository>();
  return ProfileScreenImagesStateNotifier(profileScreenImages);
});
