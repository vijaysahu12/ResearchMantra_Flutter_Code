import 'package:flutter/material.dart';
import 'package:research_mantra_official/services/check_connectivity.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

const buttonElevation = 8.0;
const borderRadius = 20.0;

class Button extends StatelessWidget {
  final String text;
  final String? semanticsLabel;
  final Function onPressed;
  final bool disabled;
  final bool isLoading;
  final Color backgroundColor;
  final TextStyle? textStyle;
  final IconData? icon;
  final Color? iconColor;
  final Color? textColor; // New property for text color

  const Button({
    super.key,
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor, // Initialize the text color
    this.textStyle,
    this.disabled = false,
    this.isLoading = false,
    this.icon,
    this.iconColor,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontSize = MediaQuery.of(context).size.height;
    return Semantics(
      label: semanticsLabel,
      child: ElevatedButton(
        onPressed: () async {
          bool checkConnection =
              await CheckInternetConnection().checkInternetConnection();
          if (checkConnection) {
            (disabled || isLoading) ? null : onPressed();
          }
        },
        style: ButtonStyle(
          overlayColor: WidgetStateProperty.resolveWith(
            (states) {
              return states.contains(WidgetState.pressed)
                  ? Colors.grey.withOpacity(0.5)
                  : null;
            },
          ),
          backgroundColor: WidgetStateProperty.all<Color>(
            disabled || isLoading ? backgroundColor : backgroundColor,
          ),
          foregroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
          textStyle: WidgetStateProperty.all<TextStyle>(
            textStyle ?? textH5.copyWith(color: textColor),
          ),
          elevation: WidgetStateProperty.all<double?>(borderRadius),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(buttonElevation),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (isLoading)
              SizedBox.square(
                dimension: 12,
                child: CircularProgressIndicator(
                  value: null,
                  strokeWidth: 3,
                  color: theme.floatingActionButtonTheme.foregroundColor,
                ),
              ),
            if (isLoading || icon != null) const SizedBox(width: 10),
            Text(text,
                style: textStyle?.copyWith(color: textColor) ??
                    textH5.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontSize: fontSize * 0.014)),
          ],
        ),
      ),
    );
  }
}

