import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../di/injection.dart';
import 'shake/shake_detection_service.dart';
import 'alarm/alarm_service.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';

const notificationChannelId = 'roamsafe_foreground';
const notificationId = 888;

Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    notificationChannelId,
    'RoamSafe Foreground Service',
    description: 'Used for monitoring emergency triggers like shakes.',
    importance: Importance
        .low, // Use low to avoid annoying sound/popup for constant monitoring
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: notificationChannelId,
      initialNotificationTitle: 'RoamSafe Active',
      initialNotificationContent: 'Monitoring for emergency shake gesture',
      foregroundServiceNotificationId: notificationId,
      autoStartOnBoot: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
@pragma('vm:keep')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
@pragma('vm:keep')
void onStart(ServiceInstance service) async {
  debugPrint('🔥 ON_START: Isolate Entry Point Triggered');

  // Register listeners IMMEDIATELY before doing any async work
  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  service.on('trigger_foreground').listen((_) async {
    debugPrint('🚀 [BACKGROUND] Received trigger_foreground signal!');
    try {
      final intent = AndroidIntent(
        action: 'android.intent.action.VIEW',
        data: 'roamsafe://emergency',
        flags: <int>[
          Flag.FLAG_ACTIVITY_NEW_TASK,
          Flag.FLAG_ACTIVITY_SINGLE_TOP,
        ],
      );
      debugPrint('🚀 [BACKGROUND] Launching Intent now...');
      await intent.launch();
      debugPrint('✅ [BACKGROUND] Intent launch command sent');
    } catch (e) {
      debugPrint('❌ [BACKGROUND] Intent launch error: $e');
    }
  });

  DartPluginRegistrant.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint('🏗️ Background Isolate: Initializing DI...');
  await configureDependencies();
  debugPrint('🏗️ Background Isolate: DI Initialized');

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final shakeService = sl<ShakeDetectionService>();
  final alarmService = sl<AlarmService>();
  final settingsRepo = sl<SettingsRepository>();
  debugPrint('🏗️ Background Isolate: Services retrieved from DI');

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // Listen for signals from Main Isolate to bring app to foreground
  service.on('trigger_foreground').listen((_) async {
    debugPrint(
      '🚀 Background Service received trigger_foreground from Main Isolate',
    );
    if (service is AndroidServiceInstance) {
      debugPrint(
        '🚀 [INTENT] Attempting to launch via Deep Link: roamsafe://emergency',
      );
      try {
        final intent = AndroidIntent(
          action: 'android.intent.action.VIEW',
          data: 'roamsafe://emergency',
          flags: <int>[
            Flag.FLAG_ACTIVITY_NEW_TASK,
            Flag.FLAG_ACTIVITY_SINGLE_TOP,
          ],
        );
        debugPrint('🚀 [INTENT] Calling intent.launch()...');
        await intent.launch();
        debugPrint('✅ [INTENT] Deep Link launch command sent!');
      } catch (e) {
        debugPrint('❌ [INTENT] Intent launch failed completely: $e');
      }
    } else {
      debugPrint(
        '❌ [INTENT] Service is NOT AndroidServiceInstance! Cannot launch intent.',
      );
    }

    // Delay slightly and then tell the app to navigate
    await Future.delayed(const Duration(milliseconds: 1000));
    service.invoke('emergency_triggered');
  });

  // Listen for emergency stop from UI
  service.on('stop_emergency').listen((event) async {
    await alarmService.stopAlarm();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_emergency_active', false);
    _updateNotification(
      flutterLocalNotificationsPlugin,
      'RoamSafe Active',
      'Monitoring for emergency shake gesture',
    );
  });

  // Start shake listening in background
  shakeService.startListening();
  shakeService.onShakeDetected.listen((_) async {
    debugPrint('🫨 Background shake event received. Fetching settings...');
    final settings = await settingsRepo.getSettings();
    debugPrint(
      '✅ Settings fetched. ShakeTrigger: ${settings.shakeTrigger}, AlarmSound: ${settings.alarmSound}',
    );
    if (settings.shakeTrigger) {
      debugPrint('🚨 Background shake detected — triggering emergency');

      // Step 1: Trigger Alarm in Background (IMMEDIATE)
      if (!settings.alarmSound) {
        debugPrint('🔔 Background alarm triggered');
        await alarmService.triggerAlarm();
      }

      // Step 2: Bring app to foreground via Android Intent
      if (service is AndroidServiceInstance) {
        debugPrint('🚀 [INTENT 2] Attempting to launch AndroidIntent...');
        try {
          final intent = AndroidIntent(
            action: 'android.intent.action.VIEW',
            data: 'roamsafe://emergency',
            flags: <int>[
              Flag.FLAG_ACTIVITY_NEW_TASK,
              Flag.FLAG_ACTIVITY_SINGLE_TOP,
            ],
          );
          debugPrint('🚀 [INTENT 2] Calling intent.launch()...');
          await intent.launch();
          debugPrint(
            '✅ [INTENT 2] App brought to foreground via intent successfully!',
          );
        } catch (e) {
          debugPrint('❌ [INTENT 2] Intent launch failed completely: $e');
        }
      } else {
        debugPrint(
          '❌ [INTENT 2] Service is NOT AndroidServiceInstance! Cannot launch intent.',
        );
      }

      // Step 3: Notify Foreground App (WITH DELAY)
      // Small delay to allow app to finish launching before receiving the signal
      debugPrint('⏳ Waiting for app to launch before sending signal...');
      await Future.delayed(const Duration(milliseconds: 1000));
      debugPrint('📱 Sending emergency_triggered signal to app...');
      service.invoke('emergency_triggered');

      // 4. Update Notification
      _updateNotification(
        flutterLocalNotificationsPlugin,
        '🚨 EMERGENCY ACTIVE',
        'Your emergency contacts are being notified.',
      );

      // 5. Open dialler logic moved to EmergencyActiveScreen (foreground)
      // but we still keep the emergency state persistence
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_emergency_active', true);
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

void _updateNotification(
  FlutterLocalNotificationsPlugin plugin,
  String title,
  String content,
) {
  plugin.show(
    notificationId,
    title,
    content,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        notificationChannelId,
        'RoamSafe Foreground Service',
        icon: '@mipmap/launcher_icon',
        ongoing: true,
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
  );
}
