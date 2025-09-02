import 'package:flutter/material.dart';

class CommonOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final double borderRadius;
  final Color borderColor;
  final Color textColor;
  final double borderWidth;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;

  const CommonOutlineButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width,
    this.height,
    this.borderRadius = 20.0,
    this.borderColor = Colors.blue,
    this.textColor = Colors.black,
    this.borderWidth = 1.5,
    this.textStyle,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? 30,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: borderColor,
            width: borderWidth,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          backgroundColor: Colors.transparent,
        ),
        child: Text(
          text,
          style: textStyle ??
              TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}
