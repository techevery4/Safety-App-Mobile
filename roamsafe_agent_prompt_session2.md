# ANTIGRAVITY AGENT PROMPT — ROAMSAFE: EMERGENCY ACTIVE + LOCATION + SETTINGS

---

## CONTEXT

You are continuing work on the RoamSafe Flutter project. The folder structure, BLoC setup, services, and routing are already in place from the previous session. Three new screens are being implemented in this session:

1. **`dashboard2.png`** → `emergency_active_screen.dart` — the screen shown when the SOS button is triggered
2. **`location1.png`** → `location_sharing_screen.dart` — the Share Location page
3. **`settings_main.png`** → `settings_screen.dart` — the parent Settings page with live toggles

All three Figma reference images are in `figma_images/` as:
- `figma_images/dashboard2.png`
- `figma_images/location1.png`
- `figma_images/settings1.png - figma_images/settings5.png`

Before starting the screen work, add this to pubspec.yaml and run flutter pub get:

  flutter_background_service: ^5.0.5

Then in the AlarmService and ShakeDetectionService, wrap them in a 
flutter_background_service foreground service so they continue working 
when the app is backgrounded or the screen is locked. The foreground 
service should show a persistent notification: "RoamSafe is active in 
the background" with a Stop action. This is required for Android — 
iOS handles background audio differently via audio_session which is 
already configured.

---

## GENERAL RULES (apply to all three screens)

- Match the Figma designs pixel-faithfully — colors, spacing, layout, typography
- All colors must reference `AppColors`, all strings must go in `AppStrings`
- Navigation uses GoRouter named routes via `context.goNamed(AppRoutes.xxx)`
- **Google Maps / GPS coordinates are skipped for now** — display hardcoded placeholder strings (`LAT:--.- |LONG:--.-`) wherever coordinates appear. Leave a `// TODO: replace with real GPS data` comment
- **No payment or subscription features** — skip anything requiring paid APIs
- All service calls must go through the existing BLoC layer — UI never calls services directly
- Run `flutter analyze` and fix all warnings before reporting done

---

## SCREEN 1 — Emergency Active Screen (`emergency_active_screen.dart`)

**File location:** `lib/features/dashboard/presentation/pages/emergency_active_screen.dart`
**Figma reference:** `figma_images/dashboard2.png`

### Layout (top to bottom)
1. **Red alert banner** — full width, red background (`AppColors.error` or `Color(0xFFE53935)`), white dot icon + text "Emergency Alert is Active", slightly rounded
2. **Location sharing active banner** — slightly smaller, red/salmon background, location pin icon, two lines: "Live location sharing is active" and "Your coordinates are being sent to your trusted contacts."
3. **"Live Coordinates" label** — left-aligned section header
4. **Coordinates row** — bold text `LAT:--.- |LONG:--.-`, below it smaller grey text "Last ping: --s ago" — hardcoded placeholders, `// TODO: real GPS`
5. **Two call buttons side by side** — equal width, light grey/teal-tinted card background, phone icon above text. Left: "Call 112", Right: "Call LASEMA". Teal border, rounded corners
6. **"Emergency Contacts" section header** with "View All" link on the right
7. **Emergency contacts list** — each row: avatar with initials (coloured circle), name, email, phone call icon on right. Show up to 3 contacts, pull from `ContactsBloc` state
8. **"Stop Emergency Alert" button** — full width, teal, at the bottom (`AppColors.primary`)

### Functionality to implement

#### Call Feature
Use `url_launcher` to make calls. Implement in `core/services/calling/call_service.dart`:

```dart
Future<void> call(String number) async {
  final uri = Uri(scheme: 'tel', path: number);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  }
}
```

- "Call 112" button → calls `CallService.call('112')`
- "Call LASEMA" button → calls `CallService.call('767')` // LASEMA Lagos emergency number
- Emergency contact call icon → calls `CallService.call(contact.phone)` if phone exists, else shows snackbar "No phone number available"

#### Alarm
On screen init, trigger `AlarmService.triggerAlarm()` if not already active (check `EmergencyBloc` state). The alarm should already be playing from when SOS was triggered on the dashboard — this screen just displays the active state.

