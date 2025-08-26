import 'package:intl/intl.dart';
import 'package:research_mantra_official/data/models/common_api_response.dart';
import 'package:research_mantra_official/data/models/user_personal_details_api_response_model.dart';

class UserLoginResponseModel {
  final String result;
  final String message;
  final UserData userData;

  UserLoginResponseModel({
    required this.result,
    required this.message,
    required this.userData,
  });

  factory UserLoginResponseModel.fromJson(CommonApiResponse json) {
    return UserLoginResponseModel(
      result: json.data["result"],
      message: json.message,
      userData: UserData.fromJson(json.data),
    );
  }
}

class UserData {
  String otp;
  String publicKey;
  String fullName;
  String emailId;
  String? mobileNumber;
  String? dob;
  String? city;
  String? profileImage;
  final String oneTimePassword;
  String? firebaseFcmToken;
  bool isExistingUser;
  String? jwtToken;
  String gender;
  bool? isFreeOpted;
  String? accessToken;
  String? refreshToken;

  UserData(
      {required this.otp,
      this.mobileNumber,
      this.dob,
      this.city,
      required this.gender,
      required this.publicKey,
      required this.oneTimePassword,
      required this.profileImage,
      required this.firebaseFcmToken,
      required this.fullName,
      required this.emailId,
      required this.isExistingUser,
      this.jwtToken,
      this.isFreeOpted,
      this.accessToken,
      this.refreshToken});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      gender: json['gender'] ?? '',
      otp: json['otp'],
      publicKey: json['publicKey'],
      mobileNumber: json['mobileNumber'],
      dob: json['dob'],
      city: json['city'],
      oneTimePassword: json['oneTimePassword'],
      profileImage: json['profileImage'] ?? '',
      firebaseFcmToken: json['firebaseFcmToken'] ?? "",
      fullName: json['fullName'],
      emailId: json['emailId'],
      isExistingUser: json['isExistingUser'] ?? false,
      jwtToken: json['jwtToken'] ?? "",
      isFreeOpted: json['isFreeOpted'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }

  // Custom copyWith method
  UserData copyWith({
    String? otp,
    String? publicKey,
    String? fullName,
    String? emailId,
    String? mobileNumber,
    String? dob,
    String? city,
    String? profileImage,
    String? oneTimePassword,
    String? firebaseFcmToken,
    bool? isExistingUser,
    String? jwtToken,
    String? gender,
    bool? isFreeOpted,
    String? accessToken,
    String? refreshToken,
  }) {
    return UserData(
      otp: otp ?? this.otp,
      publicKey: publicKey ?? this.publicKey,
      fullName: fullName ?? this.fullName,
      emailId: emailId ?? this.emailId,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      dob: dob ?? this.dob,
      city: city ?? this.city,
      profileImage: profileImage ?? this.profileImage,
      oneTimePassword: oneTimePassword ?? this.oneTimePassword,
      firebaseFcmToken: firebaseFcmToken ?? this.firebaseFcmToken,
      isExistingUser: isExistingUser ?? this.isExistingUser,
      jwtToken: jwtToken ?? this.jwtToken,
      gender: gender ?? this.gender,
      isFreeOpted: isFreeOpted ?? this.isFreeOpted,
      refreshToken: refreshToken ?? this.refreshToken,
      accessToken: accessToken ?? this.accessToken,
    );
  }

  // Method to update provided fields of UserData from UserPersonalDetailsModel
  void updateFromPersonalDetails(UserPersonalDetailsModel? personalDetails) {
    // Update only the fields that have non-null values in the provided personalDetails object
    if (personalDetails == null) return;

    // Create a new UserData object with updated values
    UserData updatedData = copyWith(
        fullName: personalDetails.fullName,
        emailId: personalDetails.emailId,
        mobileNumber: personalDetails.mobile,
        dob: DateFormat('yyyy-MM-dd').format(personalDetails.dob),
        city: personalDetails.city,
        publicKey: personalDetails.publicKey,
        profileImage: personalDetails.profileImage,
        gender: personalDetails.gender);

    // Retain values of specific fields that are not part of UserPersonalDetailsModel
    // These fields will not be updated or removed
    updatedData.isExistingUser = isExistingUser;
    updatedData.firebaseFcmToken = firebaseFcmToken;
    updatedData.otp = otp;

    updatedData.gender = gender;

    // Update the current UserData object with the updatedData
    fullName = updatedData.fullName;
    emailId = updatedData.emailId;
    mobileNumber = updatedData.mobileNumber;
    dob = updatedData.dob;
    city = updatedData.city;
    publicKey = updatedData.publicKey;
    profileImage = updatedData.profileImage;

    gender = updatedData.gender;

  }

// void updateIsFreeOpted(bool  isFreeOptedData){

//   UserData isFreeOpted=copyWith(isFreeOpted:isFreeOptedData);

//   isFreeOpted.city=city;
//   isFreeOpted.dob=dob;

// }

  Map<String, dynamic> toJson() {
    return {
      'otp': otp,
      'publicKey': publicKey,
      'mobileNumber': mobileNumber,
      'dob': dob,
      'city': city,
      'oneTimePassword': oneTimePassword,
      'profileImage': profileImage,
      'firebaseFcmToken': firebaseFcmToken,
      'fullName': fullName,
      'emailId': emailId,
      'isExistingUser': isExistingUser,
      'jwtToken': jwtToken,
      'gender': gender,
      'isFreeOpted': isFreeOpted,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}

class OtpVerificationResponseModel {
  final bool isExistingUser;
  final String gender;
  final String? accessToken;
  final String? refreshToken;
  OtpVerificationResponseModel(
      {required this.isExistingUser,
      required this.gender,
      this.accessToken,
      this.refreshToken});

  // Convert the model into a JSON-encodable format
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'gender': gender,
      'isExistingUser': isExistingUser,
    };
  }

  // Create a factory method to create a model from JSON data
  factory OtpVerificationResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpVerificationResponseModel(
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
        isExistingUser: json['isExistingUser'],
        gender: json['gender'] ?? '');
  }
}
