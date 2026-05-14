# ANTIGRAVITY AGENT PROMPT — ROAMSAFE: BACKGROUND SHAKE → APP FOREGROUND → AUTO DIALLER

---

## OVERVIEW

This session implements one focused flow:

> **When the user shakes the device 3 times (whether the app is open, backgrounded, or screen is locked):**
> 1. Alarm starts ringing
> 2. RoamSafe app is brought to the foreground
> 3. App navigates to `EmergencyActiveScreen`
> 4. Phone dialler opens automatically with the region-appropriate emergency number pre-filled

The core problem being solved is that Android restricts direct dialler access from a background service — the fix is to bring the app to the foreground first, then open the dialler from within the app context.

---

## CRITICAL REMINDERS

- **Read every file before touching it** — audit first, then implement
- **Do not overwrite `injection.dart`** — only append new registrations
- **Do not remove existing BLoC events, states, or service methods** — only add
- `flutter analyze` must pass with zero errors before reporting done
- All strings → `AppStrings`, all colors → `AppColors`
- Add `@pragma('vm:keep')` to every top-level function and class used by the background service

---

## STEP 1 — ADD NEW PACKAGE

In `pubspec.yaml`, add:

```yaml
android_intent_plus: ^5.0.0
```

Run `flutter pub get` after adding.

---

## STEP 2 — AUDIT EXISTING BACKGROUND SERVICE IMPLEMENTATION

Before making any changes, read these files and report what exists:
- `lib/main.dart`
- `core/services/shake/shake_detection_service.dart`
- `core/services/alarm/alarm_service.dart`
- `android/app/src/main/AndroidManifest.xml`
- Any file containing `FlutterBackgroundService`, `onBackgroundServiceStart`, or `ServiceInstance`
- `core/router/app_router.dart`
- `core/router/app_routes.dart`
- `core/di/injection.dart`
- `lib/features/dashboard/presentation/pages/emergency_active_screen.dart`

Report for each file:
- Does it exist?
- What is currently implemented?
- What is missing or likely broken?

Do not make any changes until the audit is complete and reported.

---

## STEP 3 — GLOBAL NAVIGATOR KEY

The background service needs to navigate the app without a `BuildContext`. This requires a global `NavigatorKey` passed to the router.

### 3A — Create the key

In `lib/main.dart` (or a dedicated `lib/core/router/navigator_key.dart` file), declare at the top level:

```dart
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
```

### 3B — Pass it to GoRouter

In `core/router/app_router.dart`, update the `GoRouter` instance:

```dart
final GoRouter appRouter = GoRouter(
  navigatorKey: navigatorKey,   // add this line
  // ... rest of existing config unchanged
);
```

### 3C — Pass it to MaterialApp

In `app.dart` or wherever `MaterialApp.router` is built, confirm `navigatorKey` is NOT needed there when using GoRouter — GoRouter manages it internally via the `navigatorKey` passed to `GoRouter`. No change needed to `MaterialApp.router`.

---

## STEP 4 — UPDATE `EmergencyActiveScreen`

### 4A — Add `autoCall` parameter

Update the screen to accept an `autoCall` flag. When `true`, the dialler opens automatically on screen load. When `false` (manual SOS tap), the user stays in control.

```dart
class EmergencyActiveScreen extends StatefulWidget {
  final bool autoCall;

  const EmergencyActiveScreen({
    super.key,
    this.autoCall = false,  // default false — safe for manual navigation
  });

  @override
  State<EmergencyActiveScreen> createState() => _EmergencyActiveScreenState();
}
```

### 4B — Auto-open dialler in `initState`

```dart
@override
void initState() {
  super.initState();
  if (widget.autoCall) {
    // Wait for widget tree to be fully built before opening dialler
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openDialler();
    });
  }
}
```

### 4C — `_openDialler()` method

```dart
Future<void> _openDialler() async {
  try {
    final numbers = sl<RegionService>().getEmergencyNumbers();
    final uri = Uri(scheme: 'tel', path: numbers.primary);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  } catch (e) {
    debugPrint('❌ Failed to open dialler: $e');
    // Fail silently — user can still manually tap the call buttons on screen
  }
}
```

### 4D — Ensure existing call buttons still work

The existing "Call 112" and "Call LASEMA" buttons must remain fully functional and unchanged. The auto-open dialler is an additional behaviour on top of them, not a replacement.

---

## STEP 5 — UPDATE ROUTER FOR `autoCall` FLAG

In `core/router/app_routes.dart`, confirm this route name exists (add if missing):

```dart
static const String emergencyActive = 'emergency-active';
```

In `core/router/app_router.dart`, update the `emergencyActive` route to read the `autoCall` extra:

