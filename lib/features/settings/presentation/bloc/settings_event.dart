abstract class SettingsEvent {}
class LoadSettingsEvent extends SettingsEvent {}
class UpdateSettingsEvent extends SettingsEvent {
  final bool? locationSharingEnabled;
  final bool? shakeTriggerEnabled;
  final bool? alarmSoundEnabled;
  final bool? autoReroutingEnabled;

  UpdateSettingsEvent({
    this.locationSharingEnabled,
    this.shakeTriggerEnabled,
    this.alarmSoundEnabled,
    this.autoReroutingEnabled,
  });
}
class ChangePasswordRequested extends SettingsEvent {
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;

  ChangePasswordRequested({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmPassword,
  });
}
