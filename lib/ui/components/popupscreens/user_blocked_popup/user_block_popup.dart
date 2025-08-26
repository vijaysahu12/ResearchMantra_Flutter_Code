import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/ui/components/button.dart';

import 'package:research_mantra_official/ui/components/profile_image/common_profile_widget.dart';

import 'package:research_mantra_official/ui/themes/text_styles.dart';

class CustomUserBlock extends ConsumerWidget {
  final String name;
  final String gender;
  final String? profileImage;

  final String confirmButtonText;
  final String cancelButtonText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const CustomUserBlock({
    super.key,
    required this.name,
    required this.confirmButtonText,
    required this.cancelButtonText,
    required this.onConfirm,
    required this.onCancel,
    this.profileImage,
    required this.gender,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: theme.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UserProfileImage(
              gender: gender,
              profileImage: profileImage,
              borderColor: theme.shadowColor,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Block @$name',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: theme.primaryColorDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Flexible(
                  child: Text(
                    blockUserMessage,
                    style: TextStyle(
                        fontSize: 12,
                        color: theme.primaryColorDark,
                        fontFamily: fontFamily),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Button(
                text: confirmButtonText,
                onPressed: onConfirm,
                backgroundColor: theme.indicatorColor,
                textColor: theme.floatingActionButtonTheme.foregroundColor),
            Button(
                text: cancelButtonText,
                onPressed: () {
                  Navigator.pop(context);
                },
                backgroundColor: theme.indicatorColor,
                textColor: theme.floatingActionButtonTheme.foregroundColor)
          ],
        ),
      ),
    );
  }
}