```dart
GoRoute(
  name: AppRoutes.emergencyActive,
  path: '/emergency-active',
  builder: (context, state) {
    // extra is passed as bool — default false if not provided
    final autoCall = state.extra as bool? ?? false;
    return BlocProvider(
      create: (_) => sl<EmergencyBloc>(),
      child: EmergencyActiveScreen(autoCall: autoCall),
    );
  },
),
```

### Manual SOS button navigation (dashboard screen)
Wherever the SOS button on the dashboard navigates to `EmergencyActiveScreen`, pass `extra: false`:

```dart
context.pushNamed(AppRoutes.emergencyActive, extra: false);
```

---

## STEP 6 — UPDATE BACKGROUND SERVICE

This is the core of the fix. The background service must:
1. Trigger the alarm
2. Launch the app via Android Intent (brings app to foreground)
3. Send the in-app signal for when the app was already in foreground

### 6A — Update `onBackgroundServiceStart`

This must remain a **top-level function** with `@pragma('vm:keep')`. Update it as follows:

```dart
@pragma('vm:keep')
void onBackgroundServiceStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  final shakeService = ShakeDetectionService();
  shakeService.startListening();

  shakeService.onShakeDetected.listen((_) async {
    debugPrint('🚨 Background shake detected — triggering emergency');

    // Step 1: Trigger alarm immediately
    final alarmService = AlarmService();
    await alarmService.triggerAlarm();

    // Step 2: Bring app to foreground via Android Intent
    // This is required because Android does not allow opening the dialler
    // directly from a background service — we must go through the app first
    if (service is AndroidServiceInstance) {
      try {
        final intent = AndroidIntent(
          action: 'android.intent.action.MAIN',
          package: 'com.roamsafe.roamsafe',   // ← must match your applicationId exactly
          componentName: 'com.roamsafe.roamsafe.MainActivity',
          flags: <int>[
            Flag.FLAG_ACTIVITY_NEW_TASK,
            Flag.FLAG_ACTIVITY_SINGLE_TOP,
            Flag.FLAG_ACTIVITY_CLEAR_TOP,
          ],
        );
        await intent.launch();
        debugPrint('✅ App brought to foreground via intent');
      } catch (e) {
        debugPrint('❌ Intent launch failed: $e');
      }
    }

    // Step 3: Send signal to the app — received by the listener in app.dart
    // This triggers navigation to EmergencyActiveScreen with autoCall: true
    // Small delay to allow app to finish launching before receiving the signal
    await Future.delayed(const Duration(milliseconds: 600));
    service.invoke('emergency_triggered');
  });

  // Keep foreground service alive with periodic heartbeat
  Timer.periodic(const Duration(seconds: 30), (timer) {
    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: 'RoamSafe Active',
        content: 'Monitoring for emergency shake gesture',
      );
    }
  });
}
```

### 6B — Required imports for the background service file

```dart
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
```

---

## STEP 7 — LISTEN FOR BACKGROUND SERVICE SIGNAL IN APP

The `'emergency_triggered'` signal from the background service must be caught and acted on inside the running app. The best place is in the root widget (`app.dart` or `main.dart`) so it is always listening regardless of which screen is currently shown.

### 7A — Set up the listener

In `app.dart` (or wherever `RoamSafeApp` widget is defined), add the listener in `initState` of the root stateful widget:

```dart
@override
void initState() {
  super.initState();
  _listenForBackgroundEmergency();
}

void _listenForBackgroundEmergency() {
  FlutterBackgroundService().on('emergency_triggered').listen((_) {
    debugPrint('📱 Emergency signal received — navigating to EmergencyActiveScreen');
    _navigateToEmergency();
  });
}

void _navigateToEmergency() {
  // Use the global navigator key to navigate without BuildContext
  // removeWhere removes all routes below so user cannot go back
  navigatorKey.currentContext?.goNamed(
    AppRoutes.emergencyActive,
    extra: true,  // autoCall: true — dialler opens automatically
  );
}
```

