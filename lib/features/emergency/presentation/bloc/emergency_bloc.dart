import 'dart:async';
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

  EmergencyBloc({
    required this.alarmService,
    required this.shakeDetectionService,
    required this.callService,
    required this.locationService,
    required this.settingsRepository,
  }) : super(EmergencyInitial()) {
    on<TriggerEmergencyEvent>(_onTrigger);
    on<StopEmergencyEvent>(_onStop);
    
    _initShakeDetection();
  }

  void _initShakeDetection() {
    shakeDetectionService.startListening();
    _shakeSubscription = shakeDetectionService.onShakeDetected.listen((_) async {
      final settings = await settingsRepository.getSettings();
      if (settings.shakeTrigger) {
        add(TriggerEmergencyEvent());
      }
    });
  }

  Future<void> _onTrigger(TriggerEmergencyEvent event, Emitter<EmergencyState> emit) async {
    emit(EmergencyActive());
    
    final settings = await settingsRepository.getSettings();
    if (settings.alarmSound) {
      // Wait for 2 second activation sequence
      await Future.delayed(const Duration(seconds: 2));
      alarmService.triggerAlarm();
    }
    
    if (settings.autoRerouting) {
      // 3s call routing wait
      await Future.delayed(const Duration(seconds: 3));
      callService.call('112');
    }
    
    if (settings.emergencySharing) {
      // Stub location service tracking
      // In a real app, you'd start sending location to the server here
    }
  }

  Future<void> _onStop(StopEmergencyEvent event, Emitter<EmergencyState> emit) async {
    await alarmService.stopAlarm();
    emit(EmergencyStopped());
  }

  @override
  Future<void> close() {
    _shakeSubscription?.cancel();
    shakeDetectionService.stopListening();
    return super.close();
  }
}
