
import 'package:research_mantra_official/data/models/user_personal_details_api_response_model.dart';

class UserPersonalDetailsState {
  final UserPersonalDetailsModel? userPersonalDetails;

  final bool isLoading;
  final bool isProfileImageDeleted;
  final bool isGenderChange;

  final dynamic error;

  UserPersonalDetailsState(
      {required this.userPersonalDetails,
      required this.error,
      required this.isLoading,
      required this.isGenderChange,
      required this.isProfileImageDeleted});

  // Factory constructor to create initial state
  factory UserPersonalDetailsState.initial() => UserPersonalDetailsState(
      userPersonalDetails: null,
      error: null,
      isLoading: false,
      isGenderChange: false,
      isProfileImageDeleted: false);

  // Factory constructor to create loading state
  factory UserPersonalDetailsState.loading(
          UserPersonalDetailsModel? userPersonalDetails) =>
      UserPersonalDetailsState(
          userPersonalDetails: userPersonalDetails,
          error: null,
          isLoading: true,
          isGenderChange: false,
          isProfileImageDeleted: false);

  // Factory constructor to create success state
  factory UserPersonalDetailsState.success(
          UserPersonalDetailsModel? userPersonalDetails) =>
      UserPersonalDetailsState(
          userPersonalDetails: userPersonalDetails,
          error: null,
          isLoading: false,
          isGenderChange: true,
          isProfileImageDeleted: false);

  // Factory constructor to create state for managing user details
  factory UserPersonalDetailsState.manageUserDetails(
      UserPersonalDetailsModel userPersonalDetails) {
    final updateUserDetails = userPersonalDetails.copyWith(
      gender: userPersonalDetails.gender,
    );
    return UserPersonalDetailsState(
        userPersonalDetails: updateUserDetails,
        error: null,
        isLoading: false,
        isGenderChange: true,
        isProfileImageDeleted: false);
  }

  // Factory constructor to create state for managing user details
  factory UserPersonalDetailsState.afterDeleteProfileImage(
      UserPersonalDetailsModel? userPersonalDetails) {
    final updateUserDetails = userPersonalDetails!.copyWith(
      profileImage: "",
    );
    return UserPersonalDetailsState(
        userPersonalDetails: updateUserDetails,
        error: null,
        isLoading: false,
        isGenderChange: false,
        isProfileImageDeleted: true);
  }

  // Factory constructor to create error state
  factory UserPersonalDetailsState.error(dynamic error, userPersonalDetails) =>
      UserPersonalDetailsState(
          userPersonalDetails: userPersonalDetails,
          error: error,
          isLoading: false,
          isGenderChange: false,
          isProfileImageDeleted: false);
}
