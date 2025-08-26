import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/constants/storage.dart';
import 'package:research_mantra_official/data/models/user_login_response_model.dart';
import 'package:research_mantra_official/data/network/http_client.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/login/login_state.dart';
import 'package:research_mantra_official/services/secure_storage.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';

import '../../data/repositories/interfaces/IUser_repository.dart';
import '../../utils/firebase_notifications_utils.dart';

// Provider for managing login state
final loginProvider =
    StateNotifierProvider<UserStateNotifier, LoginState>((ref) {
  final IUserRepository userRepository = getIt<IUserRepository>();
  return UserStateNotifier(userRepository);
});

// Class to manage user login state and actions
class UserStateNotifier extends StateNotifier<LoginState> {
  final IUserRepository _userRepository;
  final SecureStorage _secureStorage = getIt<SecureStorage>();
  final UserSecureStorageService _commonDetails = UserSecureStorageService();
  SharedPref pref = SharedPref();

  // Constructor initializing the user state notifier
  UserStateNotifier(this._userRepository) : super(LoginState.loggedOut());

  // Method to handle user login
  void login(
      String countryCode, String mobileNumber, bool isNotFromOtpScreen) async {
    try {
      state = LoginState.loading();

      // Call the login method from the user repository
      var result = await _userRepository.doLogin(mobileNumber, countryCode);

      // Process the result of the login attempt

      if (result != null &&
          (result.result == otpsent || result.result == otpRegistered)) {
        result.userData.mobileNumber = mobileNumber;

        //  Save user details in secure storage for future use
        cacheUserAndSessionDetails(result.userData);

        state = LoginState.otpSent(result.userData, isNotFromOtpScreen);

        ToastUtils.showToast(result.message, '');
      } else if (result?.result == otplimitreached) {
        state = LoginState.otpRetryLimitReached(result!.message);
      } else {
        state = LoginState.failed(message: somethingWentWrong, user: null);
      }
    } on Exception catch (ex) {
      state = LoginState.error(ex, user: null);
    }
  }

  // Method to handle OTP verification and subscription
  void otpLoginVerificationAndGetSubscription(
      String otp, String deviceInfo, String version) async {
    try {
      state =
          LoginState.loading(user: state.user); // Retain previous user state

      if (state.user?.publicKey == null) {
        state =
            LoginState.failed(message: userDataNotAvailable, user: state.user);
        return;
      }

      // Get FCM token with fallback to "NOFCMTOKEN"
      // 🔹 Securely get FCM token with fallback
      String token = "NOFCMTOKEN";
      try {
        token = await FirebaseNotificationsUtils.getToken() ?? "NOFCMTOKEN";
      } catch (e) {
        print("Error fetching FCM token: $e");
        HttpClient httpClient = getIt<HttpClient>();
        await httpClient
            .postOthers("$other?message= FCM token fetch failed: $e");
        token = "NOFCMTOKEN";
      }

      // Perform OTP verification & subscription
      var result = await _userRepository.otpLoginVerificationAndGetSubscription(
          state.user?.publicKey ?? '', otp, token, deviceInfo, version);

      if (result == null) {
        state = LoginState.failed(
            message: otpVerificationFailedMsg, user: state.user);
        return;
      }

      if (result['statusCode'] != 200) {
        state = LoginState.failed(message: result['message'], user: state.user);
        return;
      }

      // Convert response data
      OtpVerificationResponseModel apiResponseData = result['data'];

      // Update user profile details
      state.user!
        ..gender = apiResponseData.gender
        ..accessToken = apiResponseData.accessToken
        ..refreshToken = apiResponseData.refreshToken;

      // Save user details securely
      cacheUserAndSessionDetails(state.user);
      _commonDetails.saveRefreshToken(state.user?.refreshToken ?? "");
      _secureStorage.write(fcmToken, token);
      _secureStorage.write(userGender, apiResponseData.gender);
      await pref.setBool(tutorialShown, false);

      state =
          LoginState.otpIsVerified(state.user!, apiResponseData.isExistingUser);
    } on Exception catch (ex) {
      print("---$ex");

      state = LoginState.failed(message: somethingWentWrong, user: state.user);
    }
  }

  void cacheUserAndSessionDetails(userdetails) async {
    if (userdetails != null) {
      print("${userdetails.toJson()}----user data cacheUserAndSessionDetails ");
      _commonDetails.manage(userdetails.toJson());
    }
  }

  // void clearUserAndSessionDetails(userdetails, sessionDetails) async {
  //   UserSecureStorageService _userSecureStorage = UserSecureStorageService();
  //   HttpClient _httpClient = getIt<HttpClient>();
  // await  _httpClient.postOthers(
  //     "$other?message=${userDetails} __${_userSecureStorage.getRefreshToken()} -----Clear user and Session details");
  // await  _secureStorage.deleteAll("clearUserAndSessionDetails");
  // }

  // Method to handle user logout
  void logout() async {
    try {
      state = LoginState.loggedOut();
    } catch (exception) {
      state = LoginState.error(exception.toString() as Exception, user: null);
    }
  }
}
