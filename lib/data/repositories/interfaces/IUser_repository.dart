import 'dart:io';

import 'package:research_mantra_official/data/models/app_version_response_model.dart';
import 'package:research_mantra_official/data/models/common_api_response.dart';

import 'package:research_mantra_official/data/models/user.dart';
import 'package:research_mantra_official/data/models/user_login_response_model.dart';
import 'package:research_mantra_official/data/models/user_personal_details_api_response_model.dart';

//InterFace for user repository
abstract class IUserRepository {
  /// Performs user login
  Future<UserLoginResponseModel?> doLogin(
      String mobileNumber, String countryCode);
  //Todo: Currently We are not using
  Future<User> getUser();

  // logout this user
  Future<void> logout();

  //Perform Otp Login verfication
  Future<dynamic> otpLoginVerificationAndGetSubscription(
      String enteredOtp,
      String publicKey,
      String? firebaseFcmToken,
      String deviceInfo,
      String version);
//Getting User personal details
  Future<UserPersonalDetailsModel?> getUserPersonalDetails(
      String mobileUserPublicKey);

  //Getting User personal details
  Future<CommonHelperResponseModel> deleteUserProfileImage(
      String mobileUserPublicKey);

  //Manage user personal Details
  Future<CommonHelperResponseModel?> manageUserPersonalDetails(
    String mobileUserPublicKey,
    String fullName,
    String emailId,
    String mobileNumber,
    String city,
    String gender,
    String dateOfBirth,
    File? image,
  );

  Future<CommonHelperResponseModel?> manageLogoutApi(
      String mobileUserPublicKey, String mobileUserFcmToken);

  //Manage newVersion
  // Future<NewVersionResponseModel?> getNewVersionDetails(String newVersion);//Todo: need to remove
  Future<AppVersionResponseModel> getApiVersion(
      String deviceType, String versionName);

//Get All the delete account statement
  Future<List<String>> getDeleteStatements();
  Future<CommonHelperResponseModel> deleteAccount(
      String mobileUserKey, String reason);
}
