import 'dart:convert';

class User {
  final String fullName;
  final String email;
  final String publicKey;
  String? jwtToken;
  String? refreshToken;
  String? accessToken;
  User(this.fullName, this.email, this.publicKey, this.jwtToken,
      this.accessToken, this.refreshToken);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json['fullName'], json['email'], json['publicKey'],
        json['jwtToken'], json['refreshToken'], json['accessToken']);
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'publicKey': publicKey,
      'jwtToken': jwtToken,
      'refreshToken': refreshToken,
      'accessToken': accessToken,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      map['fullName'] ?? '',
      map['email'] ?? '',
      map['publicKey'] ?? '',
      map['jwtToken'] ?? '',
      map['refreshToken'] ?? '',
      map['accessToken'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'User(fullName: $fullName,  email: $email, publicKey: $publicKey, jwtToken: $jwtToken ,refreshToken :$refreshToken, accessToken:$accessToken  )';
  }
}
