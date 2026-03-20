/// All API endpoint constants for RoamSafe backend.
class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = ''; // to be set in app_config.dart

  // Auth
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/resend-otp';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh-token';

  // Profile
  static const String getProfile = '/user/profile';
  static const String updateProfile = '/user/profile';
  static const String uploadProfilePhoto = '/user/profile/photo';
  static const String deleteAccount = '/user/account';

  // Emergency
  static const String triggerEmergency = '/emergency/trigger';
  static const String cancelEmergency = '/emergency/cancel';
  static const String getEmergencyHistory = '/emergency/history';

  // Contacts
  static const String getTrustedContacts = '/contacts';
  static const String addTrustedContact = '/contacts/add';
  static const String removeTrustedContact = '/contacts/{id}';
  static const String searchUserByEmail = '/contacts/search';

  // Location
  static const String shareLocation = '/location/share';
  static const String stopSharingLocation = '/location/stop';
  static const String getSharedLocations = '/location/history';
  static const String updateLiveLocation = '/location/update';

  // Settings
  static const String getSettings = '/settings';
  static const String updateSettings = '/settings';

  // Ads
  static const String getActiveAds = '/ads/active';
}
