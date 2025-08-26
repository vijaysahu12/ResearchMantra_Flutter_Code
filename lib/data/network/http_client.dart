import 'dart:async';
import 'dart:convert';

import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/data/models/common_api_response.dart';
import 'package:http/http.dart' as http;
import 'package:research_mantra_official/data/models/user_login_response_model.dart';
import 'package:research_mantra_official/data/network/network_exceptions.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/services/check_connectivity.dart';
import 'package:research_mantra_official/services/hive_service.dart';
import 'package:research_mantra_official/services/secure_storage.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';

import 'package:research_mantra_official/utils/utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

const int expirationBufferInDays = 5;

class HttpClient {
  final UserSecureStorageService _commonDetails = UserSecureStorageService();

  //Get Method
  Future<CommonApiResponse> get(String url) async {
    CommonApiResponse responseJson;
    try {
      // Get all user details from storage
      Map<String, dynamic> userDetails = await _commonDetails.getUserDetails();
      Response? response;
      String? accessToken = await userDetails['accessToken'];
      bool isConnected =
          await CheckInternetConnection().checkInternetConnection();
      if (isConnected) {
        String? refreshTokenvalue = await _commonDetails.getRefreshToken();
        postOthers(
            "$other?message=$userDetails __ Access Token: $accessToken  Refresh Token :${refreshTokenvalue ?? "Null valuer"}    ----- refrsh and access value before get url $url");
      }
      response = await http.get(Uri.parse(url), headers: {
        HttpHeaders.authorizationHeader: "Bearer $accessToken",
      });

      if (response.statusCode == 401) {
        print(
            "_____________________________________________TOKEN EXPIRED 401 _________________________________");

        CommonApiResponse? commonResponse = await _handleRefershToken();

        if (commonResponse != null && commonResponse.statusCode == 200) {
          userDetails['refreshToken'] = commonResponse.data["refreshToken"];

          userDetails['accessToken'] = commonResponse.data['accessToken'];
          final userData = UserData.fromJson(userDetails);

          await _commonDetails.manage(userData.toJson());
          accessToken = commonResponse.data['accessToken'];

          response = await http.get(Uri.parse(url), headers: {
            HttpHeaders.authorizationHeader:
                "Bearer ${commonResponse.data['accessToken']}",
          });
        } else {
          bool isConnected =
              await CheckInternetConnection().checkInternetConnection();
          if (isConnected) {
            postOthers(
                "$other?message=$userDetails __$commonResponse    -----Get $url");
          }
        }
      }
  
      responseJson = CommonApiResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      return CommonApiResponse(statusCode: 200, message: "", data: []);
    }
    return responseJson;
  }

  // Handle token expiration
  Future<CommonApiResponse?> _handleRefershToken() async {
    // Read the refresh token from secure storage
    // Get all user details from storage
    CommonApiResponse? apiResponse;
    try {
      Map<String, dynamic> userDetails = await _commonDetails.getUserDetails();

      String? refreshTokenData = await _commonDetails.getRefreshToken();

      final publicKey = userDetails['publicKey'];
      final mobileNumber = userDetails['mobileNumber'];

      if (refreshTokenData != null && refreshTokenData != "") {
        // Attempt to refresh the access
        //Funtoken using the refresh token

        final refreshResponse = await _refreshToken(
          refreshTokenData,
          publicKey,
        );
        final resbody = jsonDecode(refreshResponse.body);

        if (resbody['statusCode'] == 401) {
          bool isConnected =
              await CheckInternetConnection().checkInternetConnection();
          if (isConnected) {
            postOthers(
                "$other?message=MobileNumber: $mobileNumber __ Refresh Token:-$refreshTokenData | UserDetails: $userDetails | Ressmessage for 401: ${resbody["message"] ?? "no message field received from api"}---_handleRefershToken()");
          }

          _clearTokens();
        } else if (resbody['statusCode'] == 200) {
          Map<String, dynamic> body = jsonDecode(refreshResponse.body);
          apiResponse = CommonApiResponse.fromJson(body);
        }
      } else {
        print("refreshToken is null");

        bool isConnected =
            await CheckInternetConnection().checkInternetConnection();
        if (isConnected) {
          postOthers(
              "$other?message=MobileNumber: $mobileNumber __ Refresh Token:-$refreshTokenData  UserDetails: $userDetails   --refrsh token null");
        }
        _clearTokens();
      }
    } on SocketException {
    } catch (e) {
      print("_handleRefershToken() method got exception");
      bool isConnected =
          await CheckInternetConnection().checkInternetConnection();
      if (isConnected) {
        postOthers("$other?message=$e ---_handleRefershToken() catch error");
      }
    }

    return apiResponse;
  }

//Post Method
  Future<CommonApiResponse> post(String url, Map? body) async {
    CommonApiResponse responseJson;
    // Get all user details from storage
    Map<String, dynamic> userDetails = await _commonDetails.getUserDetails();

    try {
      // Get all user details from storage

      String? accessToken = await userDetails['accessToken'];
      Response? response;

      response = await http.post(Uri.parse(url),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer $accessToken",
          },
          body: json.encode(body));

      if (response.statusCode == 401) {
        print(
            "_____________________________________________TOKEN EXPIRED 401 _________________________________");
        CommonApiResponse? commonResponse = await _handleRefershToken();
        if (commonResponse != null && commonResponse.statusCode == 200) {
          userDetails['refreshToken'] = commonResponse.data["refreshToken"] ??
              userDetails['refreshToken'];

          userDetails['accessToken'] = commonResponse.data['accessToken'];
          final userData = UserData.fromJson(userDetails);
          await _commonDetails.manage(userData.toJson());
          accessToken = commonResponse.data['accessToken'];

          response = await http.post(Uri.parse(url),
              headers: {
                HttpHeaders.contentTypeHeader: "application/json",
                HttpHeaders.authorizationHeader:
                    "Bearer ${commonResponse.data['accessToken']}",
              },
              body: json.encode(body));
          return _returnResponse(response);
        } else {
          bool isConnected =
              await CheckInternetConnection().checkInternetConnection();
          if (isConnected) {
            postOthers("$other?message=$userDetails -----post Method");
          }
        }
      }

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

//Post Method
  Future<int> postOthers(String url) async {
    int? responseJson;
    // Get all user details from storage
    // Map<String, dynamic> userDetails = await _commonDetails.getUserDetails();

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          // HttpHeaders.contentTypeHeader: "text/plain; charset=utf-8",
          // HttpHeaders.authorizationHeader: "Bearer $jsonWebToken",
        },
      );

