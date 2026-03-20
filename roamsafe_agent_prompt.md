# ANTIGRAVITY AGENT PROMPT — ROAMSAFE FLUTTER PROJECT

---

## CONTEXT & YOUR ROLE

You are being initialized to serve as the lead development agent for **RoamSafe**, a Safety Emergency Alert mobile application built with **Flutter** (Android & iOS). Your job is to:

1. Set up the complete Flutter project structure from scratch inside the current working folder.
2. Organize it in a way that is clean, scalable, and production-ready.
3. Convert Figma screens to Flutter UI — screens will be provided to you module by module as images placed in the `figma_images/` folder within the project root (`roamsafe/figma_images/`).
4. Stub out all services, API layers, and integration points so they are ready for real API wiring later.

You are working in the **existing project folder** — do NOT create a nested subfolder for the app. Run `flutter create .` or scaffold directly in the current directory.

---

## APP OVERVIEW

**RoamSafe** is a personal safety app. Core capabilities:

- User registration & login (email-based, OTP verification)
- Emergency alert triggering (manual button tap + shake detection)
- Audible alarm (overrides silent mode, plays even when locked/backgrounded)
- Automatic emergency call routing to a configured number
- Real-time GPS location sharing with trusted contacts
- Trusted contacts management (app users only, added by email)
- In-app advertising carousel
- Safety status indicator (SAFE / EMERGENCY ACTIVE)
- Full settings module (location sharing, emergency config, notifications, privacy, permissions, about)

**Tech Stack:**
- Mobile: Flutter (Android & iOS)
- Backend: Java (REST API — to be wired later)
- Database: MongoDB
- Hosting: DigitalOcean
- Maps: Google Maps (optional integration)

---

## STEP 1 — PROJECT INITIALISATION

Run the following and confirm success:

```bash
flutter create . --org com.roamsafe --project-name roamsafe
flutter pub get
```

Set the app name to **RoamSafe** in:
- `android/app/src/main/AndroidManifest.xml` → `android:label`
- `ios/Runner/Info.plist` → `CFBundleDisplayName`

---

## STEP 2 — REQUIRED PERMISSIONS

### Android (`android/app/src/main/AndroidManifest.xml`)
Add the following permissions:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_LOCATION"/>
<uses-permission android:name="android.permission.CALL_PHONE"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.READ_CONTACTS"/>
```

### iOS (`ios/Runner/Info.plist`)
Add:
```xml
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>RoamSafe needs your location to share with trusted contacts during emergencies.</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>RoamSafe needs your location during emergencies.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>RoamSafe needs background location access during emergencies.</string>
<key>NSMicrophoneUsageDescription</key>
<string>RoamSafe may use the microphone during emergency calls.</string>
```

---

## STEP 3 — PUBSPEC.YAML DEPENDENCIES

Add the following to `pubspec.yaml` under `dependencies:`:

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_bloc: ^8.1.5
  equatable: ^2.0.5

  # Navigation
  go_router: ^13.2.0

  # Networking & API
  dio: ^5.4.3
  retrofit: ^4.1.0
  json_annotation: ^4.9.0

  # Local Storage
  flutter_secure_storage: ^9.0.0
  shared_preferences: ^2.2.3
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # Location
  geolocator: ^11.0.0
  google_maps_flutter: ^2.6.0

  # Sensors (Shake Detection)
  sensors_plus: ^4.0.2

  # Notifications & Background
  flutter_local_notifications: ^17.1.2
  firebase_messaging: ^14.9.4  # for push notifications
  workmanager: ^0.5.2

  # Audio (Alarm)
  just_audio: ^0.9.38
  audio_session: ^0.1.21

  # Phone / Calling
  url_launcher: ^6.2.5

  # Permissions
  permission_handler: ^11.3.1

  # Image Handling
  image_picker: ^1.1.2
  cached_network_image: ^3.3.1
  flutter_image_compress: ^2.2.0

  # UI / UX
  flutter_svg: ^2.0.10+1
  shimmer: ^3.0.0
  lottie: ^3.1.0
  carousel_slider: ^4.2.1
  pin_code_fields: ^8.0.1

  # Utilities
  intl: ^0.19.0
  uuid: ^4.4.0
  connectivity_plus: ^6.0.3
  package_info_plus: ^8.0.0
  device_info_plus: ^10.1.0
  path_provider: ^2.1.3
  logger: ^2.3.0
  get_it: ^7.7.0           # dependency injection
  injectable: ^2.4.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  build_runner: ^2.4.9
  json_serializable: ^6.8.0
  retrofit_generator: ^8.1.0
  injectable_generator: ^2.4.1
  hive_generator: ^2.0.1
  mocktail: ^1.0.3
```

