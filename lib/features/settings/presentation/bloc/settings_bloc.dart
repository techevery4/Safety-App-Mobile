import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../../auth/domain/usecases/change_password_usecase.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository repository;
  final ChangePasswordUseCase changePasswordUseCase;
  final AuthRepository authRepository;

  SettingsBloc({
    required this.repository,
    required this.changePasswordUseCase,
    required this.authRepository,
  }) : super(SettingsInitial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<UpdateSettingsEvent>(_onUpdateSettings);
    on<ChangePasswordRequested>(_onChangePassword);
  }

  Future<void> _onLoadSettings(LoadSettingsEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    try {
      final settings = await repository.getSettings();
      emit(SettingsLoaded(settings));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> _onUpdateSettings(UpdateSettingsEvent event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      final originalSettings = currentState.settings;
      final newSettings = originalSettings.copyWith(
        emergencySharing: event.emergencySharing,
        shakeTrigger: event.shakeTrigger,
        alarmSound: event.alarmSound,
        autoRerouting: event.autoRerouting,
      );
      
      // Optimistically update UI
      emit(SettingsLoaded(newSettings));
      
      try {
        await repository.updateSettings(newSettings);
      } catch (e) {
        // Revert to original settings and emit transient error for toast
        emit(SettingsUpdateFailed(e.toString()));
        emit(SettingsLoaded(originalSettings));
      }
    }
  }

  Future<void> _onChangePassword(ChangePasswordRequested event, Emitter<SettingsState> emit) async {
    SettingsEntity? currentSettings;
    if (state is SettingsLoaded) {
      currentSettings = (state as SettingsLoaded).settings;
    }

    emit(SettingsLoading());
    try {
      final user = await authRepository.getCurrentUser();
      if (user == null) {
        emit(ChangePasswordFailure('User not authenticated'));
        if (currentSettings != null) emit(SettingsLoaded(currentSettings));
        return;
      }

      await changePasswordUseCase(
        id: user.id,
        oldPassword: event.oldPassword,
        newPassword: event.newPassword,
        confirmPassword: event.confirmPassword,
      );
      emit(ChangePasswordSuccess());
      if (currentSettings != null) emit(SettingsLoaded(currentSettings));
    } catch (e) {
      emit(ChangePasswordFailure(e.toString()));
      if (currentSettings != null) emit(SettingsLoaded(currentSettings));
    }
  }
}
