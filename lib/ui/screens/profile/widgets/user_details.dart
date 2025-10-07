// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/user_login_response_model.dart';
import 'package:research_mantra_official/data/models/user_personal_details_api_response_model.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/components/cacher_network_images/circular_cached_network_image.dart';

import 'package:research_mantra_official/ui/router/app_routes.dart';

import 'package:research_mantra_official/ui/themes/text_styles.dart';

// Widget for displaying user details
class UserDetails extends StatefulWidget {
  final UserPersonalDetailsModel? getUserPersonalDetails;
  final void Function() handleToNavigateUserBlockedScreen;
  const UserDetails({
    super.key,
    this.getUserPersonalDetails,
    required this.handleToNavigateUserBlockedScreen,
  });

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final UserSecureStorageService _commonDetails = UserSecureStorageService();

  String? userName;
  String? userEmailId;
  String? profileImageUrl;
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    // Load user details when the widget initializes
    loadUserDetails();
  }

  // Function to load user details and gender from secure storage
  Future<void> loadUserDetails() async {
    try {
      final Map<String, dynamic> userDetails =
          await _commonDetails.getUserDetails();
      UserData userData = UserData.fromJson(userDetails);

      final String? gender = await _commonDetails.getSelectedGender();

      setState(() {
        userName = userData.fullName;
        userEmailId = userData.emailId;
        profileImageUrl =
            userData.profileImage != null ? '${userData.profileImage}' : null;
        selectedGender =
            gender ?? widget.getUserPersonalDetails?.gender ?? maleGenderValue;
      });
    } catch (e) {
      // Handle any errors that occur during loading user details
      print('Error loading user details: $e');
    }
  }

  // Function to navigate to personal details screen
  Future<void> navigateToPersonalDetailsScreen(BuildContext context) async {
    var result = await Navigator.pushNamed(context, personalProfileDetails);

    // Reload user details if any changes made in the personal details screen
    if (result != null) {
      loadUserDetails();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontSize = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => navigateToPersonalDetailsScreen(context),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.shadowColor, width: 1),
          color: theme.appBarTheme.backgroundColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              const SizedBox(
                width: 10,
              ),

              CircleAvatar(
                radius: 20,
                child: Text(
                  userName != null && userName!.isNotEmpty
                      ? userName![0].toUpperCase()
                      : 'R',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.indicatorColor,
                      fontSize: fontSize * 0.035,
                      fontFamily: fontFamily),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              // Display user name and email
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName ?? 'Hello User',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.indicatorColor,
                        fontSize: fontSize * 0.035,
                        fontFamily: fontFamily),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: theme.shadowColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: InkWell(
                    onTap: widget.handleToNavigateUserBlockedScreen,
                    child: Icon(Icons.lock_person_outlined,
                        color: theme.disabledColor)),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
