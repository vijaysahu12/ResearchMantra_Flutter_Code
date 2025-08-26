import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import '../../themes/text_styles.dart';

class NotificationEmptyWidget extends StatelessWidget {
  const NotificationEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              notificationEmpty,
              scale: 2,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error,
                    color: theme.primaryColor,
                    size: 50); // Add fallback for missing image
              },
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Text(
                notificationEmptyText,
                style: textH5.copyWith(
                  color: theme.primaryColorDark,
                  fontFamily: fontFamily,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
