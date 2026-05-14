# ANTIGRAVITY AGENT PROMPT — ROAMSAFE: MASTER SESSION
## Shake-to-SOS Fix + Live Location + Region-Based Emergency Numbers

---

## OVERVIEW OF THIS SESSION

Four interconnected tasks in priority order:

1. **AUDIT & FIX** the existing shake-to-SOS + background service implementation — it failed on a release APK
2. **IMPLEMENT** live GPS location using `geolocator` (stream-based, updates as user moves)
3. **UPDATE** the Location screen to display real coordinates
4. **IMPLEMENT** region detection + dynamic emergency dial numbers based on user's current country/state

Work through them in this exact order. Complete and verify each before moving to the next.

---

## TASK 1 — AUDIT & FIX: SHAKE-TO-SOS + BACKGROUND SERVICE

### What should happen (expected behaviour)
- User shakes device 3 times in quick succession
- Whether app is in foreground, background, or screen is locked:
  - Alarm begins ringing immediately (overrides silent mode)
  - App navigates to `EmergencyActiveScreen`
  - Phone dialler opens automatically with the region-appropriate emergency number pre-filled
- This must work on a **release APK** installed on a physical Android device

### Step 1A — Audit the existing codebase

Read every file related to shake and background service before touching anything:
- `core/services/shake/shake_detection_service.dart`
- `core/services/alarm/alarm_service.dart`
- `lib/main.dart`
- `android/app/src/main/AndroidManifest.xml`
- `android/app/build.gradle.kts`
- Any file referencing `flutter_background_service`, `WorkManager`, or `FlutterBackgroundService`
- `pubspec.yaml`

Report exactly what exists, what is missing, and what is likely wrong before making any changes.

### Step 1B — Common failure points to check (check ALL of these)

#### AndroidManifest.xml — missing or wrong declarations
The following must ALL be present. Check each one:

```xml
<!-- Required permissions -->
<uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_DATA_SYNC"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>

<!-- Background service declaration (inside <application> tag) -->
<service
    android:name="id.flutter.flutter_background_service.BackgroundService"
    android:foregroundServiceType="dataSync"
    android:exported="false"/>

<!-- Boot receiver to restart service after device reboot -->
<receiver
    android:name="id.flutter.flutter_background_service.BootReceiver"
    android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
    </intent-filter>
</receiver>
```

