abstract class SettingsEvent {}
class LoadSettingsEvent extends SettingsEvent {}
class UpdateSettingsEvent extends SettingsEvent {
  final bool? emergencySharing;
  final bool? shakeTrigger;
  final bool? alarmSound;
  final bool? autoRerouting;

  UpdateSettingsEvent({
    this.emergencySharing,
    this.shakeTrigger,
    this.alarmSound,
    this.autoRerouting,
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
