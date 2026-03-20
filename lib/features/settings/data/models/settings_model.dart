import '../../domain/entities/settings_entity.dart';
class SettingsModel extends SettingsEntity {
  const SettingsModel({super.locationSharingEnabled, super.alarmSoundEnabled, super.callReroutingEnabled, super.notificationsEnabled, super.shakeCount});
  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      locationSharingEnabled: json['locationSharingEnabled'] ?? true,
      alarmSoundEnabled: json['alarmSoundEnabled'] ?? true,
      callReroutingEnabled: json['callReroutingEnabled'] ?? true,
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      shakeCount: json['shakeCount'] ?? 3,
    );
  }
}