Run `flutter pub get` after updating.

---

## STEP 4 — COMPLETE FOLDER STRUCTURE

Create the following folder structure exactly. Create a placeholder `README.md` or `.gitkeep` in empty folders:

```
lib/
├── main.dart
├── app.dart                            # MaterialApp / GoRouter root
│
├── core/
│   ├── config/
│   │   ├── app_config.dart             # env-based config (baseUrl, keys)
│   │   ├── environment.dart            # dev / staging / prod enum
│   │   └── flavor_config.dart
│   │
│   ├── constants/
│   │   ├── app_constants.dart          # timeouts, shake threshold, etc.
│   │   ├── app_strings.dart            # all hardcoded strings
│   │   ├── app_colors.dart             # brand colors
│   │   ├── app_text_styles.dart
│   │   └── app_assets.dart             # asset path references
│   │
│   ├── di/
│   │   ├── injection.dart              # GetIt service locator setup
│   │   └── injection.config.dart       # auto-generated by injectable
│   │
│   ├── errors/
│   │   ├── exceptions.dart             # custom exception classes
│   │   └── failures.dart              # Either<Failure, T> failures
│   │
│   ├── network/
│   │   ├── api_client.dart             # Dio instance + interceptors
│   │   ├── api_endpoints.dart          # all endpoint strings
│   │   ├── interceptors/
│   │   │   ├── auth_interceptor.dart   # attach Bearer token
│   │   │   ├── logging_interceptor.dart
│   │   │   └── error_interceptor.dart
│   │   └── network_info.dart           # connectivity check
│   │
│   ├── router/
│   │   ├── app_router.dart             # GoRouter config
│   │   └── app_routes.dart             # named route constants
│   │
│   ├── services/
│   │   ├── storage/
│   │   │   ├── secure_storage_service.dart   # tokens, sensitive data
│   │   │   └── local_storage_service.dart    # shared prefs / hive
│   │   │
│   │   ├── location/
│   │   │   ├── location_service.dart         # geolocator wrapper
│   │   │   └── background_location_service.dart
│   │   │
│   │   ├── alarm/
│   │   │   ├── alarm_service.dart            # just_audio + override silent
│   │   │   └── alarm_config.dart
│   │   │
│   │   ├── shake/
│   │   │   └── shake_detection_service.dart  # sensors_plus wrapper
│   │   │
│   │   ├── notification/
│   │   │   ├── notification_service.dart     # local notifications
│   │   │   └── push_notification_service.dart
│   │   │
│   │   └── calling/
│   │       └── call_service.dart             # url_launcher tel: handler
│   │
│   ├── theme/
│   │   ├── app_theme.dart              # ThemeData
│   │   └── app_theme_extension.dart
│   │
│   └── utils/
│       ├── validators.dart
│       ├── formatters.dart
│       ├── extensions/
│       │   ├── string_extensions.dart
│       │   ├── context_extensions.dart
│       │   └── datetime_extensions.dart
│       └── helpers/
│           ├── permission_helper.dart
│           └── dialog_helper.dart
│
├── features/
│   │
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── auth_remote_datasource.dart
│   │   │   │   └── auth_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── user_model.dart
│   │   │   │   └── auth_response_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── register_user_usecase.dart
│   │   │       ├── login_user_usecase.dart
│   │   │       ├── verify_otp_usecase.dart
│   │   │       ├── logout_usecase.dart
│   │   │       └── get_current_user_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── auth_bloc.dart
│   │       │   ├── auth_event.dart
│   │       │   └── auth_state.dart
│   │       ├── pages/
│   │       │   ├── splash_screen.dart
│   │       │   ├── welcome_screen.dart
│   │       │   ├── onboarding_screen.dart
│   │       │   ├── register_screen.dart
│   │       │   ├── otp_verification_screen.dart
│   │       │   ├── setup_profile_screen.dart
│   │       │   └── login_screen.dart
│   │       └── widgets/
│   │           ├── auth_text_field.dart
│   │           └── auth_button.dart
│   │
│   ├── dashboard/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── dashboard_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── safety_status_model.dart
│   │   │   └── repositories/
│   │   │       └── dashboard_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── safety_status_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── dashboard_repository.dart
│   │   │   └── usecases/
│   │   │       └── get_safety_status_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── dashboard_bloc.dart
│   │       │   ├── dashboard_event.dart
│   │       │   └── dashboard_state.dart
│   │       ├── pages/
│   │       │   ├── dashboard_screen.dart
│   │       │   └── emergency_active_screen.dart
│   │       └── widgets/
│   │           ├── emergency_button.dart
│   │           ├── safety_status_indicator.dart
│   │           ├── ad_carousel_widget.dart
│   │           └── bottom_nav_bar.dart
│   │
│   ├── emergency/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── emergency_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── emergency_event_model.dart
│   │   │   └── repositories/
│   │   │       └── emergency_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── emergency_event_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── emergency_repository.dart
│   │   │   └── usecases/
│   │   │       ├── trigger_emergency_usecase.dart
│   │   │       ├── cancel_emergency_usecase.dart
│   │   │       └── stop_alarm_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── emergency_bloc.dart
│   │       │   ├── emergency_event.dart
│   │       │   └── emergency_state.dart
│   │       ├── pages/
│   │       │   └── emergency_triggered_screen.dart
│   │       └── widgets/
│   │           └── stop_alarm_button.dart
│   │
│   ├── contacts/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── contacts_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── contact_model.dart
│   │   │   └── repositories/
│   │   │       └── contacts_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── contact_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── contacts_repository.dart
│   │   │   └── usecases/
│   │   │       ├── add_contact_usecase.dart
│   │   │       ├── remove_contact_usecase.dart
│   │   │       └── get_contacts_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── contacts_bloc.dart
│   │       │   ├── contacts_event.dart
│   │       │   └── contacts_state.dart
│   │       ├── pages/
│   │       │   ├── contacts_screen.dart
│   │       │   └── add_contact_screen.dart
│   │       └── widgets/
│   │           └── contact_list_tile.dart
│   │
│   ├── location/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── location_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── location_model.dart
│   │   │   └── repositories/
│   │   │       └── location_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── location_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── location_repository.dart
│   │   │   └── usecases/
│   │   │       ├── share_location_usecase.dart
│   │   │       ├── stop_sharing_usecase.dart
│   │   │       └── get_location_history_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── location_bloc.dart
│   │       │   ├── location_event.dart
│   │       │   └── location_state.dart
│   │       ├── pages/
│   │       │   ├── location_sharing_screen.dart
│   │       │   └── shared_location_history_screen.dart
│   │       └── widgets/
│   │           └── location_map_view.dart
│   │
│   ├── profile/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── profile_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── profile_model.dart
│   │   │   └── repositories/
│   │   │       └── profile_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── profile_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── profile_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_profile_usecase.dart
│   │   │       └── update_profile_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── profile_bloc.dart
│   │       │   ├── profile_event.dart
│   │       │   └── profile_state.dart
│   │       ├── pages/
│   │       │   └── profile_screen.dart
│   │       └── widgets/
│   │           └── profile_avatar.dart
│   │
│   ├── settings/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── settings_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── settings_model.dart
│   │   │   └── repositories/
│   │   │       └── settings_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── settings_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── settings_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_settings_usecase.dart
│   │   │       └── update_settings_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── settings_bloc.dart
│   │       │   ├── settings_event.dart
│   │       │   └── settings_state.dart
│   │       ├── pages/
│   │       │   ├── settings_screen.dart
│   │       │   ├── account_settings_screen.dart
│   │       │   ├── emergency_settings_screen.dart
│   │       │   ├── notification_settings_screen.dart
│   │       │   ├── privacy_settings_screen.dart
│   │       │   ├── app_permissions_screen.dart
│   │       │   └── about_screen.dart
│   │       └── widgets/
│   │           └── settings_tile.dart
│   │
│   └── advertising/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── ads_remote_datasource.dart
│       │   ├── models/
│       │   │   └── ad_model.dart
│       │   └── repositories/
│       │       └── ads_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── ad_entity.dart
│       │   ├── repositories/
│       │   │   └── ads_repository.dart
│       │   └── usecases/
│       │       └── get_active_ads_usecase.dart
│       └── presentation/
│           ├── bloc/
│           │   ├── ads_bloc.dart
│           │   ├── ads_event.dart
│           │   └── ads_state.dart
│           └── widgets/
│               └── ad_banner_widget.dart
│
├── shared/
│   ├── widgets/
│   │   ├── custom_button.dart
│   │   ├── custom_text_field.dart
│   │   ├── loading_overlay.dart
│   │   ├── error_view.dart
│   │   ├── empty_state_view.dart
│   │   ├── app_bar_widget.dart
│   │   └── confirmation_dialog.dart
│   │
│   └── models/
│       └── api_response.dart           # generic API response wrapper

assets/
├── images/
│   ├── logo.png
│   └── placeholder.png
├── icons/
│   └── .gitkeep
├── lottie/
│   └── .gitkeep
└── audio/
    └── alarm_default.mp3               # default alarm sound placeholder

figma_images/                           # Figma screen references (do NOT bundle in release build)
└── .gitkeep

test/
├── unit/
│   ├── auth/
│   ├── emergency/
│   ├── contacts/
│   └── location/
├── widget/
└── integration/
```

