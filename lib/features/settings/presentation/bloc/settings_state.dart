import '../../domain/entities/settings_entity.dart';

abstract class SettingsState {}
class SettingsInitial extends SettingsState {}
class SettingsLoading extends SettingsState {}
class SettingsLoaded extends SettingsState {
  final SettingsEntity settings;
  SettingsLoaded(this.settings);
}
class SettingsError extends SettingsState {
  final String message;
  SettingsError(this.message);
}
class ChangePasswordSuccess extends SettingsState {}
class ChangePasswordFailure extends SettingsState {
  final String message;
  ChangePasswordFailure(this.message);
}
class SettingsUpdateFailed extends SettingsState {
  final String message;
  SettingsUpdateFailed(this.message);
}
