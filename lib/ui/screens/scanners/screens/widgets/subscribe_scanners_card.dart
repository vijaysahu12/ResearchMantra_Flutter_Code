import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/generic_message.dart';

import 'package:research_mantra_official/ui/screens/home/home_navigator.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class ExclusiveTradingInsightsCard extends StatelessWidget {
  final bool isResearch;
  final bool isScanner;
  // final String emptyScannerScreenTextTitleOne;

  const ExclusiveTradingInsightsCard({
    super.key,
    required this.isResearch,
    required this.isScanner,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth * 0.8;

    return Container(
      color: theme.primaryColor,
      padding: const EdgeInsets.symmetric(
        horizontal: 25.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            emptyScannerScreenTextTitleOne,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.primaryColorDark,
              fontSize: fontSize * 0.045,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            emptyScannerScreenTextTitleSubTitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.primaryColorDark,
              fontSize: fontSize * 0.04,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Always show the Scanner button
          if (!isScanner)
            _buildAnimatedButton(
                context: context,
                label: emptyScannerScreenScannerButtonText,
                color: theme.indicatorColor,
                icon: Icons.notifications_active,
                onTap: () => _navigateToHomeTab(context, 1),
                fontSize: fontSize,
                theme: theme),

          const SizedBox(height: 16),

          // Only show Research button if user doesn't have Research subscription
          if (!isResearch)
            _buildAnimatedButton(
                context: context,
                label: emptyScannerScreenResearchButtonText,
                color: theme.indicatorColor,
                icon: Icons.insights,
                onTap: () => _navigateToHomeTab(context, 3),
                fontSize: fontSize,
                theme: theme),

          if (!isResearch) const SizedBox(height: 16),

          Text(
            emptyScannerScreenHintText,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.primaryColorDark,
              fontSize: fontSize * 0.035,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: fontSize * 0.4),
        ],
      ),
    );
  }

  void _navigateToHomeTab(BuildContext context, int tabIndex) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => HomeNavigatorWidget(initialIndex: tabIndex),
      ),
      (route) => false,
    );
  }

  Widget _buildAnimatedButton({
    required BuildContext context,
    required String label,
    required Color color,
    required VoidCallback onTap,
    required IconData icon,
    required double fontSize,
    required ThemeData theme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color,
              color.withOpacity(0.8),
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: theme.floatingActionButtonTheme.foregroundColor,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: fontFamily,
                fontSize: fontSize * 0.035,
                fontWeight: FontWeight.w600,
                color: theme.floatingActionButtonTheme.foregroundColor,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