      responseJson = response.statusCode;
    } on SocketException {
      print("SocketException");
    } catch (e) {
      // throw Exception('Failed to send post request');
      print("exception $e");
    }
    return responseJson ?? 0;
  }

  // Sends a POST request with optional image.
  Future<CommonApiResponse> postWithMultiPart(
      String url, Map<String, String> body, File? image, imageType) async {
    // Get all user details from storage
    Map<String, dynamic> userDetails = await _commonDetails.getUserDetails();
    try {
      String? accessToken = await userDetails['accessToken'];

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(url),
      )
        ..headers['Content-Type'] = 'multipart/form-data'
        ..headers['Authorization'] = 'Bearer $accessToken'
        ..fields.addAll(body); // Adds form fields.

      // Adds image to request if provided.
      if (image != null && await image.exists()) {
        request.files.add(await _getImageAsMultipartFile(image, imageType));
      }
      // Sends the request and retrieves response.
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 401) {
        CommonApiResponse? commonResponse = await _handleRefershToken();
        if (commonResponse != null && commonResponse.statusCode == 200) {
          userDetails['refreshToken'] = commonResponse.data["refreshToken"];

          userDetails['accessToken'] = commonResponse.data['accessToken'];
          final userData = UserData.fromJson(userDetails);
          await _commonDetails.manage(userData.toJson());
          accessToken = commonResponse.data['accessToken'];
          return postWithMultiPart(url, body, image, imageType);
        } else {
          bool isConnected =
              await CheckInternetConnection().checkInternetConnection();
          if (isConnected) {
            postOthers(
                "$other?message=$userDetails -----post With Multipart Images Method");
          }
        }
      }

      // Processes and returns the response.
      return _returnResponse(response);
    } catch (e) {
      bool isConnected =
          await CheckInternetConnection().checkInternetConnection();
      if (isConnected) {
        postOthers(
            "$other?message=$userDetails $e -----post With Multipart Images Exception");
      }
      // Throws an exception if request fails.
      throw Exception('Failed to send multipart request');
    }
  }

//send post with multiple images
  Future<CommonApiResponse> postWithMultiPartWithMultipleImages(
      String url,
      Map<String, String> body,
      List<File>? images,
      imageType,
      List<String> aspectRatios) async {
    Map<String, dynamic> userDetails = await _commonDetails.getUserDetails();
    try {
      String? accessToken = await userDetails['accessToken'];

      // Prepares a multipart request.
      var request = http.MultipartRequest('POST', Uri.parse(url))
        ..headers['Content-Type'] = 'multipart/form-data'
        ..headers['Authorization'] = 'Bearer $accessToken'
        ..fields.addAll(body); // Adds form fields.

      // Add aspect ratios individually only
      if (aspectRatios.isNotEmpty) {
        for (int i = 0; i < aspectRatios.length; i++) {
          request.fields['AspectRatios[$i]'] = aspectRatios[i];
        }
      }

      // Adds images to request if provided.
      if (images != null) {
        for (var image in images) {
          if (await image.exists()) {
            request.files.add(await _getImageAsMultipartFile(image, imageType));
          }
        }
      }

      // Sends the request and retrieves response.
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 401) {
        print(
            "_____________________________________________TOKEN EXPIRED 401 _________________________________");
        CommonApiResponse? commonResponse = await _handleRefershToken();
        if (commonResponse != null && commonResponse.statusCode == 200) {
          userDetails['refreshToken'] = commonResponse.data["refreshToken"];
          userDetails['accessToken'] = commonResponse.data['accessToken'];
          final userData = UserData.fromJson(userDetails);
          await _commonDetails.manage(userData.toJson());
          accessToken = commonResponse.data['accessToken'];

          return postWithMultiPartWithMultipleImages(
              url, body, images, imageType, aspectRatios);
        } else {
          bool isConnected =
              await CheckInternetConnection().checkInternetConnection();
          if (isConnected) {
            postOthers(
                "$other?message=$userDetails -----postWithMultiPartWithMultipleImages Images");
          }
        }
      }

      // Processes and returns the response.
      return _returnResponse(response);
    } catch (e) {
      // Throws an exception if request fails.
      throw Exception('Failed to send multipart request');
    }
  }

