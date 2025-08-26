import 'package:flutter/material.dart';
import 'package:research_mantra_official/services/url_launcher_helper.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class LinkWidget extends StatelessWidget {
  final String url;
  final String text;
  final IconData icon;

  const LinkWidget({
    super.key,
    required this.url,
    required this.text,
    required this.icon,
  });

  // Function to launch the URL
  Future<void> _launchURL() async {
    await UrlLauncherHelper.launchUrlIfPossible(url);
    }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontSize = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: _launchURL,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.link,
            color: theme.indicatorColor,
          ), // Display the icon
          SizedBox(width: 8), // Space between icon and text
          Expanded(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: fontSize * 0.03,
                  color: theme.indicatorColor,
                  fontWeight: FontWeight.w600,
                  fontFamily: fontFamily
                  // decoration: TextDecoration.underline,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
