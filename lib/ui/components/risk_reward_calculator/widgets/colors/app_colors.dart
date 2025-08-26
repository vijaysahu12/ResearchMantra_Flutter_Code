import 'package:flutter/material.dart';

class CAppColors {
  // Dark Theme Colors
  static const darkPrimaryColor = Color.fromARGB(255, 0, 0, 0);
  static const darkBackground = Color(0xFF0F172A);
  static const darkCard = Color(0xFF1E293B);
  static const darkBorder = Color(0xFF334155);
  static const darkInputText = Colors.white;
  static const darkLabel = Color(0xFF94A3B8);
  static const darkTitle = Colors.white;
  static const darkSubtitle = Color(0xFF60A5FA);
  static const darkGreen = Color(0xFF4ADE80);
  static const darkRed = Color(0xFFF87171);
  static const darkBlue = Color(0xFF3B82F6);
  static const darkLightBlue = Color.fromARGB(255, 57, 115, 154);
  // Light Theme Colors
  static const lightPrimaryColor = Color.fromARGB(255, 255, 255, 255);
  static const lightBackground = Color(0xFFF8FAFC);
  static const lightCard = Color(0xFFFFFFFF);
  static const lightBorder = Color(0xFFE2E8F0);
  static const lightInputText = Colors.black;
  static const lightLabel = Color(0xFF475569);
  static const lightTitle = Colors.black;
  static const lightSubtitle = Color(0xFF2563EB);
  static const lightGreen = Color(0xFF16A34A);
  static const lightRed = Color(0xFFDC2626);
  static const lightBlue = Color(0xFF2563EB);
  static const lightLightBlue = Color.fromARGB(255, 57, 115, 154);

  // 👇 Access dynamic theme colors using context
  static Color bg(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkBackground
          : lightBackground;

  static Color card(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkCard : lightCard;

  static Color border(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkBorder
          : lightBorder;

  static Color title(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkTitle : lightTitle;

  static Color subtitle(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkSubtitle
          : lightSubtitle;

  static Color label(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkLabel : lightLabel;

  static Color inputText(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkInputText
          : lightInputText;

  static Color button(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkBlue : lightBlue;

  static Color green(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkGreen : lightGreen;

  static Color red(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkRed : lightRed;

  static Color banner(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkLightBlue
          : lightLightBlue;

//constant List of colors
  static List<Color> banners(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? [darkPrimaryColor, darkPrimaryColor, darkLightBlue]
          : [lightPrimaryColor, lightPrimaryColor, lightLightBlue];
}