#### Stop Emergency Alert button
Dispatches `StopEmergencyEvent` to `EmergencyBloc` which must:
1. Call `AlarmService.stopAlarm()`
2. Call `EmergencyRepository.cancelEmergency()` (stubbed — `// TODO: API`)
3. Navigate back to dashboard via `context.goNamed(AppRoutes.dashboard)`
4. Update safety status indicator back to SAFE

#### Location sharing banner
Reads from `LocationBloc` state — if location sharing is active, show the banner. Hardcode coordinate display for now.

#### "View All" contacts link
Navigates to `context.goNamed(AppRoutes.contacts)`

### Navigation
This screen is pushed when SOS is triggered. It must **not** be dismissible by back button during active emergency — override `PopScope`:

```dart
PopScope(
  canPop: false,
  child: Scaffold(...),
)
```

---

## SCREEN 2 — Share Location Screen (`location_sharing_screen.dart`)

**File location:** `lib/features/location/presentation/pages/location_sharing_screen.dart`
**Figma reference:** `figma_images/location1.png`

### Layout (top to bottom)
1. **App bar** — back arrow on left, title "Share Location" centered
2. **"Your Live Coordinates" label** — section header
3. **Coordinates chip** — outlined pill/chip shape, location pin icon on left, text `LAT:--.- N|LONG:--.- W` — hardcoded placeholder, `// TODO: real GPS`
4. **Red info banner** — light red/salmon background, red dot on left, text: "Your real time coordinates will be sent to all your trusted contacts. This will allow them follow your movement until you stop sharing." Rounded card, no border
5. **"Recipients" section header**
6. **Avatar stack row** — overlapping circular avatars (show up to 5, then "+N" text for overflow). Pull from `ContactsBloc`. Use initials-based coloured avatars as fallback if no photo
7. **"Location Share History" section header**
8. **History list** — each row: circular avatar with photo/initials, name on top, coordinates below (placeholder), timestamp on right ("Yesterday, 4:50pm" format). Pull from `LocationBloc` state — show empty state if no history
9. **"Share Location" button** — full width, teal, fixed at bottom above bottom nav bar

### Bottom Navigation Bar
Same bottom nav as dashboard — Home, Contacts, Location (active), Settings. Reuse the existing `BottomNavBar` widget.

### Functionality to implement

#### Share Location button
Dispatches `ShareLocationEvent` to `LocationBloc` which must:
1. Request location permission via `PermissionHelper.requestLocationPermission()`
2. If denied → show permission dialog explaining why location is needed
3. If granted → call `LocationService.startTracking()` (stubbed, `// TODO: send to backend`)
4. Update button state: while sharing is active, button text changes to "Stop Sharing" and color changes to `AppColors.error`
5. Stop sharing → dispatches `StopSharingEvent`, calls `LocationService.stopTracking()`

#### Coordinates display
```dart
// TODO: Replace with real GPS data when Google APIs are available
const String _placeholderCoords = 'LAT:--.- N|LONG:--.- W';
```

#### History list
Pull from `LocationBloc` — if `LocationState` has empty history, show:
```dart
Center(child: Text('No location history yet', style: TextStyle(color: AppColors.textSecondary)))
```

#### Avatar stack
Build overlapping avatars using a `Stack` with negative left margins:
```dart
// Show up to 5 avatars, then "+N" bubble
```

---

## SCREEN 3 — Settings Screen (`settings_screen.dart`)

**File location:** `lib/features/settings/presentation/pages/settings_screen.dart`
**Figma reference:** `figma_images/settings_main.png`

