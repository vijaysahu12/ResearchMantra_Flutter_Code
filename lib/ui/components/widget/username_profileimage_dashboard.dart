import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/providers/images/dashboard/dashboard_provider.dart';
import 'package:research_mantra_official/ui/screens/profile/profile_screen.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/personaldetails/personal_profile_screen.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class ProfileImageAndUserName extends ConsumerStatefulWidget {
  const ProfileImageAndUserName({super.key});

  @override
  ConsumerState<ProfileImageAndUserName> createState() =>
      _ProfileImageAndUserNameState();
}

class _ProfileImageAndUserNameState
    extends ConsumerState<ProfileImageAndUserName> {
  @override
  void initState() {
    super.initState();

    getUsersData();
  }

//Function to get user details
  Future<void> getUsersData() async {
    await ref.read(userProfileProvider.notifier).loadUserProfile();
  }

  void handleToNavigatePersonalProfileDetailsScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PersonalProfileDetailsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final userProfile = ref.watch(userProfileProvider);

    final userProfileName = userProfile.userName ?? "K";

    return GestureDetector(
      onTap: () => handleToNavigatePersonalProfileDetailsScreen(),
      child: Row(
        children: [
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.indicatorColor,
            ),
            alignment: Alignment.center,
            child: Text(
              userProfileName.substring(0, 1).toUpperCase(),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: theme.floatingActionButtonTheme.foregroundColor,
                fontFamily: "poppin",
              ),
            ),
          ),
          const SizedBox(width: 5),
          AnimatedOpacity(
            duration: const Duration(seconds: 2),
            opacity: 1,
            child: Text(
              userProfileName, // Use 'User' as default if userName is null
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.016,
                  color: theme.indicatorColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: fontFamily),
            ),
          ),
        ],
      ),
    );
  }
}
