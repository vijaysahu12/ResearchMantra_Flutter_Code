import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/constants/storage.dart';
import 'package:research_mantra_official/data/models/dashboard/dashboard_slider_model.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IDashBoard_respository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/images/dashboard/dashboard_state.dart';
import 'package:research_mantra_official/services/secure_storage.dart';

import 'package:research_mantra_official/services/user_secure_storage_service.dart';

//DashBoard stateNotifier for images
class DashBoardStateNotifier extends StateNotifier<DashBoardState> {
  DashBoardStateNotifier(this._boardRepository)
      : super(DashBoardState.initail());

  final IDashBoardRepository _boardRepository;

//Method to Get DashBoard Ihages
  Future<void> getDashBoardImagesList(String imageType, bool isRefresh) async {
    try {
      if (state.dashBoardImages.isEmpty || !isRefresh) {
        state = DashBoardState.loading();
        final List<CommonImagesResponseModel> dashBoardImages =
            await _boardRepository.getDashBoardSliderImages(imageType);

        state = DashBoardState.loadedImages(dashBoardImages);
      }

      // final List<CommonImagesResponseModel> dashBoardImages =
      //     await _boardRepository.getDashBoardSliderImages(imageType);

      state = DashBoardState.loadedImages(state.dashBoardImages);
    } catch (error) {
      state = DashBoardState.error(error.toString());
    }
  }
}

final dashBoardImagesProvider =
    StateNotifierProvider<DashBoardStateNotifier, DashBoardState>((ref) {
  final IDashBoardRepository dashBoard = getIt<IDashBoardRepository>();
  return DashBoardStateNotifier(dashBoard);
});

//get user updated details
class UserProfile {
  final String? userName;
  final String? profileImage;
  final String? selectedGender;

  UserProfile({this.userName, this.profileImage, this.selectedGender});
}

class UserProfileNotifier extends StateNotifier<UserProfile> {
  UserProfileNotifier() : super(UserProfile());

  final UserSecureStorageService _commonDetails = UserSecureStorageService();
  final SecureStorage _secureStorage = getIt<SecureStorage>();
  void updateUserProfile(UserProfile profile) {
    state = profile;
  }

  final UserSecureStorageService commonDetails = UserSecureStorageService();

  Future<void> loadUserProfile() async {
    try {
      Map<String, dynamic> userDetails = await commonDetails.getUserDetails();
      String? selectedGender = await commonDetails.getSelectedGender();

      state = UserProfile(
        userName: userDetails['fullName'],
        profileImage: userDetails['profileImage'],
        selectedGender: selectedGender,
      );
    } catch (e) {
      print('Error loading user details: $e');
      state = UserProfile(
        userName: "",
        profileImage: "",
        selectedGender: maleGenderValue,
      );
    }
  }

  Future<void> deleteProfileImage() async {
    try {
      // Update state to reflect the deleted profile image (set profileImage to null)
      state = UserProfile(
        userName: state.userName,
        profileImage: null,
        selectedGender: state.selectedGender,
      );

      // Get all user details from storage
      Map<String, dynamic> userDetails = await _commonDetails.getUserDetails();

      // Update the profileImage to null in the userDetails map
      userDetails['profileImage'] = null;

      // Convert userDetails map to JSON string
      String userDetailsJson = json.encode(userDetails);

      // Update secure storage with the modified userDetails JSON string
      await _secureStorage.write(loggedInUserDetails, userDetailsJson);

      // Optionally, print the updated profile image value for verification
      print('Updated profileImage value: ${userDetails['profileImage']}');
    } catch (e) {
      print('Error deleting profile image: $e');
    }
  }
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile>(
  (ref) => UserProfileNotifier(),
);

//iscalled Provider
class IsCalledNotifier extends StateNotifier<bool> {
  IsCalledNotifier() : super(false); // Ensure API runs on first load

  void setCalled(bool value) {
    state = value;
  }
}

final isCalledProvider = StateNotifierProvider<IsCalledNotifier, bool>(
  (ref) => IsCalledNotifier(),
);

// class IsApidNotifier extends StateNotifier<bool> {
//   IsApidNotifier() : super(true);

//   void setApiCalled(bool value) {
//     state = value;
//   }
// }

// final isApiCalledProvider = StateNotifierProvider<IsCalledNotifier, bool>(
//   (ref) => IsCalledNotifier(),
// );
