import '../../domain/entities/settings_entity.dart';

class SettingsModel extends SettingsEntity {
  const SettingsModel({
    super.locationSharingEnabled,
    super.shakeTriggerEnabled,
    super.alarmSoundEnabled,
    super.autoReroutingEnabled,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      locationSharingEnabled: json['locationSharingEnabled'] ?? true,
      shakeTriggerEnabled: json['shakeTriggerEnabled'] ?? true,
      alarmSoundEnabled: json['alarmSoundEnabled'] ?? true,
      autoReroutingEnabled: json['autoReroutingEnabled'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'locationSharingEnabled': locationSharingEnabled,
      'shakeTriggerEnabled': shakeTriggerEnabled,
      'alarmSoundEnabled': alarmSoundEnabled,
      'autoReroutingEnabled': autoReroutingEnabled,
    };
  }
}
