import 'dart:developer';
import 'dart:io';
import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/data/models/app_version_response_model.dart';
import 'package:research_mantra_official/data/models/common_api_response.dart';
import 'package:research_mantra_official/data/models/user.dart';
import 'package:research_mantra_official/data/models/user_personal_details_api_response_model.dart';
import 'package:research_mantra_official/data/network/http_client.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IUser_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/services/secure_storage.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';

import '../models/user_login_response_model.dart';

//User repository Implementation
class UserRepository implements IUserRepository {
  final HttpClient _httpClient = getIt<HttpClient>();
  final SecureStorage _secureStorage = getIt<SecureStorage>();
  UserSecureStorageService userSecureStorage = UserSecureStorageService();

  @override
  Future<UserLoginResponseModel?> doLogin(
      String mobileNumber, String countryCode) async {
    try {
      // Send a GET request to the login API endpoint

      final commonResponse = await _httpClient
          .get('$login?mobileNumber=$mobileNumber&countryCode=$countryCode');

      // Parse the response into a UserLoginResponseModel object
      final result = UserLoginResponseModel.fromJson(commonResponse);
      return result;
    } catch (error) {
      await _secureStorage.deleteAll("Do login - userDeatils");

      // Handle any errors that occur during the login API request
      log('Error during login API request: $error');
      return null; // or return an indication of error
    }
  }

  @override
  Future<dynamic> otpLoginVerificationAndGetSubscription(
      String publicKey,
      String enteredOtp,
      String? firebaseFcmToken,
      String deviceInfo,
      String version) async {
    final body = {
      "mobileUserKey": publicKey,
      "firebaseFcmToken": firebaseFcmToken,
      "otp": enteredOtp,
      "deviceType": deviceInfo,
      "version": version
    };
    try {
      // Send the HTTP POST request asynchronously and wait for the response
      final commonResponse = await _httpClient.post(otpVerification, body);
      final responsModel = {
        "message": commonResponse.message,
        "data": null,
        "statusCode": commonResponse.statusCode
      };

      // Check if the response status code is 200 (OK)
      if (commonResponse.statusCode == 200) {
        // Parse the response body into an OtpVerificationResponseModel
        final apiresponseData =
            OtpVerificationResponseModel.fromJson(commonResponse.data);

        responsModel['data'] = apiresponseData;

        return responsModel;
      } else {
        return null;
      }
    } catch (e) {
      // Handle exceptions that occur during OTP verification
      log("Exception during OTP verification: $e");

      return null;
    }
  }

  @override
  Future<User> getUser() async {
    // final response = await _httpClient.get(userRoute);
    // User user = User.fromJson(jsonDecode(response));
    User user = User("John", "john@doe.com", "", "", "", "");
    return user;
  }

  @override
  Future<void> logout() async {
    await _secureStorage.deleteAll("log out  user reposito override");
  }

  @override
  Future<UserPersonalDetailsModel?> getUserPersonalDetails(
      String mobileUserPublicKey) async {
    try {
      final response = await _httpClient
          .get("$getUserDetails?mobileUserKey=$mobileUserPublicKey");
      if (response.statusCode == 200) {
        final UserPersonalDetailsModel userDetails =
            UserPersonalDetailsModel.fromJson(response.data);
        return userDetails;
      }
    } catch (error) {
      throw Exception(error);
    }
    return null;
  }

  @override
  Future<CommonHelperResponseModel> deleteUserProfileImage(
      String mobileUserPublicKey) async {
    try {
      final commonResponse = await _httpClient
          .delete("$deleteProfileImage?publickey=$mobileUserPublicKey");

      // Parse the response into UserDetailsApiResponseModel object.
      final result = CommonHelperResponseModel.fromJson(commonResponse);

      return result;
    } catch (error) {
      throw Exception(error);
    }
  }

  // This method is responsible for managing user personal details.
// It takes in various parameters such as user's public key, full name, email, etc.
  @override
  Future<CommonHelperResponseModel?> manageUserPersonalDetails(
    String mobileUserPublicKey,
    String fullName,
    String emailId,
    String mobileNumber,
    String city,
    String gender,
    String dateOfBirth,
    File? image,
  ) async {
    try {
      // Prepare the request body with the provided parameters.
      Map<String, String> body = {
        "PublicKey": mobileUserPublicKey,
        "FullName": fullName,
        "EmailId": emailId,
        "Mobile": mobileNumber,
        "City": city,
        "Gender": gender,
        "Dob": dateOfBirth,
      };

      // Send the HTTP POST request with multipart form data.
      final commonResponse = await _httpClient.postWithMultiPart(
          manageUserDetails, body, image, "ProfileImage");

      // Parse the response into UserDetailsApiResponseModel object.
      final result = CommonHelperResponseModel.fromJson(commonResponse);

      // Return the result.
      return result;
    } catch (error) {
      // If an error occurs during the process, throw an exception.
      throw Exception(error);
    }
  }

  @override
  Future<CommonHelperResponseModel?> manageLogoutApi(
      String mobileUserPublicKey, String fcmToken) async {
    try {
      final Map<String, String> body = {
        "mobileUserKey": mobileUserPublicKey,
        // "fcmToken": fcmToken
      };

      final response = await _httpClient.post(logoutApi, body);

      final result = CommonHelperResponseModel.fromJson(response);
      return result;
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  /// Method to get All the delete account statement
  @override
  Future<List<String>> getDeleteStatements() async {
    try {
      final response = await _httpClient.get(deleteAccountStatementApi);
      if (response.statusCode == 200) {
        final responseData = response.data;
        // Ensure responseData is a List and map the items to String
        final List<String> getDeleteStatements = (responseData as List<dynamic>)
            .map((item) => item.toString())
            .toList();

        return getDeleteStatements;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  @override
  Future<CommonHelperResponseModel> deleteAccount(
      String mobileUserKey, String reason) async {
    try {
      final body = {"mobileUserKey": mobileUserKey, "reason": reason};
      final response = await _httpClient.post(accountDeleteApi, body);
      // Parse the response into UserDetailsApiResponseModel object.
      final result = CommonHelperResponseModel.fromJson(response);

      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<AppVersionResponseModel> getApiVersion(
      String deviceType, String versionName) async {
    try {
      final response = await _httpClient.get(
        "$getApiVersionV2Api?deviceType=$deviceType&version=$versionName",
      );

      if (response.statusCode == 200 && response.data != null) {
        return AppVersionResponseModel.fromJson(response.data);
      } else {
        throw Exception(
            "Failed to fetch API version. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching API version: $e");
      throw Exception("Unable to get API version");
    }
  }
}
