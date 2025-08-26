import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:research_mantra_official/ui/components/common_text_checker/text_checker.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomNotificationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String fontFamily;
  final int index;
  final Color themeColor;

  const CustomNotificationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.fontFamily,
    required this.index,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _showDialog(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Dialog(
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          children: CommonTextChecker()
                              .getStyledText(message, themeColor, fontFamily),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              if (message.startsWith("http")) {
                                await launchUrl(Uri.parse(message));
                              }
                            },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xff383BE0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Close",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Future<void> _showDialog(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
