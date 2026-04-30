class SettingsEntity {
  final bool locationSharingEnabled;
  final bool shakeTriggerEnabled;
  final bool alarmSoundEnabled;
  final bool autoReroutingEnabled;

  const SettingsEntity({
    this.locationSharingEnabled = true,
    this.shakeTriggerEnabled = true,
    this.alarmSoundEnabled = true,
    this.autoReroutingEnabled = true,
  });

  SettingsEntity copyWith({
    bool? locationSharingEnabled,
    bool? shakeTriggerEnabled,
    bool? alarmSoundEnabled,
    bool? autoReroutingEnabled,
  }) {
    return SettingsEntity(
      locationSharingEnabled: locationSharingEnabled ?? this.locationSharingEnabled,
      shakeTriggerEnabled: shakeTriggerEnabled ?? this.shakeTriggerEnabled,
      alarmSoundEnabled: alarmSoundEnabled ?? this.alarmSoundEnabled,
      autoReroutingEnabled: autoReroutingEnabled ?? this.autoReroutingEnabled,
    );
  }
}
