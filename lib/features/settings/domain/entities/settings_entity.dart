import 'package:equatable/equatable.dart';
/// Every settings toggle must be strictly obeyed — no exceptions.
class SettingsEntity extends Equatable {
  /// Location sharing OFF = location is never shared under any condition
  final bool locationSharingEnabled;
  /// Alarm sound OFF = no alarm plays during emergency
  final bool alarmSoundEnabled;
  /// Call rerouting OFF = no call is made during emergency
  final bool callReroutingEnabled;
  final bool notificationsEnabled;
  /// Default 3 shakes, configurable
  final int shakeCount;

  const SettingsEntity({
    this.locationSharingEnabled = true,
    this.alarmSoundEnabled = true,
    this.callReroutingEnabled = true,
    this.notificationsEnabled = true,
    this.shakeCount = 3,
  });

  @override
  List<Object?> get props => [locationSharingEnabled, alarmSoundEnabled, callReroutingEnabled, notificationsEnabled, shakeCount];
}
