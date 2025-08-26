import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

Color brandingPrimaryColor = const Color(0xffffffff);
Color brandingSecondaryColor = const Color(0xff000000);
Color footerBg = const Color.fromRGBO(33, 32, 32, 0.867);

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: brandingSecondaryColor,
    primaryColorDark: brandingPrimaryColor,
    primaryColorLight: brandingSecondaryColor,
    secondaryHeaderColor: const Color(0xFF44B748), //profit color
    disabledColor: const Color(0xffFF2929), ////loss color
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(foregroundColor: brandingPrimaryColor),
    bottomNavigationBarTheme:
        BottomNavigationBarThemeData(backgroundColor: footerBg),
    iconTheme: IconThemeData(color: brandingSecondaryColor),
    scaffoldBackgroundColor: Colors.grey.shade900,
    indicatorColor: const Color(0xff9091F9),
    shadowColor: const Color(0xFF9E9E9E).withOpacity(0.27),
    focusColor: const Color(0xff969696),
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
      backgroundColor: Color.fromARGB(221, 33, 32, 32),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardColor: Color(0xFF1E293B),
    );