---

## STEP 5 — KEY FILE STUBS TO CREATE IMMEDIATELY

Create minimal but correctly structured stubs for all files in the structure above. Each stub should:
- Have the correct class/function signatures
- Include `// TODO: implement` markers where logic goes
- Be importable without errors (`flutter analyze` should pass)

### Priority stubs (create these first):
1. `core/network/api_client.dart` — Dio setup with interceptor hooks
2. `core/network/api_endpoints.dart` — all endpoint constants as `static const String`
3. `core/di/injection.dart` — GetIt locator setup
4. `core/router/app_router.dart` — GoRouter with all named routes stubbed
5. `core/router/app_routes.dart` — all route name constants
6. `core/services/alarm/alarm_service.dart` — stub with `triggerAlarm()` and `stopAlarm()`
7. `core/services/shake/shake_detection_service.dart` — stub with `startListening()`, `stopListening()`, `onShakeDetected` stream
8. `core/services/location/location_service.dart` — stub with `getCurrentLocation()`, `startTracking()`, `stopTracking()`
9. `core/services/calling/call_service.dart` — stub with `callEmergencyNumber(String number)`
10. All `*_bloc.dart`, `*_event.dart`, `*_state.dart` files with empty but valid BLoC skeletons
11. All screen files — empty `Scaffold` with correct class name and route-ready structure