#### Release build — ProGuard/R8 stripping background service classes
In `android/app/proguard-rules.pro` (create if it doesn't exist), add:

```
-keep class id.flutter.flutter_background_service.** { *; }
-keep class dev.fluttercommunity.workmanager.** { *; }
-dontwarn id.flutter.flutter_background_service.**
```

Then in `android/app/build.gradle.kts`, confirm release build type has:
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

#### `flutter_background_service` initialisation — must happen in `main.dart` BEFORE `runApp()`
The service must be initialised at app start, not lazily. Check `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initBackgroundService();   // must be here before runApp
  configureDependencies();
  runApp(const RoamSafeApp());
}

Future<void> _initBackgroundService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onBackgroundServiceStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: 'roamsafe_background',
      initialNotificationTitle: 'RoamSafe Active',
      initialNotificationContent: 'Monitoring for emergency shake gesture',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onBackgroundServiceStart,
      onBackground: onIosBackground,
    ),
  );
  await service.startService();
}
```

#### Background service entry point — must be a TOP-LEVEL function (not inside a class)
```dart
// This MUST be a top-level function — Flutter isolates cannot access class methods
@pragma('vm:keep')   // CRITICAL: prevents R8/ProGuard from stripping in release builds
void onBackgroundServiceStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  // Set up shake detection
  final shakeService = ShakeDetectionService();
  shakeService.startListening();

  shakeService.onShakeDetected.listen((_) async {
    // Trigger alarm
    final alarmService = AlarmService();
    await alarmService.triggerAlarm();

    // Send signal to UI to navigate to EmergencyActiveScreen
    service.invoke('emergency_triggered');

    // Open dialler with emergency number
    // Read saved region emergency number from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final emergencyNumber = prefs.getString('emergency_number') ?? '112';
    final uri = Uri(scheme: 'tel', path: emergencyNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  });

  // Keep service alive
  Timer.periodic(const Duration(seconds: 30), (timer) {
    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: 'RoamSafe Active',
        content: 'Monitoring for emergency shake gesture',
      );
    }
  });
}

@pragma('vm:keep')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}
```

**The `@pragma('vm:keep')` annotation is mandatory** — without it, release builds with tree-shaking will strip these top-level functions and the background service silently fails.

#### UI listening for background service events
In `app.dart` or a root widget, listen for the `'emergency_triggered'` event from the background service and navigate:

```dart
FlutterBackgroundService().on('emergency_triggered').listen((_) {
  // Navigate to emergency active screen
  // Use a global navigator key since we may not have context
  navigatorKey.currentState?.pushNamedAndRemoveUntil(
    '/emergency-active', (route) => false
  );
});
```

Add a `GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();` and pass it to `MaterialApp`/`GoRouter`.

#### Shake detection in release — sensors_plus needs `@pragma('vm:keep')`
If `ShakeDetectionService` uses accelerometer streams inside a class, the class itself needs the keep annotation if instantiated from a background isolate:

```dart
@pragma('vm:keep')
class ShakeDetectionService { ... }
```

#### Minimum shake threshold tuning
If the threshold was too high or too low it won't trigger reliably on physical devices. Use these tested values:

```dart
static const double _shakeThreshold = 12.0;  // m/s² above gravity
static const int _minShakeCount = 3;
static const int _shakeWindowMs = 1500;       // 3 shakes within 1.5 seconds
```

Reset `_shakeCount` to 0 if `_shakeWindowMs` passes without reaching `_minShakeCount`.

### Step 1C — Emulator testing note
Shake cannot be physically simulated on an emulator. Use Android Studio's emulator:
Extended Controls (three dots) → Virtual Sensors → move the X/Y/Z sliders rapidly back and forth at least 3 times quickly. This is the only way to test shake on emulator. For reliable real-device testing, build a debug APK (`flutter build apk --debug`) and install on a physical device — shake testing works in debug on a real device.

---

## TASK 2 — LIVE GPS LOCATION (geolocator stream)

### Package status
`geolocator: ^11.0.0` is already in `pubspec.yaml`. No new package needed.

Also add `geocoding` for reverse geocoding (country/state from coordinates):

```yaml
geocoding: ^3.0.0
```

Run `flutter pub get` after adding.

### Implementation in `LocationService`

Replace any existing stub with this full implementation:

```dart
import 'package:geolocator/geolocator.dart';

@pragma('vm:keep')
@lazySingleton
class LocationService {
  StreamSubscription<Position>? _positionSubscription;
  final _positionController = StreamController<Position>.broadcast();

  Stream<Position> get positionStream => _positionController.stream;
  Position? _lastPosition;
  Position? get lastPosition => _lastPosition;

  /// Call once on app start to check/request permissions
  Future<bool> requestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }
    if (permission == LocationPermission.deniedForever) return false;
    return true;
  }

  /// Get a single current position
  Future<Position?> getCurrentPosition() async {
    final hasPermission = await requestPermission();
    if (!hasPermission) return null;
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// Start streaming position updates
  /// Emits a new position every time user moves more than [distanceFilter] metres
  void startTracking({double distanceFilter = 10.0}) {
    _positionSubscription?.cancel();
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilter.toInt(), // metres
      ),
    ).listen((position) {
      _lastPosition = position;
      _positionController.add(position);
    });
  }

  void stopTracking() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  /// Format position for display
  static String formatCoordinates(Position position) {
    final lat = position.latitude.toStringAsFixed(4);
    final lng = position.longitude.toStringAsFixed(4);
    final latDir = position.latitude >= 0 ? 'N' : 'S';
    final lngDir = position.longitude >= 0 ? 'E' : 'W';
    return 'LAT:${lat}$latDir | LONG:${lng}$lngDir';
  }

  void dispose() {
    _positionSubscription?.cancel();
    _positionController.close();
  }
}
```

### LocationBloc updates

Add to `LocationState`:
```dart
class LocationLoaded extends LocationState {
  final Position? currentPosition;
  final String formattedCoordinates;
  final bool isSharing;
  final List<LocationHistoryEntry> history;
  ...
}
```

Add events:
```dart
class StartLocationTrackingEvent extends LocationEvent {}
class StopLocationTrackingEvent extends LocationEvent {}
class LocationUpdatedEvent extends LocationEvent {
  final Position position;
  ...
}
```

In `LocationBloc`, subscribe to `LocationService.positionStream` and dispatch `LocationUpdatedEvent` on each emission. The bloc then updates `currentPosition` and `formattedCoordinates` in state. The UI rebuilds via `BlocBuilder` — no manual polling needed.

### Update Location Screen

Replace the hardcoded placeholder with a `BlocBuilder`:

```dart
BlocBuilder<LocationBloc, LocationState>(
  builder: (context, state) {
    final coords = state is LocationLoaded
        ? state.formattedCoordinates
        : 'Acquiring location...';
    return Text(
      coords,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  },
)
```

### Update Emergency Active Screen

Same pattern — replace hardcoded coordinates with `BlocBuilder<LocationBloc, LocationState>`.

Also update "Last ping" to show actual time:
```dart
// Store last update time in LocationBloc state
final String lastPing; // e.g. "4s ago"
```

Calculate with:
```dart
final diff = DateTime.now().difference(state.lastUpdated);
final ping = diff.inSeconds < 60 ? '${diff.inSeconds}s ago' : '${diff.inMinutes}m ago';
```

### Start tracking on app launch

In `main.dart` (after `configureDependencies()`):
```dart
// Start location tracking immediately on app start
sl<LocationBloc>().add(StartLocationTrackingEvent());
```

Or start it after successful login in the auth flow — whichever makes more sense for the UX.

---

## TASK 3 — REGION-BASED EMERGENCY NUMBERS

### How it works
On app start (or after login), use `geolocator` to get current position, then use `geocoding` to reverse-geocode into a country and (for Nigeria) a state. Look up the emergency numbers for that region and save them to `SharedPreferences`. The rest of the app reads from SharedPreferences — no need to re-detect on every screen.

### New service: `RegionService`

Create `core/services/region/region_service.dart`:

```dart
@pragma('vm:keep')
@lazySingleton
class RegionService {
  static const String _emergencyNumberKey = 'emergency_number';
  static const String _secondaryEmergencyNameKey = 'secondary_emergency_name';
  static const String _secondaryEmergencyNumberKey = 'secondary_emergency_number';
  static const String _countryKey = 'detected_country';
  static const String _regionKey = 'detected_region';

  final SharedPreferences _prefs;
  RegionService(this._prefs);

  Future<void> detectAndSaveRegion() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low, // low accuracy is fine for country detection
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) return;

      final place = placemarks.first;
      final country = place.country ?? '';
      final isoCountry = place.isoCountryCode ?? '';
      final adminArea = place.administrativeArea ?? ''; // state/region

      await _prefs.setString(_countryKey, country);
      await _prefs.setString(_regionKey, adminArea);

      final numbers = _getEmergencyNumbers(isoCountry, adminArea);
      await _prefs.setString(_emergencyNumberKey, numbers.primary);
      await _prefs.setString(_secondaryEmergencyNameKey, numbers.secondaryName);
      await _prefs.setString(_secondaryEmergencyNumberKey, numbers.secondary);

    } catch (e) {
      // Fallback to international defaults if detection fails
      await _prefs.setString(_emergencyNumberKey, '112');
      await _prefs.setString(_secondaryEmergencyNameKey, 'Local Emergency');
      await _prefs.setString(_secondaryEmergencyNumberKey, '911');
    }
  }

  EmergencyNumbers getEmergencyNumbers() {
    return EmergencyNumbers(
      primary: _prefs.getString(_emergencyNumberKey) ?? '112',
      secondaryName: _prefs.getString(_secondaryEmergencyNameKey) ?? 'Local Emergency',
      secondary: _prefs.getString(_secondaryEmergencyNumberKey) ?? '911',
    );
  }

  EmergencyNumbers _getEmergencyNumbers(String isoCountry, String adminArea) {
    switch (isoCountry.toUpperCase()) {

      // ── NIGERIA ──────────────────────────────────────────────
      case 'NG':
        final state = adminArea.toLowerCase();
        // Lagos
        if (state.contains('lagos')) {
          return EmergencyNumbers(primary: '112', secondaryName: 'LASEMA', secondary: '767');
        }
        // Abuja (FCT)
        if (state.contains('abuja') || state.contains('federal capital')) {
          return EmergencyNumbers(primary: '112', secondaryName: 'AESA', secondary: '112');
        }
        // Kano
        if (state.contains('kano')) {
          return EmergencyNumbers(primary: '112', secondaryName: 'Kano Emergency', secondary: '080-3960-2601');
        }
        // Rivers (Port Harcourt)
        if (state.contains('rivers')) {
          return EmergencyNumbers(primary: '112', secondaryName: 'Rivers Emergency', secondary: '112');
        }
        // Oyo (Ibadan)
        if (state.contains('oyo')) {
          return EmergencyNumbers(primary: '112', secondaryName: 'Oyo Emergency', secondary: '112');
        }
        // Ogun
        if (state.contains('ogun')) {
          return EmergencyNumbers(primary: '112', secondaryName: 'Ogun Emergency', secondary: '112');
        }
        // Anambra
        if (state.contains('anambra')) {
          return EmergencyNumbers(primary: '112', secondaryName: 'Anambra Emergency', secondary: '112');
        }
        // Delta
        if (state.contains('delta')) {
          return EmergencyNumbers(primary: '112', secondaryName: 'Delta Emergency', secondary: '112');
        }
        // Default Nigeria
        return EmergencyNumbers(primary: '112', secondaryName: 'NEMA', secondary: '0800-CALLNEMA');

      // ── UNITED KINGDOM ───────────────────────────────────────
      case 'GB':
        return EmergencyNumbers(primary: '999', secondaryName: 'NHS 111', secondary: '111');

      // ── UNITED STATES ────────────────────────────────────────
      case 'US':
        return EmergencyNumbers(primary: '911', secondaryName: 'Non-Emergency', secondary: '311');

      // ── EUROPE ───────────────────────────────────────────────
      case 'DE': // Germany
        return EmergencyNumbers(primary: '112', secondaryName: 'Police', secondary: '110');
      case 'FR': // France
        return EmergencyNumbers(primary: '15', secondaryName: 'Police', secondary: '17');
      case 'IT': // Italy
        return EmergencyNumbers(primary: '118', secondaryName: 'Police', secondary: '113');
      case 'ES': // Spain
        return EmergencyNumbers(primary: '112', secondaryName: 'Police', secondary: '091');
      case 'NL': // Netherlands
        return EmergencyNumbers(primary: '112', secondaryName: 'Non-Emergency', secondary: '0900-8844');
      case 'BE': // Belgium
        return EmergencyNumbers(primary: '112', secondaryName: 'Police', secondary: '101');
      case 'SE': // Sweden
        return EmergencyNumbers(primary: '112', secondaryName: 'Non-Emergency', secondary: '11414');
      case 'NO': // Norway
        return EmergencyNumbers(primary: '113', secondaryName: 'Police', secondary: '112');
      case 'DK': // Denmark
        return EmergencyNumbers(primary: '112', secondaryName: 'Non-Emergency', secondary: '114');
      case 'PL': // Poland
        return EmergencyNumbers(primary: '112', secondaryName: 'Police', secondary: '997');
      case 'PT': // Portugal
        return EmergencyNumbers(primary: '112', secondaryName: 'Police', secondary: '112');
      case 'CH': // Switzerland
        return EmergencyNumbers(primary: '144', secondaryName: 'Police', secondary: '117');
      case 'AT': // Austria
        return EmergencyNumbers(primary: '144', secondaryName: 'Police', secondary: '133');
      case 'IE': // Ireland
        return EmergencyNumbers(primary: '999', secondaryName: 'Alternative', secondary: '112');

      // ── AFRICA ───────────────────────────────────────────────
      case 'GH': // Ghana
        return EmergencyNumbers(primary: '999', secondaryName: 'Ambulance', secondary: '193');
      case 'KE': // Kenya
        return EmergencyNumbers(primary: '999', secondaryName: 'Ambulance', secondary: '1199');
      case 'ZA': // South Africa
        return EmergencyNumbers(primary: '10111', secondaryName: 'Ambulance', secondary: '10177');
      case 'EG': // Egypt
        return EmergencyNumbers(primary: '123', secondaryName: 'Police', secondary: '122');
      case 'ET': // Ethiopia
        return EmergencyNumbers(primary: '911', secondaryName: 'Police', secondary: '991');

      // ── AMERICAS ─────────────────────────────────────────────
      case 'CA': // Canada
        return EmergencyNumbers(primary: '911', secondaryName: 'Non-Emergency', secondary: '311');
      case 'MX': // Mexico
        return EmergencyNumbers(primary: '911', secondaryName: 'Red Cross', secondary: '065');
      case 'BR': // Brazil
        return EmergencyNumbers(primary: '190', secondaryName: 'Ambulance', secondary: '192');
      case 'AR': // Argentina
        return EmergencyNumbers(primary: '911', secondaryName: 'Fire', secondary: '100');

      // ── ASIA-PACIFIC ─────────────────────────────────────────
      case 'AU': // Australia
        return EmergencyNumbers(primary: '000', secondaryName: 'Non-Emergency', secondary: '131 444');
      case 'IN': // India
        return EmergencyNumbers(primary: '112', secondaryName: 'Ambulance', secondary: '108');
      case 'JP': // Japan
        return EmergencyNumbers(primary: '119', secondaryName: 'Police', secondary: '110');
      case 'CN': // China
        return EmergencyNumbers(primary: '120', secondaryName: 'Police', secondary: '110');
      case 'SG': // Singapore
        return EmergencyNumbers(primary: '995', secondaryName: 'Police', secondary: '999');
      case 'AE': // UAE
        return EmergencyNumbers(primary: '998', secondaryName: 'Police', secondary: '999');
      case 'SA': // Saudi Arabia
        return EmergencyNumbers(primary: '911', secondaryName: 'Police', secondary: '999');
      case 'PK': // Pakistan
        return EmergencyNumbers(primary: '115', secondaryName: 'Police', secondary: '15');
      case 'NZ': // New Zealand
        return EmergencyNumbers(primary: '111', secondaryName: 'Non-Emergency', secondary: '105');

      // ── INTERNATIONAL FALLBACK ────────────────────────────────
      default:
        return EmergencyNumbers(primary: '112', secondaryName: 'Local Emergency', secondary: '911');
    }
  }
}

class EmergencyNumbers {
  final String primary;          // e.g. "112"
  final String secondaryName;   // e.g. "LASEMA"
  final String secondary;       // e.g. "767"

  const EmergencyNumbers({
    required this.primary,
    required this.secondaryName,
    required this.secondary,
  });
}
```

### Register `RegionService` in `injection.dart`

```dart
// SharedPreferences must be registered first
final prefs = await SharedPreferences.getInstance();
sl.registerSingleton<SharedPreferences>(prefs);

// Then RegionService
sl.registerLazySingleton<RegionService>(() => RegionService(sl<SharedPreferences>()));
```

Note: `injection.dart` initialisation must be `async` if it isn't already since `SharedPreferences.getInstance()` is async.

### Call region detection on app start

In `main.dart`:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initBackgroundService();
  await configureDependencies();           // must be async
  
  // Detect region silently in background — don't block app launch
  sl<RegionService>().detectAndSaveRegion().catchError((_) {
    // Fail silently — fallback numbers are already set in detectAndSaveRegion
  });

  runApp(const RoamSafeApp());
}
```

### Update Emergency Active Screen — dynamic dial buttons

Replace hardcoded "Call 112" / "Call LASEMA" with:

```dart
// In initState or build
final _numbers = sl<RegionService>().getEmergencyNumbers();

