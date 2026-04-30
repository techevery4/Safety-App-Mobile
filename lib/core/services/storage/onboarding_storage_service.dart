import 'package:shared_preferences/shared_preferences.dart';

/// Tracks where the user is in the onboarding flow.
/// Persisted to SharedPreferences so the user can resume
/// from where they left off after closing the app.
enum OnboardingStage {
  /// No account created yet.
  none,

  /// Account created (have user ID). Needs profile setup.
  registered,

  /// First/last name submitted. Needs photo upload (or skip).
  profileSetup,

  /// Fully onboarded. Ready for dashboard.
  completed,
}

class OnboardingStorageService {
  final SharedPreferences _prefs;

  static const _stageKey = 'onboarding_stage';
  static const _userIdKey = 'onboarding_user_id';
  static const _emailKey = 'onboarding_email';

  OnboardingStorageService(this._prefs);

  /// Save the current onboarding stage.
  Future<void> saveStage(OnboardingStage stage) async {
    await _prefs.setString(_stageKey, stage.name);
  }

  /// Get the current onboarding stage.
  OnboardingStage getStage() {
    final value = _prefs.getString(_stageKey);
    if (value == null) return OnboardingStage.none;
    return OnboardingStage.values.firstWhere(
      (e) => e.name == value,
      orElse: () => OnboardingStage.none,
    );
  }

  /// Save the registered user's ID for use in subsequent API calls.
  Future<void> saveUserId(String id) async {
    await _prefs.setString(_userIdKey, id);
  }

  /// Get the stored user ID.
  String? getUserId() {
    return _prefs.getString(_userIdKey);
  }

  /// Save the registered user's email.
  Future<void> saveEmail(String email) async {
    await _prefs.setString(_emailKey, email);
  }

  /// Get the stored email.
  String? getEmail() {
    return _prefs.getString(_emailKey);
  }

  /// Clear all onboarding data (on logout or cache clear).
  Future<void> clearAll() async {
    await _prefs.remove(_stageKey);
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_emailKey);
  }
}
