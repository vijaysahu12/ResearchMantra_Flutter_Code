import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Centralized text styles for the app.
/// Uses [flutter_screenutil] for responsive font sizes (.sp).
/// Always use these instead of hardcoded styles for consistency.
class AppTextStyles {
  /// H1 → Biggest headline (e.g., Splash screen title, onboarding, banners)
  static TextStyle h1 = TextStyle(
    color: Colors.red,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w900,
    fontSize: 22.sp,
  );

  /// H2 → Section titles / Page titles
  /// Example: "Your Trades", "Settings", "Profile"
  static TextStyle h2 = TextStyle(
    color: Colors.black,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.bold,
    fontSize: 20.sp,
  );

  /// H4 → Subheadings, card titles, or secondary headings
  /// Example: Card titles like "Top Gainers", "Market News"
  static TextStyle h4 = TextStyle(
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w600,
    fontSize: 18.sp,
  );

  /// H5 → Smaller subheadings / labels
  /// Example: Tabs, smaller section headers, form labels
  static TextStyle h5 = TextStyle(
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w600,
    fontSize: 16.sp,
  );

  /// Input → Text fields (form inputs, search bar, OTP, etc.)
  static TextStyle input = TextStyle(
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.normal,
    fontSize: 14.sp,
  );

  /// Standard → Default body text
  /// Example: Paragraphs, descriptions, general content
  static TextStyle standard = TextStyle(
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w500,
    fontSize: 16.sp,
  );

  /// Small → Captions, helper texts, tooltips
  /// Example: "Terms & Conditions", small notes below inputs
  static TextStyle small = TextStyle(
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w300,
    fontSize: 12.sp,
  );

  /// Login → Buttons / CTAs (Call to Action)
  /// Example: "Login", "Sign Up", "Get Started"
  static TextStyle login = TextStyle(
    fontSize: 20.sp,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );
}
