import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/login/login_provider.dart';
import 'package:research_mantra_official/providers/userpersonaldetails/user_personal_details_provider.dart';
import 'package:research_mantra_official/services/check_connectivity.dart';
import 'package:research_mantra_official/services/hive_service.dart';
import 'package:research_mantra_official/ui/components/dynamic_promo_card/service/promo_manager.dart';
import 'package:research_mantra_official/ui/components/restart_widget.dart';
import 'package:research_mantra_official/ui/router/app_routes.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';
import 'package:synchronized/synchronized.dart';
import '../constants/storage.dart';
import 'secure_storage.dart';

final Lock authLock = Lock();
bool isLoggingout = false;

class UserSecureStorageService {
  final SecureStorage _secureStorage = getIt<SecureStorage>();
  final SharedPref _pref = SharedPref();
  final HiveServiceStorage _hiveServiceStorage = HiveServiceStorage();
  // Define a global provider container
  final providerContainer = ProviderContainer();

  // method for getPublicKey from secureStorage
  Future<String> getPublicKey() async {
    final String? userJson = await _secureStorage.read(loggedInUserDetails);

    if (userJson != null && userJson.isNotEmpty) {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      final String publicKey = userMap['publicKey'];
      return publicKey;
    }
    return "";
  }

  Future<Map<String, dynamic>> getUserDetails() async {
    String? userDataJson = await _secureStorage.read(loggedInUserDetails);
    if (userDataJson != null && userDataJson.isNotEmpty) {
      Map<String, dynamic> userData = jsonDecode(userDataJson);
      print("----------token ${userData['refreshToken']}");
      return userData;
    } else {
      return {};
    }
  }

  //Method for get fcm token
  Future<String> getFcmToken() async {
    final String? userFcmToken = await _secureStorage.read(fcmToken);

    if (userFcmToken != null && userFcmToken.isNotEmpty) {
      return userFcmToken;
    }
    return "";
  }

  Future<void> writeFcm(String? value) async {
    await _secureStorage.write(fcmToken, value);
  }

  Future<String?> getSelectedGender() async {
    final String? gender = await _secureStorage.read(userGender);
    return gender;
  }

  Future<bool> manage(Map<String, dynamic> userData) async {
    print("$userData ----user data  secure storage");
    if (userData.isNotEmpty) {
      await _secureStorage.write(loggedInUserDetails, jsonEncode(userData));
    }
    return true;
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    await _secureStorage.write(refreshTokenSecureStorage, refreshToken);

    print("Refresh token saved");
  }

  Future<String?> getRefreshToken() async {
    String? refreshToken;

    refreshToken = await _secureStorage.read(refreshTokenSecureStorage);

    return refreshToken;
  }

  Future<String?> getUserObjectId() async {
    final String? userId = await _secureStorage.read(userObjectId);

    return userId;
  }

  //check silent notification
  Future<Map<String, dynamic>> checkSilentNotificationMessage() async {
    String? getValue = await _secureStorage.read(silentNotificationText);
    if (getValue != null && getValue != "") {
      Map<String, dynamic> getAllTheNotification = jsonDecode(getValue);
      return getAllTheNotification;
    } else {
      return {};
    }
  }

//Function to get communityPostEnabled ////Todo:
  Future<bool> fetchUserActivity() async {
    final dynamic userActivity = await _pref.getBool(communityPostEnabled);
    if (userActivity) {
      return userActivity;
    } else {
      return false;
    }
  }

//Function to get commentsEnabledStatus //Todo:
  Future<bool> checkUserComments() async {
    final dynamic userCommentsActivity =
        await _pref.getBool(commentsEnabledStatus);
    if (userCommentsActivity) {
      return userCommentsActivity;
    } else {
      return false;
    }
  }

  Future<void> clearProfileImage() async {
    await _secureStorage.write("profileImage", null);
  }

