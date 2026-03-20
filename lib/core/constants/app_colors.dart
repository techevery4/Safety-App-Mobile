import 'package:flutter/material.dart';

/// All brand and UI colors used throughout the RoamSafe app.
class AppColors {
  AppColors._();

  // Primary Brand Colors
  static const Color primary = Color(0xFF5BBCBF);
  static const Color primaryLight = Color(0xFF8DD4D6);
  static const Color primaryDark = Color(0xFF3A9A9D);

  // Background Colors
  static const Color background = Color(0xFFF0F9FA);
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color scaffoldBackground = Color(0xFFF0F9FA);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF808080);
  static const Color textHint = Color(0xFFB0B0B0);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Button Colors
  static const Color buttonPrimary = Color(0xFF5BBCBF);
  static const Color buttonText = Color(0xFFFFFFFF);
  static const Color buttonOutline = Color(0xFF5BBCBF);

  // Input Field Colors
  static const Color inputBackground = Color(0xFFF0F0F0);
  static const Color inputBorder = Color(0xFF5BBCBF);
  static const Color inputBorderInactive = Color(0xFFE0E0E0);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFFF0000);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);

  // Emergency / SOS
  static const Color sosRed = Color(0xFFFF0000);
  static const Color sosRedDark = Color(0xFFCC0000);

  // Safety Status
  static const Color safeGreen = Color(0xFF4CAF50);
  static const Color emergencyRed = Color(0xFFFF0000);

  // Onboarding Circle Colors
  static const Color onboardingCircleOuter = Color(0xFF8BB8BA);
  static const Color onboardingCircleInner = Color(0xFFD6ECED);

  // Divider & Border
  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFE0E0E0);

  // Bottom Nav
  static const Color navActive = Color(0xFF5BBCBF);
  static const Color navInactive = Color(0xFF808080);

  // Dot indicators
  static const Color dotActive = Color(0xFF5BBCBF);
  static const Color dotInactive = Color(0xFFD0D0D0);

  // Card / Surface
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color surfaceGrey = Color(0xFFF5F5F5);

  // Error Background (for upload failed)
  static const Color errorBackground = Color(0xFFFDE8E8);
}
