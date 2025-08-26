import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/constants/storage.dart';
import 'package:research_mantra_official/data/models/user_login_response_model.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IUser_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/userpersonaldetails/user_personal_details_state.dart';
import 'package:research_mantra_official/services/secure_storage.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

// State notifier for managing user personal details
class UserPersonalDetailsStateNotifier
    extends StateNotifier<UserPersonalDetailsState> {
  final UserSecureStorageService _commonDetails = UserSecureStorageService();
  final SecureStorage _secureStorage = getIt<SecureStorage>();

  final IUserRepository _iUserRepository;

  // Constructor to initialize the state notifier
  UserPersonalDetailsStateNotifier(this._iUserRepository)
      : super(UserPersonalDetailsState.initial());

  // Method to fetch user personal details
  Future<void> getUserPersonalDetails(String mobileUserPublicKey) async {
    // Set state to loading
    state = UserPersonalDetailsState.loading(null);
    try {
      // Retrieve user personal details from repository
      final getUserPersonaldetails =
          await _iUserRepository.getUserPersonalDetails(mobileUserPublicKey);

      // Retrieve user details from secure storage
      final userDetails = await _commonDetails.getUserDetails();
      final userData = UserData.fromJson(userDetails);

      // Update UserData object with personal details
      userData.updateFromPersonalDetails(getUserPersonaldetails);

      // Update the details to secured storage after update success
      _commonDetails.manage(userData.toJson());

      // Set state to success with fetched personal details
      state = UserPersonalDetailsState.success(getUserPersonaldetails!);
    } catch (error) {
      // Set state to error if any exception occurs
      state = UserPersonalDetailsState.error(error, state.userPersonalDetails);
    }
  }

  // Method to fetch user personal details
  Future<void> deleteUserProfileImage(String mobileUserPublicKey) async {
    try {
      // Retrieve user personal details from repository
      final response =
          await _iUserRepository.deleteUserProfileImage(mobileUserPublicKey);
      // Set state to loading
      state = UserPersonalDetailsState.afterDeleteProfileImage(
          state.userPersonalDetails);

      if (response.status) {
        final getUserPersonaldetails =
            await _iUserRepository.getUserPersonalDetails(mobileUserPublicKey);

        state = UserPersonalDetailsState.success(getUserPersonaldetails);
        // await getUserPersonalDetails(mobileUserPublicKey);
      } else {
        ToastUtils.showToast(somethingWentWrong, "error");
        state = UserPersonalDetailsState.success(state.userPersonalDetails);
      }
    } catch (error) {
      // Set state to error if any exception occurs
      state = UserPersonalDetailsState.error(error, state.userPersonalDetails);
    }
  }

  //Method to logout
  Future<void> manageLogoutApp(
      String mobileUserPublicKey, String mobileUserFcmToken) async {
    try {
      final response = await _iUserRepository.manageLogoutApi(
          mobileUserPublicKey, mobileUserFcmToken);
      if (response != null && response.status) {
        print(response);
      }
    } catch (e) {
      print(e);
    }
  }

  // Method to manage user personal details
  Future<void> manageUserPersonalDetailsProvider(
      bool isFirst,
      String mobileUserPublicKey,
      String fullName,
      String emailId,
      String mobileNumber,
      String city,
      String gender,
      String dateOfBirth,
      File? image,
      [clb]) async {
    try {
      // // Set state to loading
      state = UserPersonalDetailsState.loading(state.userPersonalDetails);
      // If response is not successful, set state to success and show error message
      // state = UserPersonalDetailsState.success(state.userPersonalDetails);
      if (!isFirst) {
        state = UserPersonalDetailsState.manageUserDetails(
            state.userPersonalDetails!);
      }

      // Update user personal details through repository
      final response = await _iUserRepository.manageUserPersonalDetails(
        mobileUserPublicKey,
        fullName,
        emailId,
        mobileNumber,
        city,
        gender,
        dateOfBirth,
        image,
      );
      _secureStorage.write(userGender, gender);

      // Check if the response is successful
      if (response != null && response.status) {
        // Call getUserPersonalDetails method from getUserPersonalDetails provider
        // Retrieve user personal details from repository
        final getUserPersonaldetails =
            await _iUserRepository.getUserPersonalDetails(mobileUserPublicKey);

        // Retrieve user details from secure storage
        final userDetails = await _commonDetails.getUserDetails();
        final userData = UserData.fromJson(userDetails);

// Update UserData object with personal details
        userData.updateFromPersonalDetails(getUserPersonaldetails);

// Update the gender in userData object
        userData.gender = getUserPersonaldetails!.gender ?? 'male';

// // Update userProfile gender
// // Update userProfile gender
//         state.userPersonalDetails!.gender = getUserPersonaldetails.gender;

        // Update the details to secured storage after update success
        _commonDetails.manage(userData.toJson());
        ToastUtils.showToast("Updated Sucessfully", null);
        state = UserPersonalDetailsState.success(getUserPersonaldetails);

        // await getUserPersonalDetails(mobileUserPublicKey);
        if (clb != null) clb();
      } else {
        // If response is not successful, set state to success and show error message
        state = UserPersonalDetailsState.success(state.userPersonalDetails);
        ToastUtils.showToast(response!.message, 'error');
      }
    } catch (error) {
      // Handle any errors
      state = UserPersonalDetailsState.error(error, state.userPersonalDetails);
      ToastUtils.showToast(somethingWentWrong, 'error');
    }
  }

  //Method for delete account
  Future<bool> accountDelete(String mobileUserKey, String reason) async {
    try {
      final response =
          await _iUserRepository.deleteAccount(mobileUserKey, reason);
      if (response.status) {
        return response.status;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}

// Provider for user personal details state notifier
final getUserPersonalDetailsStateNotifierProvider = StateNotifierProvider<
    UserPersonalDetailsStateNotifier, UserPersonalDetailsState>((ref) {
  final IUserRepository getUserPersonalDetailsRepository =
      getIt<IUserRepository>();
  return UserPersonalDetailsStateNotifier(getUserPersonalDetailsRepository);
});


//Provider for checking Package VERSION

final appVersionProvider = FutureProvider<String>((ref) async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
});