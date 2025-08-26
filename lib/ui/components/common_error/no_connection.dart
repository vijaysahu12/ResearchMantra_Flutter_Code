import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/ui/components/button.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class NoInternet extends StatefulWidget {
  final void Function() handleRefresh;
  const NoInternet({
    super.key,
    required this.handleRefresh,
  });

  @override
  State<NoInternet> createState() => _NoInternetWidgetState();
}

class _NoInternetWidgetState extends State<NoInternet> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(color: theme.primaryColor),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              oopsImage,
              scale: 8,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              noInternetScreenTitle,
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: fontFamily,
                  fontWeight: FontWeight.w900,
                  color: theme.primaryColorDark),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              noInternetConnectionDisplayText,
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: fontFamily,
                  fontWeight: FontWeight.w600,
                  color: theme.focusColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Expanded(
                  child: Button(
                      text: "Try again",
                      onPressed: () => widget.handleRefresh(),
                      backgroundColor: theme.disabledColor.withOpacity(0.85),
                      textColor: theme.primaryColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
