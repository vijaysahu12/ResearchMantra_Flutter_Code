import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Centralized text styles for the app
class AppTextStyles {
  /// H1 → Titles (18px / Semibold)
  static final TextStyle h1 = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle h2 = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle h3 = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle body = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle bodyMedium = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle stat = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle statStrong = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
  );

  static final TextStyle caption = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle captionMedium = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
  );
}
