import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/constants/storage.dart';
import 'package:research_mantra_official/data/network/http_client.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/services/check_connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';

HttpClient httpClient = getIt<HttpClient>();

//Secure Storage
class SecureStorage {
  final _storage = const FlutterSecureStorage();
  final options = IOSOptions(accessibility: KeychainAccessibility.first_unlock);

  Future<void> write(String key, dynamic value) async {
    await _storage.write(key: key, value: value, iOptions: options);
  }

  Future<String?> read(String key) async {
    String? value = await _storage.read(key: key, iOptions: options);

    return value;
  }

  void delete(String key) async {
    bool isConnected =
        await CheckInternetConnection().checkInternetConnection();
    if (isConnected) {
      await httpClient.postOthers(
          "$other?message=${await _storage.read(key: refreshTokenSecureStorage, iOptions: options)} __${await _storage.read(key: loggedInUserDetails, iOptions: options)}  , $key ----delete key SEcure Storage");
    }
    await _storage.delete(key: key, iOptions: options);
  }

  Future<void> deleteAll(String reason) async {
    bool isConnected =
        await CheckInternetConnection().checkInternetConnection();
    if (isConnected) {
      await httpClient.postOthers(
          "$other?message=${await _storage.read(key: refreshTokenSecureStorage, iOptions: options)} __${await _storage.read(key: loggedInUserDetails, iOptions: options)}    $reason   ----delete ALl SEcure Storage");
    }

    await _storage.deleteAll(iOptions: options);
//Todo:
    String? refreshtTokenvalue =
        await _storage.read(key: refreshTokenSecureStorage, iOptions: options);
    print("refreshtTokenvalue  Before $refreshtTokenvalue");
    if (refreshtTokenvalue != null || refreshtTokenvalue != "") {
      await _storage.write(
          key: refreshTokenSecureStorage, value: "", iOptions: options);
      await _storage.write(
          key: loggedInUserDetails, value: "", iOptions: options);
    }
    print("refreshtTokenvalue  After $refreshtTokenvalue");
  }
}

//SharedPref
class SharedPref {
  // Private constructor
  SharedPref._privateConstructor();

  // The single instance of the class
  static final SharedPref _instance = SharedPref._privateConstructor();

  // Getter for the instance
  static SharedPref get instance => _instance;

  // Factory constructor to allow instantiation, but return the same instance
  factory SharedPref() {
    return _instance;
  }

  late SharedPreferences _prefs;
  Future<SharedPreferences> init() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }

  read(String key) async {
    final prefs = await init();
    var result = prefs.getString(key);
    return result;
  }

  Future<void> setBool(String key, bool value) async {
    final prefs = await init();
    prefs.setBool(key, value);
  }

  Future<bool> getBool(String key) async {
    final prefs = await init();
    return prefs.getBool(key) ?? false;
  }

  save(String key, value) async {
    final prefs = await init();
    prefs.setString(key, json.encode(value));
  }

  saveCount(String key, value) async {
    final prefs = await init();
    prefs.setInt(key, value);
  }

  reload() async {
    final prefs = await init();
    prefs.reload();
  }

  getCount(String key) async {
    final prefs = await init();
    return prefs.getInt(key);
  }

  remove(String key, String reason) async {
    final prefs = await init();

    prefs.remove(key);
  }

  clearAll(String reason) async {
    final prefs = await init();

    prefs.clear();
  }

  Future<List<String>?> readList(String key) async {
    final pref = await init();
    final jsonString = pref.getString(key);
    if (jsonString != null) {
      final List<dynamic> decodeList = json.decode(jsonString);
      return decodeList.cast<String>();
    }
    return null;
  }

  Future<void> saveList(String key, List<String> value) async {
    final pref = await init();
    pref.setString(key, json.encode(value));
  }

//  /// Checks if the Firebase promo value has changed since the last stored value.
  Future<bool> hasFirebaseValueChanged(bool newValue) async {
    final pref = await init();

    final lastValue = pref.getBool(lastFirebasePromoValue);

    if (lastValue == null) {
      await pref.setBool(lastFirebasePromoValue, false);

      return false;
    }

    if (lastValue != newValue) {
      await pref.setBool(lastFirebasePromoValue, newValue);
      return true;
    }
    print("Firebase value has not changed.");

    return false;
  }
}