### Layout (top to bottom)
1. **App bar** — back arrow on left, title "Settings" centered, no elevation
2. **Profile card** — rounded card, user avatar on left, name + email, chevron right → navigates to `AppRoutes.accountSettings`
3. **"Location" section label**
4. **Emergency Sharing toggle row** — location pin icon (teal circle background), "Emergency Sharing" bold, "Live location sharing during alerts" subtitle, `Switch` on right
5. **"Emergency" section label**
6. **Emergency settings card** — rounded container holding three toggle rows separated by thin dividers:
   - Row 1: shake icon (orange/coral circle), "Shake Trigger", "Trigger alert by shaking phone.", `Switch`
   - Row 2: alarm bell icon (red circle), "Alarm Sound", "Enable emergency alarm sound.", `Switch`
   - Row 3: routing icon (teal circle), "Auto Re-routing", "Enable re-routing to emergency contacts", `Switch`
7. **"Ad Manager" row** — rounded card, Ad icon (purple circle), "Ad Manager" text, chevron right → navigates to `AppRoutes.adManager` (stub the route — screen coming later)
8. **Bottom Navigation Bar** — Settings tab active

### Functionality to implement

All toggle states must be persisted via `SettingsBloc` → `SettingsRepository` → `LocalStorageService` (SharedPreferences). **These must apply instantly and strictly** — no toggle state should be cosmetic only.

#### Emergency Sharing toggle
- Key: `'location_sharing_enabled'`
- When OFF: `LocationService.stopTracking()` is called, location is never shared even during emergency
- When ON: location sharing is permitted during emergencies
- Dispatches `UpdateSettingsEvent(locationSharingEnabled: value)` to `SettingsBloc`

#### Shake Trigger toggle
- Key: `'shake_trigger_enabled'`
- When ON: `ShakeDetectionService.startListening()` is called
- When OFF: `ShakeDetectionService.stopListening()` is called
- Dispatches `UpdateSettingsEvent(shakeTriggerEnabled: value)`

#### Alarm Sound toggle
- Key: `'alarm_sound_enabled'`
- When OFF: `AlarmService` must skip playing sound during emergency trigger
- When ON: alarm plays at max volume, overrides silent mode
- Dispatches `UpdateSettingsEvent(alarmSoundEnabled: value)`

#### Auto Re-routing toggle
- Key: `'auto_rerouting_enabled'`
- When ON: emergency call is automatically placed to configured emergency number
- When OFF: no automatic call is made during emergency
- Dispatches `UpdateSettingsEvent(autoReroutingEnabled: value)`

#### Settings persistence
In `SettingsRepository`, implement `getSettings()` and `updateSettings()` using `SharedPreferences`:

```dart
// Load on app start in SettingsBloc init
add(LoadSettingsEvent());

// Save on every toggle change
Future<void> updateSettings(SettingsEntity settings) async {
  await prefs.setBool('location_sharing_enabled', settings.locationSharingEnabled);
  await prefs.setBool('shake_trigger_enabled', settings.shakeTriggerEnabled);
  await prefs.setBool('alarm_sound_enabled', settings.alarmSoundEnabled);
  await prefs.setBool('auto_rerouting_enabled', settings.autoReroutingEnabled);
}
```

#### SettingsEntity
Make sure `SettingsEntity` has these fields with defaults:

```dart
class SettingsEntity {
  final bool locationSharingEnabled;  // default: true
  final bool shakeTriggerEnabled;     // default: true
  final bool alarmSoundEnabled;       // default: true
  final bool autoReroutingEnabled;    // default: true
}
```

#### Settings enforcement in EmergencyBloc
When `TriggerEmergencyEvent` is dispatched, `EmergencyBloc` must read current `SettingsEntity` before acting:

```dart
final settings = settingsRepository.getSettings();

if (settings.alarmSoundEnabled) alarmService.triggerAlarm();
if (settings.autoReroutingEnabled) callService.call(settings.emergencyNumber);
if (settings.locationSharingEnabled) locationService.startTracking();
```

#### Icon helper widget
Create a reusable `_SettingsIconBadge` private widget inside the file:

```dart
Widget _SettingsIconBadge({required Color color, required IconData icon}) {
  return Container(
    width: 36, height: 36,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    child: Icon(icon, color: Colors.white, size: 18),
  );
}
```

