import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/providers/get_support_mobile/support_mobile_state.dart';
import 'package:research_mantra_official/services/url_launcher_helper.dart';

class SocialMediaLinks extends StatelessWidget {
  final GetSupportState getMobileNumber;
  final bool isInside;
  SocialMediaLinks(
      {super.key, required this.getMobileNumber, required this.isInside});

  // Mapping social media names to URLs and icons
  // Function to open social media links
  Future<void> launchSocialMediaURL(String name) async {
    final socialMediaUrls = {
      "whatsapp": "https://wa.me/+91${getMobileNumber.data}",
      "instagram": instagram,
      "telegram": telegram,
      "twitter": twitter,
      "linkedin": linkedin,
      "facebook": facebookUrl,
      "youtube": youtube,
    };

    final url = socialMediaUrls[name] ?? youtube;
    await UrlLauncherHelper.launchUrlIfPossible(url);
  }

  final Map<String, String> socialMediaIcons = {
    "whatsapp": whatsappNormal,
    "instagram": instagramFill,
    "telegram": telegramNormal,
    "twitter": twitterNormal,
    "linkedin": linkedinNormal,
    "facebook": facebook,
    "youtube": youtubeNormal,
  };

  // Helper function to create social media icon widget
  Widget _buildSocialIcon(BuildContext context, String name) {
    return GestureDetector(
      onTap: () => launchSocialMediaURL(name),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        width: 30,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.asset(
            socialMediaIcons[name] ?? youtubeNormal,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      decoration: isInside
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: theme.primaryColor,
              boxShadow: [
                BoxShadow(
                  color: theme.focusColor.withOpacity(0.4),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            )
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildSocialIcon(context, "whatsapp"),
          // const Spacer(),
          _buildSocialIcon(context, "instagram"),
          // const Spacer(),
          _buildSocialIcon(context, "telegram"),
          // const Spacer(),
          _buildSocialIcon(context, "twitter"),
          // const Spacer(),
          _buildSocialIcon(context, "linkedin"),
          // const Spacer(),
          _buildSocialIcon(context, "facebook"),
          // const Spacer(),
          _buildSocialIcon(context, "youtube"),
        ],
      ),
    );
  }
}
