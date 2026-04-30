import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roamsafe/core/services/alarm/alarm_service.dart';
import 'package:roamsafe/core/services/calling/call_service.dart';
import 'package:roamsafe/core/services/location/location_service.dart';
import 'package:roamsafe/features/settings/domain/repositories/settings_repository.dart';
import 'package:roamsafe/features/emergency/presentation/bloc/emergency_event.dart';
import 'package:roamsafe/features/emergency/presentation/bloc/emergency_state.dart';

class EmergencyBloc extends Bloc<EmergencyEvent, EmergencyState> {
  final AlarmService alarmService;
  final CallService callService;
  final LocationService locationService;
  final SettingsRepository settingsRepository;

  EmergencyBloc({
    required this.alarmService,
    required this.callService,
    required this.locationService,
    required this.settingsRepository,
  }) : super(EmergencyInitial()) {
    on<TriggerEmergencyEvent>(_onTrigger);
    on<StopEmergencyEvent>(_onStop);
  }

  Future<void> _onTrigger(TriggerEmergencyEvent event, Emitter<EmergencyState> emit) async {
    emit(EmergencyActive());
    
    final settings = await settingsRepository.getSettings();
    if (settings.alarmSoundEnabled) {
      // Wait for 2 second activation sequence
      await Future.delayed(const Duration(seconds: 2));
      alarmService.triggerAlarm();
    }
    
    if (settings.autoReroutingEnabled) {
      // 3s call routing wait
      await Future.delayed(const Duration(seconds: 3));
      callService.call('112');
    }
    
    if (settings.locationSharingEnabled) {
      // Stub location service tracking
    }
  }

  Future<void> _onStop(StopEmergencyEvent event, Emitter<EmergencyState> emit) async {
    await alarmService.stopAlarm();
    emit(EmergencyStopped());
  }
}