---

## STEP 6 — API LAYER STRUCTURE (Ready for wiring later)

In `core/network/api_endpoints.dart`, stub out **all** endpoint constants:

```dart
class ApiEndpoints {
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
```

---

## STEP 7 — FIGMA SCREEN CONVERSION WORKFLOW

This is how you will work going forward when the developer provides screen images:

### Image Naming Convention
Images will be placed in `figma_images/` and named using this pattern:
```
[module][screen_name][number].png
```
Examples:
- `authwelcome1.png`
- `authregister1.png`
- `authotpverification1.png`
- `authsetupprofile1.png`
- `dashboardhome1.png`
- `emergencyactive1.png`
- `contactslist1.png`
- `settingsmain1.png`

however the names come, i will explain their arrangement, you just need to convert to the right pages following this prompt.

### The current available images
The onboarding, registration, login and dashboard pages are already created, you can find them in the `figma_images/` folder.

onboarding1.png to onboarding3.png are the onboarding pages.
onboardingRegistration1.png to onboardingRegistration2.png are the registration pages.
onboardingRegistrationSetup1.png to onboardingRegistrationSetup4.png are the successful setup process pages.
onboardingRegistrationSetup5.png to onboardingRegistrationSetup7.png are the failed setup process pages.
Login.png is the login page.
Dashboard.png is the dashboard page.



