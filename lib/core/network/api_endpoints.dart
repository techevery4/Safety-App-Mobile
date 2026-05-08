/// All API endpoint constants for RoamSafe backend.
class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = ''; // to be set in app_config.dart

  // Auth
  static const String register = '/users';
  static const String login = '/users/login';
  static const String setupProfile = '/users/profile/setup';
  static const String updateUser = '/users';
  static const String changePassword = '/users/user/{id}/change-password';

  // OTP (backend available but not in active flow)
  static const String verifyOtp = '/users/otp/verify';
  static const String resendOtp = '/users/otp/resend';

  // Profile
  static const String getProfile = '/users/profile';
  static const String updateProfile = '/users/profile';
  static const String uploadProfilePhoto = '/users/profile/photo';
  static const String deleteAccount = '/users/account';

  // Emergency
  static const String triggerEmergency = '/emergency/trigger';
  static const String cancelEmergency = '/emergency/cancel';
  static const String getEmergencyHistory = '/emergency/history';

  // Contacts
  static const String contacts = '/contacts';
  static const String confirmedContacts =
      '/contacts/user/{userId}/contacts/confirmed';
  static const String pendingContacts =
      '/contacts/user/{userId}/contact/requests';
  static const String respondToContact =
      '/contacts/contact/respond/{requestId}/{status}';
  static const String removeContact = '/contacts/{id}';

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
