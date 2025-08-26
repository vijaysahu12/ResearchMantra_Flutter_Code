import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:research_mantra_official/services/url_launcher_helper.dart';

class ExpandableText extends StatefulWidget {
  final String? text;
  final TextStyle textStyle;
  final TextStyle linkStyle;
  final int trimLength;
  final TextAlign textAlign;

  const ExpandableText({
    super.key,
    required this.text,
    required this.textStyle,
    required this.linkStyle,
    this.trimLength = 400,
    this.textAlign = TextAlign.start,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  String safeTrim(String input, int maxLength) {
    if (input.runes.length <= maxLength) return input;
    return String.fromCharCodes(input.runes.take(maxLength));
  }

  @override
  Widget build(BuildContext context) {
    final content = widget.text ?? '';
    final shouldTrim = content.length > widget.trimLength;

    final displayText = isExpanded || !shouldTrim
        ? content
        : '${safeTrim(content, widget.trimLength)}... ';

    return RichText(
      textAlign: widget.textAlign,
      text: TextSpan(
        children: [
          ..._buildTextSpans(displayText.trim(), widget.textStyle),
          if (shouldTrim)
            TextSpan(
              text: isExpanded ? "  read less" : " read more",
              recognizer: TapGestureRecognizer()
                ..onTap = () => setState(() => isExpanded = !isExpanded),
              style: widget.linkStyle,
            ),
        ],
      ),
    );
  }

  List<TextSpan> _buildTextSpans(String text, TextStyle normalStyle) {
    final urlRegex = RegExp(r'(https?:\/\/[^\s]+)');
    final matches = urlRegex.allMatches(text);

    if (matches.isEmpty) return [TextSpan(text: text, style: normalStyle)];

    List<TextSpan> spans = [];
    int start = 0;

    for (final match in matches) {
      if (match.start > start) {
        spans.add(TextSpan(
          text: text.substring(start, match.start),
          style: normalStyle,
        ));
      }

      final url = text.substring(match.start, match.end);
      spans.add(TextSpan(
        text: url,
        style: widget.linkStyle,
        recognizer: TapGestureRecognizer()
          ..onTap = () async {
            await UrlLauncherHelper.launchUrlIfPossible(url);
          },
      ));

      start = match.end;
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start), style: normalStyle));
    }

    return spans;
  }
}
