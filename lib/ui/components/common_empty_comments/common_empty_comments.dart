import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/ui/components/indicator.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class EmptyCommentsScreen extends StatefulWidget {
  final bool isProgress;
  final ThemeData theme;

  const EmptyCommentsScreen({
    super.key,
    required this.theme,
    required this.isProgress,
  });

  @override
  State<EmptyCommentsScreen> createState() => _EmptyCommentsScreenState();
}

class _EmptyCommentsScreenState extends State<EmptyCommentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          if (widget.isProgress)
            const SizedBox(
              child: ProgressIndicatorExample(),
            ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    noCommentTextButton,
                    style: TextStyle(
                        fontSize: 20,
                        color: widget.theme.primaryColorDark,
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    noCommentScreenBottomText,
                    style: TextStyle(
                        color: widget.theme.primaryColorDark.withOpacity(0.6),
                        fontFamily: fontFamily,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
