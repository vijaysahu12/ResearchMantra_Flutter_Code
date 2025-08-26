import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

Color brandingPrimaryColor = const Color(0xffffffff);
Color brandingSecondaryColor = const Color(0xff000000);
Color? footerBg = const Color.fromARGB(255, 244, 244, 243);
Color subscriptionTileSelectedColor = const Color(0xFFee1414);

Color subscriptionTileUnSelectedColor = const Color(0xFFff9c9c);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: brandingPrimaryColor,
  primaryColorDark: brandingSecondaryColor,
  secondaryHeaderColor: const Color(0xff44b748), //profit color
  disabledColor: const Color(0xffAD0000), ////loss color
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    foregroundColor: brandingPrimaryColor,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: footerBg,
    // Color(0xfff4f4f3),
  ),
  iconTheme: const IconThemeData(
    color: Colors.black,
  ),
  scaffoldBackgroundColor: brandingSecondaryColor,
  indicatorColor: const Color(0xff383BE0),
  shadowColor: Colors.grey.withOpacity(0.27),
  focusColor: const Color(0xff595959),
  fontFamily: fontFamily,
  textTheme: const TextTheme(
    displayLarge: textH1,
    headlineMedium: textH4,
    headlineSmall: textH5,
    titleMedium: textStandard,
    titleSmall: textSmall,
    bodyLarge: textInput,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xfff4f4f3),
    foregroundColor: Colors.black,
    elevation: 0,
  ),
);
