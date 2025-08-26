import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:research_mantra_official/ui/themes/text_styles.dart';

class CustomPopupDialog extends ConsumerWidget {
  final String title;
  final String message;
  final String confirmButtonText;
  final String cancelButtonText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final Color? buttonColor;

  const CustomPopupDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmButtonText,
    required this.cancelButtonText,
    required this.onConfirm,
    required this.onCancel,
    this.buttonColor
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final fontSize = MediaQuery.of(context).size.width * 1.0;

    Widget buildButton({
      required String text,
      required VoidCallback onTap,
      required Color backgroundColor,
    }) {
      return Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: Text(
                text,
                style: TextStyle(
                  color: theme.floatingActionButtonTheme.foregroundColor,
                  fontSize: fontSize * 0.03,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(15.0),
      child: Dialog(
        backgroundColor: theme.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title Row
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: fontSize * 0.045,
                      color: theme.primaryColorDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Message Row
              Row(
                children: [
                  Flexible(
                    child: Text(
                      message,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: fontSize * 0.03,
                        color: theme.primaryColorDark.withOpacity(0.8),
                        fontFamily: fontFamily,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Button Row
              Row(
                children: [
                  buildButton(
                    text: confirmButtonText,
                    onTap: onConfirm,
                    backgroundColor: buttonColor ?? theme.indicatorColor,
                  ),
                  const Spacer(),
                  buildButton(
                    text: cancelButtonText,
                    onTap: onCancel,
                    backgroundColor: theme.focusColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
