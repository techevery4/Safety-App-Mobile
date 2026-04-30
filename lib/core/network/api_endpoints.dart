/// All API endpoint constants for RoamSafe backend.
class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = ''; // to be set in app_config.dart

  // Auth
  static const String register = '/api/v1/users';
  static const String login = '/api/v1/users/login';
  static const String setupProfile = '/api/v1/users/profile/setup';
  static const String changePassword = '/api/v1/users/user/{id}/change-password';

  // OTP (backend available but not in active flow)
  static const String verifyOtp = '/api/v1/users/otp/verify';
  static const String resendOtp = '/api/v1/users/otp/resend';

  // Profile
  static const String getProfile = '/api/v1/users/profile';
  static const String updateProfile = '/api/v1/users/profile';
  static const String uploadProfilePhoto = '/api/v1/users/profile/photo';
  static const String deleteAccount = '/api/v1/users/account';

  // Emergency
  static const String triggerEmergency = '/emergency/trigger';
  static const String cancelEmergency = '/emergency/cancel';
  static const String getEmergencyHistory = '/emergency/history';

  // Contacts
  static const String contacts = '/api/v1/contacts';
  static const String confirmedContacts = '/api/v1/contacts/user/{userId}/contacts/confirmed';
  static const String pendingContacts = '/api/v1/contacts/user/{userId}/contact/requests';
  static const String respondToContact = '/api/v1/contacts/contact/respond/{requestId}/{status}';
  static const String removeContact = '/api/v1/contacts/{id}';

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
