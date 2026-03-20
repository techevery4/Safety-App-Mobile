/// Application-wide constants for RoamSafe.
class AppConstants {
  AppConstants._();

  // Timeouts
  static const int connectionTimeout = 30000; // milliseconds
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;

  // Shake Detection
  static const int defaultShakeCount = 3;
  static const double shakeThreshold = 2.7; // m/s²
  static const int shakeCountResetTime = 3000; // milliseconds

  // Emergency
  static const int emergencyActivationMaxMs = 2000; // must activate within 2s
  static const int emergencyCallRoutingMaxMs = 3000; // call within 3s
  static const int alarmFadeInMs = 500;

  // OTP
  static const int otpLength = 6;
  static const int otpResendCooldownSeconds = 60;

  // Pagination
  static const int defaultPageSize = 20;

  // Image Upload
  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png'];

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String onboardingCompleteKey = 'onboarding_complete';
  static const String settingsKey = 'app_settings';

  // Animation Durations
  static const int pageTransitionMs = 300;
  static const int splashDurationMs = 2000;
}