  //function for logout
  Future<void> handleLogout(context, WidgetRef ref) async {
    final String mobileUserPublicKey = await getPublicKey();
    final String mobileUserFcmToken = await getFcmToken();
    bool checkConnection =
        await CheckInternetConnection().checkInternetConnection();
    if (checkConnection) {
      try {
        await ref
            .read(getUserPersonalDetailsStateNotifierProvider.notifier)
            .manageLogoutApp(mobileUserPublicKey, mobileUserFcmToken);

        ref.read(loginProvider.notifier).logout();
        //invalidating all the providers
        handleToRemoveAndInvalidate(ref, context);

        // });
      } catch (e) {
        ToastUtils.showToast(somethingWentWrong, "error");
      }
    }
  }

  //function for logout
  Future<void> handleAccountDelete(context, WidgetRef ref, reason) async {
    final String mobileUserPublicKey = await getPublicKey();

    bool checkConnection =
        await CheckInternetConnection().checkInternetConnection();
    if (checkConnection) {
      try {
        // FirebaseNotificationsUtils.deleteInstanceID();

        final response = await ref
            .read(getUserPersonalDetailsStateNotifierProvider.notifier)
            .accountDelete(mobileUserPublicKey, reason);
        if (response) {
          handleToRemoveAndInvalidate(ref, context);
        } else {
          ToastUtils.showToast(somethingWentWrong, "error");
        }
      } catch (e) {
        // print('Error during logout: $e');
        ToastUtils.showToast(noInternetConnectionText, "error");
      }
    }
  }

  //invalidate and remove
  void handleToRemoveAndInvalidate(ref, context) async {
    await authLock.synchronized(() async {
      if (!isLoggingout) {
        return;
      }
      try {
        await _pref.clearAll("handleToRemoveAndInvalidate");
        await _secureStorage.deleteAll("handleToRemoveAndInvalidate1");
        _hiveServiceStorage.deleteAllBoxsHiveData();
        providerContainer.dispose();
        // ref.invalidate(loginProvider);
        // ref.invalidate(productsStateNotifierProvider);
        // ref.invalidate(getBlogPostNotifierProvider);
        // ref.invalidate(getBlogCommentsListStateNotifierProvider);
        // // ref.invalidate(dashBoardProvider);
        // ref.invalidate(notificationsProvider);
        // ref.invalidate(getAllTicketsStateProvider);
        // ref.invalidate(getScannersNotificationStrategiesStateNotifierProvider);
        // ref.invalidate(getScannersStateNotifierProvider);
        PromoManager().tryShowPromo(context, disable: true);
        Navigator.pushNamedAndRemoveUntil(context, login, (route) => false);

        RestartWidget.restartApp(context);
      } catch (e) {
        print("$e ");
      } finally {
        isLoggingout = false;
      }
    });
  }

  Future<List<Map<String, dynamic>>> getTopValues(topValue) async {
    String? getTopValues = await _pref.read(topValue);
    if (getTopValues != null) {
      List<Map<String, dynamic>> userData =
          List<Map<String, dynamic>>.from(jsonDecode(getTopValues));
      return userData;
    } else {
      return [];
    }
  }

  Future<Map<String, List<String>>> getMarketLivePrice() async {
    String? getMarketLivePriceDetails =
        await _pref.read("INDIAN_STOCK_MARKET_PRICES");
    if (getMarketLivePriceDetails != null) {
      Map<String, dynamic> userData = jsonDecode(getMarketLivePriceDetails);
      // Convert values to List<String>
      Map<String, List<String>> parsedData =
          userData.map((key, value) => MapEntry(key, List<String>.from(value)));
      return parsedData;
    } else {
      return {};
    }
  }

  getLatestUpdatedDate(String latestUpdatedValue) async {
    final String? latestUpdatedDate =
        await _secureStorage.read(latestUpdatedValue);

    return latestUpdatedDate;
  }
}