// Then in build:
Row(
  children: [
    Expanded(
      child: _buildCallButton(
        _numbers.primary,
        'Call ${_numbers.primary}',
      ),
    ),
    const SizedBox(width: 16),
    Expanded(
      child: _buildCallButton(
        _numbers.secondary,
        'Call ${_numbers.secondaryName}',
      ),
    ),
  ],
)
```

### Update background service shake handler

In `onBackgroundServiceStart`, replace hardcoded `'112'` with the SharedPreferences value (which was saved by `RegionService`):

```dart
final prefs = await SharedPreferences.getInstance();
final emergencyNumber = prefs.getString('emergency_number') ?? '112';
```

This is already in the Task 1 implementation above — just confirming it must use the same key (`'emergency_number'`) as `RegionService`.

---

## DEPENDENCY INJECTION — FULL UPDATED REGISTRATION

Update `core/di/injection.dart` to include ALL of the following. Preserve all existing registrations — only append new ones:

```dart
Future<void> configureDependencies() async {
  // ── Core ─────────────────────────────────
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);

  // ── Services ─────────────────────────────
  sl.registerLazySingleton<AlarmService>(() => AlarmService());
  sl.registerLazySingleton<CallService>(() => CallService());
  sl.registerLazySingleton<ShakeDetectionService>(() => ShakeDetectionService());
  sl.registerLazySingleton<LocationService>(() => LocationService());
  sl.registerLazySingleton<RegionService>(() => RegionService(sl()));

  // ── Repositories ─────────────────────────
  sl.registerLazySingleton<ContactsRepository>(() => ContactsRepositoryImpl());
  sl.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl(sl()));

  // ── Use Cases ────────────────────────────
  sl.registerLazySingleton(() => GetContactsUsecase(sl()));
  sl.registerLazySingleton(() => AddContactUsecase(sl()));
  sl.registerLazySingleton(() => RemoveContactUsecase(sl()));

  // ── BLoCs ────────────────────────────────
  sl.registerFactory<ContactsBloc>(() => ContactsBloc(
    getContactsUsecase: sl(),
    addContactUsecase: sl(),
    removeContactUsecase: sl(),
  ));
  sl.registerFactory<EmergencyBloc>(() => EmergencyBloc(
    alarmService: sl(),
    callService: sl(),
    locationService: sl(),
    settingsRepository: sl(),
  ));
  sl.registerFactory<LocationBloc>(() => LocationBloc(
    locationService: sl(),
  ));
  sl.registerFactory<SettingsBloc>(() => SettingsBloc(
    settingsRepository: sl(),
  ));
}
```

---

## pubspec.yaml — ADD THIS PACKAGE

```yaml
geocoding: ^3.0.0
```

Run `flutter pub get` after adding.

---

## CHECKLIST BEFORE REPORTING DONE

### Shake / Background Service
- [ ] `@pragma('vm:keep')` on `onBackgroundServiceStart`, `onIosBackground`, `ShakeDetectionService`
- [ ] AndroidManifest has foreground service declaration with `foregroundServiceType="dataSync"`
- [ ] AndroidManifest has BOOT_COMPLETED receiver
- [ ] `proguard-rules.pro` exists with background service keep rules
- [ ] Release build has `isMinifyEnabled = true` and references proguard file
- [ ] Background service initialised in `main()` before `runApp()`
- [ ] Service entry point is a top-level function, not a class method
- [ ] Shake threshold is `12.0` with 3-shake window of 1500ms
- [ ] Shake triggers: alarm + navigation signal + dialler open
- [ ] Emergency number in dialler comes from SharedPreferences (set by RegionService)

### Live Location
- [ ] `LocationService.startTracking()` uses `getPositionStream()` with `distanceFilter: 10`
- [ ] `LocationBloc` subscribes to position stream and updates state on each emission
- [ ] Emergency Active Screen shows real coordinates from `LocationBloc`
- [ ] Location Screen shows real coordinates from `LocationBloc`
- [ ] "Last ping" shows relative time since last position update
- [ ] Location tracking starts on app launch

### Region Detection
- [ ] `geocoding: ^3.0.0` added to pubspec
- [ ] `RegionService` created and registered in DI
- [ ] `detectAndSaveRegion()` called on app start (non-blocking)
- [ ] Emergency Active Screen reads numbers from `RegionService` — no hardcoded "112"/"LASEMA"
- [ ] Background service shake handler reads emergency number from SharedPreferences
- [ ] Nigerian states all resolve correctly (Lagos → LASEMA, FCT → AESA, etc.)
- [ ] International fallback is `112` / `911`

### General
- [ ] `flutter analyze` passes — zero errors
- [ ] All new classes registered in `injection.dart`
- [ ] No existing DI registrations removed or overwritten
- [ ] `configureDependencies()` is now `async` and awaited in `main()`
