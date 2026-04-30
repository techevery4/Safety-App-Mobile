import 'package:flutter/material.dart';

/// All brand and UI colors used throughout the RoamSafe app.
class AppColors {
  AppColors._();

  // Primary Brand Colors
  static const Color primary = Color(0xFF000080);
  static const Color primaryLight = Color(0xFF3333B2);
  static const Color primaryDark = Color(0xFF00005A);

  // Background Colors
  static const Color background = Color(0xFFF0F0FA);
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color scaffoldBackground = Color(0xFFF0F0FA);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF808080);
  static const Color textHint = Color(0xFFB0B0B0);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Button Colors
  static const Color buttonPrimary = Color(0xFF000080);
  static const Color buttonText = Color(0xFFFFFFFF);
  static const Color buttonOutline = Color(0xFF000080);

  // Input Field Colors
  static const Color inputBackground = Color(0xFFD3D3E8);
  static const Color inputBorder = Color(0xFF000080);
  static const Color inputBorderInactive = Color(0xFFE0E0E0);

  // Status Colors
  static const Color success = Color(0xFF24A850);
  static const Color error = Color(0xFFFF0000);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);
  static const Color backgroundSuccess = Color.fromARGB(85, 132, 234, 179);

  // Emergency / SOS
  static const Color sosRed = Color(0xFFFF0000);
  static const Color sosRedDark = Color(0xFFCC0000);

  // Safety Status
  static const Color safeGreen = Color(0xFF4CAF50);
  static const Color emergencyRed = Color(0xFFFF0000);

  // Onboarding Circle Colors
  static const Color onboardingCircleOuter = Color(0xFF6666AA);
  static const Color onboardingCircleInner = Color.fromARGB(255, 220, 220, 239);
  static const Color onboardingCircleLight = Color.fromARGB(60, 0, 0, 128);

  // Divider & Border
  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFE0E0E0);

  // Bottom Nav
  static const Color navActive = Color(0xFF000080);
  static const Color navInactive = Color(0xFF808080);

  // Dot indicators
  static const Color dotActive = Color(0xFF000080);
  static const Color dotInactive = Color(0xFFD0D0D0);

  // Card / Surface
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color surfaceGrey = Color(0xFFF5F5F5);

  // Error Background (for upload failed)
  static const Color errorBackground = Color(0xFFFDE8E8);

  // Warning Background (for decline contact)
  static const Color warningBackground = Color(0xFFFFF3E0);
}