If `navigatorKey.currentContext` is null (app just launched via intent and context isn't ready yet), retry after a short delay:

```dart
void _navigateToEmergency() {
  final context = navigatorKey.currentContext;
  if (context == null) {
    // App just launched — wait for context to be ready
    Future.delayed(const Duration(milliseconds: 800), _navigateToEmergency);
    return;
  }
  context.goNamed(AppRoutes.emergencyActive, extra: true);
}
```

### 7B — Cancel the listener on dispose

```dart
StreamSubscription? _emergencySubscription;

void _listenForBackgroundEmergency() {
  _emergencySubscription = FlutterBackgroundService()
      .on('emergency_triggered')
      .listen((_) => _navigateToEmergency());
}

@override
void dispose() {
  _emergencySubscription?.cancel();
  super.dispose();
}
```

---

## STEP 8 — ANDROID MANIFEST VERIFICATION

Re-check `android/app/src/main/AndroidManifest.xml` and confirm ALL of the following are present. Add any that are missing:

```xml
<!-- Permissions -->
<uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_DATA_SYNC"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.CALL_PHONE"/>

<!-- Inside <application> tag: background service -->
<service
    android:name="id.flutter.flutter_background_service.BackgroundService"
    android:foregroundServiceType="dataSync"
    android:exported="false"/>

<!-- Inside <application> tag: boot receiver -->
<receiver
    android:name="id.flutter.flutter_background_service.BootReceiver"
    android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
    </intent-filter>
</receiver>

<!-- MainActivity must handle single top launches correctly -->
<!-- Confirm android:launchMode is singleTop or singleTask on MainActivity -->
<activity
    android:name=".MainActivity"
    android:launchMode="singleTop"
    ... >
```

The `singleTop` launch mode on `MainActivity` is important — it prevents a new instance of the app being created on top of an existing one when the intent fires.

---

## STEP 9 — PROGUARD RULES (release build protection)

Confirm `android/app/proguard-rules.pro` exists and contains:

```
-keep class id.flutter.flutter_background_service.** { *; }
-keep class dev.fluttercommunity.workmanager.** { *; }
-keep class com.plugin.flutter.android_intent_plus.** { *; }
-dontwarn id.flutter.flutter_background_service.**
-dontwarn com.plugin.flutter.android_intent_plus.**
```

Confirm `android/app/build.gradle.kts` release build type references it:

```kotlin
buildTypes {
    release {
        signingConfig = signingConfigs.getByName("debug")
        isMinifyEnabled = true
        proguardFiles(
            getDefaultProguardFile("proguard-android-optimize.txt"),
            "proguard-rules.pro"
        )
    }
}
```

---

## STEP 10 — REGISTRATION IN `injection.dart`

Confirm `RegionService` is registered. If it is not yet registered from a previous session, add it now. Do NOT remove any existing registrations:

```dart
sl.registerLazySingleton<RegionService>(() => RegionService(sl<SharedPreferences>()));
```

---

## EXPECTED FULL FLOW AFTER IMPLEMENTATION

### App in foreground
1. Shake detected by `ShakeDetectionService` (running in background service)
2. `AlarmService.triggerAlarm()` called
3. `service.invoke('emergency_triggered')` fires
4. Listener in `app.dart` receives signal
5. `context.goNamed(AppRoutes.emergencyActive, extra: true)` called
6. `EmergencyActiveScreen` loads with `autoCall: true`
7. `addPostFrameCallback` fires `_openDialler()`
8. Dialler opens with region emergency number

### App in background / screen locked
1. Shake detected by background service
2. `AlarmService.triggerAlarm()` called — alarm rings
3. `AndroidIntent` launches app via `FLAG_ACTIVITY_NEW_TASK`
4. App comes to foreground
5. After 600ms delay, `service.invoke('emergency_triggered')` fires
6. Listener in `app.dart` receives signal — retries if context not ready
7. `context.goNamed(AppRoutes.emergencyActive, extra: true)` called
8. `EmergencyActiveScreen` loads with `autoCall: true`
9. Dialler opens with region emergency number

---

## CHECKLIST BEFORE REPORTING DONE

- [ ] `android_intent_plus: ^5.0.0` added to `pubspec.yaml`
- [ ] `flutter pub get` run successfully
- [ ] `navigatorKey` declared at top level and passed to `GoRouter`
- [ ] `EmergencyActiveScreen` accepts `autoCall` bool parameter
- [ ] `autoCall: true` triggers `_openDialler()` via `addPostFrameCallback`
- [ ] `_openDialler()` reads number from `RegionService` — no hardcoded numbers
- [ ] Router passes `state.extra as bool?` to `EmergencyActiveScreen`
- [ ] Manual SOS button passes `extra: false`
- [ ] Background service uses `AndroidIntent` with correct package name `com.roamsafe.roamsafe`
- [ ] Background service sends `emergency_triggered` signal after 600ms delay
- [ ] Root widget listens for `emergency_triggered` and navigates with `extra: true`
- [ ] Listener retries navigation if `navigatorKey.currentContext` is null
- [ ] `MainActivity` has `android:launchMode="singleTop"` in AndroidManifest
- [ ] All background service functions have `@pragma('vm:keep')`
- [ ] ProGuard rules include `android_intent_plus`
- [ ] `RegionService` is registered in `injection.dart`
- [ ] Existing call buttons on `EmergencyActiveScreen` still work
- [ ] `flutter analyze` passes — zero errors
- [ ] No existing DI registrations removed
