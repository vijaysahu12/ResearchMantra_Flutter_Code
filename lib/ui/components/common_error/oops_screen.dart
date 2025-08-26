import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class ErrorScreenWidget extends StatelessWidget {
  final Future<void> Function()? onRefresh;

  const ErrorScreenWidget({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RefreshIndicator(
      onRefresh: onRefresh ??
          () async {
            await Future.delayed(const Duration(seconds: 2));
          },
      child: Container(
        decoration: BoxDecoration(color: theme.primaryColor),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  somethingwentwrong,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    oopsErrorTextMessage,
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.w600,
                        color: theme.primaryColorDark),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
