import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roamsafe/core/services/alarm/alarm_service.dart';
import 'package:roamsafe/core/services/calling/call_service.dart';
import 'package:roamsafe/core/services/location/location_service.dart';
import 'package:roamsafe/core/services/shake/shake_detection_service.dart';
import 'package:roamsafe/features/settings/domain/repositories/settings_repository.dart';
import 'package:roamsafe/features/emergency/presentation/bloc/emergency_event.dart';
import 'package:roamsafe/features/emergency/presentation/bloc/emergency_state.dart';

class EmergencyBloc extends Bloc<EmergencyEvent, EmergencyState> {
  final AlarmService alarmService;
  final ShakeDetectionService shakeDetectionService;
  final CallService callService;
  final LocationService locationService;
  final SettingsRepository settingsRepository;

  StreamSubscription? _shakeSubscription;
  StreamSubscription? _bgSubscription;

  EmergencyBloc({
    required this.alarmService,
    required this.shakeDetectionService,
    required this.callService,
    required this.locationService,
    required this.settingsRepository,
  }) : super(EmergencyInitial()) {
    on<TriggerEmergencyEvent>(_onTrigger);
    on<StopEmergencyEvent>(_onStop);

    _initDetection();
  }

  void _initDetection() {
    // 1. Local Shake Detection (for when app is in foreground)
    shakeDetectionService.startListening();
    _shakeSubscription = shakeDetectionService.onShakeDetected.listen((
      _,
    ) async {
      debugPrint(
        '🚨 EmergencyBloc: Received shake event. Fetching settings...',
      );
      final settings = await settingsRepository.getSettings();
      debugPrint(
        '🚨 EmergencyBloc: Settings fetched. ShakeTrigger: ${settings.shakeTrigger}',
      );
      if (settings.shakeTrigger) {
        add(TriggerEmergencyEvent());
      }
    });

    // 2. Background Service Sync (for when background service triggers emergency)
    _bgSubscription = FlutterBackgroundService()
        .on('emergency_triggered')
        .listen((_) {
          add(TriggerEmergencyEvent());
        });

    // 3. Persistent Check (on startup)
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getBool('is_emergency_active') ?? false) {
        add(TriggerEmergencyEvent());
      }
    });
  }

  Future<void> _onTrigger(
    TriggerEmergencyEvent event,
    Emitter<EmergencyState> emit,
  ) async {
    debugPrint('🚨 EmergencyBloc: _onTrigger called. Current state: $state');
    if (state is EmergencyActive) {
      debugPrint('🚨 EmergencyBloc: Already active. Ignoring trigger.');
      return; // Already active
    }

    emit(EmergencyActive());

    final settings = await settingsRepository.getSettings();
    debugPrint(
      '🚨 EmergencyBloc: Settings fetched - alarmSound: ${settings.alarmSound}, autoRerouting: ${settings.autoRerouting}',
    );

    if (!settings.alarmSound) {
      debugPrint('🚨 EmergencyBloc: Triggering alarm sound...');
      // Small delay to ensure state is emitted
      await Future.delayed(const Duration(milliseconds: 500));
      alarmService.triggerAlarm();
    }

    // Tell the Background Service to bring the app to the foreground
    debugPrint(
      '🚨 EmergencyBloc: Asking Background Service to bring app to foreground',
    );
    FlutterBackgroundService().invoke('trigger_foreground');

    if (settings.autoRerouting) {
      // 3s call routing wait
      await Future.delayed(const Duration(seconds: 3));
      // Use region-detected emergency number from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final emergencyNumber = prefs.getString('emergency_number') ?? '112';
      callService.call(emergencyNumber);
    }

    if (settings.emergencySharing) {
      // In a real app, you'd start sending location to the server here
    }
  }

  Future<void> _onStop(
    StopEmergencyEvent event,
    Emitter<EmergencyState> emit,
  ) async {
    // Stop local alarm
    await alarmService.stopAlarm();

    // Stop background alarm/update notification
    FlutterBackgroundService().invoke('stop_emergency');

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_emergency_active', false);

    emit(EmergencyStopped());
  }

  @override
  Future<void> close() {
    _shakeSubscription?.cancel();
    _bgSubscription?.cancel();
    shakeDetectionService.stopListening();
    return super.close();
  }
}
