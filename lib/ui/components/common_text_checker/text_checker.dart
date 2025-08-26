import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CommonTextChecker {
  List<TextSpan> getStyledText(
      String message, Color defaultColor, String fontFamily,
      {double fontSize = 12}) {
    // Sanitize the message to remove malformed UTF-16 characters
    final safeMessage = _sanitizeUtf16(message);

    final RegExp urlPattern = RegExp(
      r'(https?:\/\/[^\s]+)',
      caseSensitive: false,
    );

    List<TextSpan> spans = [];
    int startIndex = 0;

    for (final Match match in urlPattern.allMatches(safeMessage)) {
      if (match.start > startIndex) {
        spans.add(TextSpan(
          text: safeMessage.substring(startIndex, match.start),
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: fontSize,
              color: defaultColor,
              fontFamily: fontFamily),
        ));
      }

      spans.add(TextSpan(
        text: match.group(0),
        style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: fontSize,
            color: const Color.fromARGB(255, 5, 121, 217),
            fontFamily: fontFamily),
        recognizer: TapGestureRecognizer()
          ..onTap = () async {
            final url = match.group(0)!;
            await launchUrl(Uri.parse(url));
          },
      ));

      startIndex = match.end;
    }

    if (startIndex < safeMessage.length) {
      spans.add(TextSpan(
        text: safeMessage.substring(startIndex),
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: fontSize,
            color: defaultColor,
            fontFamily: fontFamily),
      ));
    }

    return spans;
  }

  String _sanitizeUtf16(String input) {
    try {
      return String.fromCharCodes(input.codeUnits.where(
        (unit) => unit <= 0xD7FF || (unit >= 0xE000 && unit <= 0x10FFFF),
      ));
    } catch (e) {
      return '';
    }
  }
}