Icon mappings from the Figma:
- Emergency Sharing → `Icons.location_on` , teal (`AppColors.primary`)
- Shake Trigger → `Icons.vibration`, orange (`Color(0xFFFF7043)`)
- Alarm Sound → `Icons.notifications_active`, red (`Color(0xFFE53935)`)
- Auto Re-routing → `Icons.call_split`, teal (`AppColors.primary`)
- Ad Manager → `Icons.campaign`, purple (`Color(0xFF7E57C2)`)

---

## SERVICES TO IMPLEMENT / COMPLETE

### `AlarmService` (`core/services/alarm/alarm_service.dart`)
Complete the stub using `just_audio`:

```dart
class AlarmService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> triggerAlarm() async {
    // Check settings before playing
    await _player.setAsset('assets/audio/alarm_default.mp3');
    await _player.setLoopMode(LoopMode.one);
    await _player.setVolume(1.0);
    await _player.play();
    // TODO: implement AudioSession to override silent mode
  }

  Future<void> stopAlarm() async {
    await _player.stop();
  }
}
```

Add `audio_session` configuration in `triggerAlarm()`:
```dart
final session = await AudioSession.instance;
await session.configure(const AudioSessionConfiguration(
  avAudioSessionCategory: AVAudioSessionCategory.playback,
  avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.duckOthers,
  androidAudioAttributes: AndroidAudioAttributes(
    contentType: AndroidAudioContentType.sonification,
    usage: AndroidAudioUsage.alarm,
  ),
  androidAudioFocusGainType: AndroidAudioFocusGainType.gainTransientMayDuck,
));
```

### `ShakeDetectionService` (`core/services/shake/shake_detection_service.dart`)
Complete the stub using `sensors_plus`:

```dart
class ShakeDetectionService {
  StreamSubscription? _subscription;
  final _shakeController = StreamController<void>.broadcast();
  Stream<void> get onShakeDetected => _shakeController.stream;

  static const double _shakeThreshold = 15.0; // configurable
  static const int _minShakeCount = 3;
  int _shakeCount = 0;
  DateTime? _lastShakeTime;

  void startListening() {
    _subscription = accelerometerEventStream().listen((event) {
      final magnitude = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      if (magnitude > _shakeThreshold) {
        final now = DateTime.now();
        if (_lastShakeTime == null || now.difference(_lastShakeTime!).inMilliseconds > 500) {
          _shakeCount++;
          _lastShakeTime = now;
          if (_shakeCount >= _minShakeCount) {
            _shakeController.add(null);
            _shakeCount = 0;
          }
        }
      }
    });
  }

  void stopListening() {
    _subscription?.cancel();
    _shakeCount = 0;
  }

  void dispose() {
    _subscription?.cancel();
    _shakeController.close();
  }
}
```

Wire shake detection to `EmergencyBloc`: when `ShakeDetectionService.onShakeDetected` fires, dispatch `TriggerEmergencyEvent` — but only if `settings.shakeTriggerEnabled == true`.

---

## ROUTES TO ADD/CONFIRM

Make sure these named routes exist in `app_router.dart` and `app_routes.dart`:

```dart
// app_routes.dart
static const String emergencyActive = 'emergency-active';
static const String locationSharing = 'location-sharing';
static const String settings = 'settings';
static const String accountSettings = 'account-settings';
static const String adManager = 'ad-manager'; // stub only for now
```

---

## CHECKLIST BEFORE REPORTING DONE

- [ ] `flutter analyze` passes with no errors
- [ ] All three screens match their Figma references
- [ ] No hardcoded strings — all in `AppStrings`
- [ ] No hardcoded colors — all in `AppColors`
- [ ] Settings toggles persist across app restarts (test by toggling, killing app, reopening)
- [ ] Shake detection starts/stops correctly based on toggle state
- [ ] Alarm plays on emergency trigger, stops on Stop button
- [ ] Call buttons launch the dialer with the correct numbers
- [ ] Back button is disabled on emergency active screen
- [ ] GPS coordinate fields show placeholder text with `// TODO` comments
- [ ] Empty states shown where data is not yet available

---

**Work through the screens in order: Emergency Active → Location Sharing → Settings. Confirm completion of each before moving to the next.**
