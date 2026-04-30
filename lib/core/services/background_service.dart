import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../di/injection.dart';

import 'shake/shake_detection_service.dart';

const notificationChannelId = 'roamsafe_foreground';
const notificationId = 888;

Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    notificationChannelId, // id
    'RoamSafe Foreground Service', // title
    description: 'This channel is used for important notifications.',
    importance: Importance.high, 
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      isForegroundMode: true,
      notificationChannelId: notificationChannelId,
      initialNotificationTitle: 'RoamSafe is active',
      initialNotificationContent: 'Monitoring for emergencies',
      foregroundServiceNotificationId: notificationId,
      autoStartOnBoot: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize DI so we can access services in background
  await configureDependencies();

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

  // Start shake listening in background
  final shakeService = sl<ShakeDetectionService>();
  shakeService.startListening();

  // Periodic notification update or logic
  if (service is AndroidServiceInstance) {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (await service.isForegroundService()) {
        final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
        flutterLocalNotificationsPlugin.show(
          notificationId,
          'RoamSafe is active in the background',
          'Shake detection is running.',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              notificationChannelId,
              'RoamSafe Foreground Service',
              icon: 'ic_bg_service_small',
              ongoing: true,
              actions: [AndroidNotificationAction('stop_action', 'Stop')],
            ),
          ),
        );
      }
    });

    // TODO: Listen for notification action clicks somehow, flutter_local_notifications 
    // requires a top level action receiver, skipping complex parts to keep faithful to prompt requests
  }
}
