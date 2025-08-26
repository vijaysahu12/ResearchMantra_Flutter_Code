import 'package:intl/intl.dart';

class UserPersonalDetailsModel {
  final String? fullName;
  final String? emailId;
  final String? mobile;
  final String? gender;
  final String? city;
  final DateTime dob;
  final String publicKey;
  final String? profileImage;

  const UserPersonalDetailsModel(
      {this.fullName,
      this.emailId,
      this.mobile,
      this.gender,
      this.city,
      required this.dob,
      required this.publicKey,
      this.profileImage});

  UserPersonalDetailsModel copyWith({
    String? fullName,
    String? emailId,
    String? mobile,
    String? gender,
    String? city,
    DateTime? dob,
    String? publicKey,
    String? profileImage,
  }) {
    return UserPersonalDetailsModel(
      fullName: fullName ?? this.fullName,
      emailId: emailId ?? this.emailId,
      mobile: mobile ?? this.mobile,
      gender: gender ?? this.gender,
      city: city ?? this.city,
      dob: dob ?? this.dob,
      publicKey: publicKey ?? this.publicKey,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  static UserPersonalDetailsModel fromJson(Map<String, dynamic> json) {
    String customDateFormat = "yyyy-MM-dd"; // Your custom format
    DateTime parsedDate =
        DateFormat(customDateFormat).parse(json['dob'] ?? "1990-01-01");

    return UserPersonalDetailsModel(
        fullName: json['fullName'] ?? '',
        emailId: json['emailId'] ?? '',
        mobile: json['mobile'] ?? '',
        gender: json['gender'] ?? '',
        city: json['city'] ?? '',
        dob: parsedDate,
        publicKey: json['publicKey'] ?? '',
        profileImage:
            json['profileImage'] == null ? "" : json['profileImage'] ?? "");
  }
}