// Converts an image file to multipart format.
  Future<http.MultipartFile> _getImageAsMultipartFile(
      File image, imageType) async {
    // Checks if the image exists and converts it to multipart.
    if (await image.exists()) {
      return http.MultipartFile.fromPath(
        imageType, // Field name for the image.
        image.path, // Path of the image.
      );
    } else {
      // Throws an error if the image does not exist.
      throw Exception('Image file does not exist');
    }
  }

  //Delete Method
  Future<CommonApiResponse> delete(String url) async {
    CommonApiResponse responseJson;
    // Get all user details from storage
    Map<String, dynamic> userDetails = await _commonDetails.getUserDetails();
    try {
      String? accessToken = await userDetails['accessToken'];

      var response = await http.delete(Uri.parse(url), headers: {
        HttpHeaders.authorizationHeader: "Bearer $accessToken",
      });

      if (response.statusCode == 401) {
        print(
            "_____________________________________________TOKEN EXPIRED 401 _________________________________");
        CommonApiResponse? commonResponse = await _handleRefershToken();

        if (commonResponse != null && commonResponse.statusCode == 200) {
          userDetails['refreshToken'] = commonResponse.data["refreshToken"] ??
              userDetails['refreshToken'];

          userDetails['accessToken'] = commonResponse.data['accessToken'];

          final userData = UserData.fromJson(userDetails);
          await _commonDetails.manage(userData.toJson());
          accessToken = commonResponse.data['accessToken'];
          return delete(url);
        } else {
          bool isConnected =
              await CheckInternetConnection().checkInternetConnection();
          if (isConnected) {
            postOthers("$other?message=$userDetails -----delete");
          }
        }
      }
      responseJson = CommonApiResponse.fromJson(jsonDecode(response.body));
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  // This method is responsible for converting an HTTP response to a CommonApiResponse object.
  CommonApiResponse _returnResponse(http.Response response) {
    try {
      // Check if the response status code indicates success.

      if (response.statusCode == 200) {
        // Parse the response body using JSON decoding.
        Map<String, dynamic> responseBody = jsonDecode(response.body);

        // Convert the decoded JSON into a CommonApiResponse object.
        CommonApiResponse apiResponse =
            CommonApiResponse.fromJson(responseBody);

        // Return the resulting CommonApiResponse object.
        return apiResponse;
      } else {
        // If the response status code indicates failure, throw an exception with the status code and message.
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      // If an error occurs during the process, throw an exception.
      throw Exception('Error parsing response: $error');
    }
  }

  // Refresh the access token using the refresh token
  Future<http.Response> _refreshToken(
      String refreshTokenData, String publicKey) async {
    try {
      bool isIOS = isGetIOSPlatform();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      final uri = Uri.parse(refreshToken);
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'refreshToken': refreshTokenData,
          'deviceType': isIOS ? 'IOS' : 'Android',
          'version': packageInfo.version,
          'mobileUserKey': publicKey
        }),
      );

      return response;
    } catch (e) {
      // Catch any network errors during token refresh
      print('Error during token refresh request: $e');

      throw Exception('Network error during token refresh');
    }
  }

  Future<void> _clearTokens() async {
    final SecureStorage secureStorage = getIt<SecureStorage>();

    final HiveServiceStorage hiveServiceStorage = HiveServiceStorage();

    // Define a global provider container
    final providerContainer = ProviderContainer();

    // Define a global provider container

    final jwtRefreshTokenData = await _commonDetails.getRefreshToken();
    bool isConnected =
        await CheckInternetConnection().checkInternetConnection();
    if (isConnected) {
      postOthers(
          "$other?message=$userDetails __$jwtRefreshTokenData -----_clearToken");
    }
    secureStorage.deleteAll("clear Tokens");

    hiveServiceStorage.deleteAllHiveData();
    providerContainer.dispose();

    navigatorKey.currentState?.pushNamedAndRemoveUntil(login, (route) => false);
  }

  bool isTokenExpiringSoon(DateTime expirationDate) {
    DateTime currentDate = DateTime.now();
    Duration difference = expirationDate.difference(currentDate);

    return difference.inDays <=
        expirationBufferInDays; // Expiring within the buffer
  }
}
