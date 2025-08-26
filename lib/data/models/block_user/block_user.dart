class GetBlocUserResponseModel {
  final String id;
  final String fullName;
  final String? profileImage;
  final String? gender;
  const GetBlocUserResponseModel(
      {required this.id,
      required this.fullName,
      required this.profileImage,
      required this.gender});

 GetBlocUserResponseModel copyWith(
      {
        String? id,
      String? fullName,
      String? profileImage,
      String? gender,
   }) {
    return GetBlocUserResponseModel(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        profileImage: profileImage ?? this.profileImage,
        gender: gender ?? this.gender
      );
  }


  static GetBlocUserResponseModel fromJson(Map<String, dynamic> json) {
    return GetBlocUserResponseModel(
        id: json['id'] ?? '',
        fullName: json['fullName'] ?? '',
        profileImage: json['profileImage'] ?? '',
        gender: json['gender'] ?? '');
  }
}