### Conversion Rules (apply to every screen)
When asked to convert a Figma image, follow this process:

1. **Analyse the image carefully** — identify layout, colors, fonts, spacing, component types
2. **Extract the color palette** → update `app_colors.dart` if new colors appear
3. **Build pixel-faithful Flutter UI** — use the existing widget structure
4. **Map UI components to shared widgets** — reuse `custom_button.dart`, `custom_text_field.dart`, etc. Create new shared widgets if a pattern repeats
5. **Wire navigation** using GoRouter named routes — use `context.pushNamed(AppRoutes.xxx)`
6. **Leave API calls as stubs** — call the relevant BLoC event, the BLoC will handle the rest later
7. **Responsive layout** — use `MediaQuery`, `LayoutBuilder`, or `flutter_screenutil` breakpoints to ensure it works on different screen sizes
8. **DO NOT hardcode strings** — all user-visible text goes in `app_strings.dart`
9. **DO NOT hardcode colors** — all colors reference `AppColors`

### First Batch — Welcome & Registration Screens
The following images are now in `figma_images/`:

> *(Developer will specify the filenames here when the first batch is ready.)*

For each image provided, create or update the corresponding screen file and any widgets it requires. Confirm what was built after each screen.

---

## STEP 8 — BUSINESS LOGIC RULES TO ENCODE

These rules come directly from the feature specification. Encode them as comments or validation logic inside the relevant service/BLoC files:

### Authentication
- Email must be unique (backend-enforced; show inline error)
- Username and profile photo are optional at registration — user can skip
- After successful email verification, user is auto-logged in
- Session persists until explicit logout

### Emergency Alert
- Alert must activate within **2 seconds** of trigger
- Shake trigger: default **3 shakes**, configurable
- Alarm must **override silent mode** and use **maximum volume**
- Alarm must work when: screen locked, app backgrounded, phone idle
- Alarm must play continuously until stopped
- Stop alarm is only accessible to the user who triggered it
- Emergency call must route within **3 seconds**
- Location sharing obeys the user's settings toggle — OFF = no sharing even in emergency

### Trusted Contacts
- Only registered app users can be added
- Notify the added person via push notification
- Prevent duplicate contacts
- Deleted contacts are immediately removed from alert routing

### Settings Compliance
- Every settings toggle must be **strictly obeyed** — no exceptions
- Location sharing OFF = location is never shared under any condition
- Alarm sound OFF = no alarm plays during emergency
- Call rerouting OFF = no call is made during emergency

---

## STEP 9 — GIT SETUP

Initialise a git repo and create a meaningful `.gitignore`:

```bash
git init
```

Ensure `.gitignore` includes:
```
# Flutter
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
build/
*.g.dart       # generated files — track only in version-pinned release

# Keys & Config
*.env
google-services.json
GoogleService-Info.plist
lib/core/config/app_config_local.dart

# Figma References (design only, not shipped)
figma_images/

# IDE
.idea/
.vscode/
*.iml
```

Create an initial commit:
```bash
git add .
git commit -m "chore: initialise RoamSafe Flutter project structure"
```

---

## ONGOING INSTRUCTIONS

- After every major task (initialisation, each screen conversion, each service stub), **summarise what was done and what is next**.
- If any package version has a conflict, resolve it and note what was changed.
- If a Figma screen image is ambiguous in any area (colour, layout, text), **ask before guessing**.
- Keep `flutter analyze` passing at all times — fix any warnings before reporting done.
- When the developer says *"screens ready: [list of filenames]"*, begin screen conversion immediately following Step 7.

---

**Begin now with Steps 1–6 and 9. Confirm completion of each step before moving to the next.**
