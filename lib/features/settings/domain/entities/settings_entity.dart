class SettingsEntity {
  final String? id;
  final String? userId;
  final bool emergencySharing;
  final bool shakeTrigger;
  final bool alarmSound;
  final bool autoRerouting;
  final DateTime? createdOn;

  const SettingsEntity({
    this.id,
    this.userId,
    this.emergencySharing = true,
    this.shakeTrigger = true,
    this.alarmSound = true,
    this.autoRerouting = true,
    this.createdOn,
  });

  SettingsEntity copyWith({
    String? id,
    String? userId,
    bool? emergencySharing,
    bool? shakeTrigger,
    bool? alarmSound,
    bool? autoRerouting,
    DateTime? createdOn,
  }) {
    return SettingsEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      emergencySharing: emergencySharing ?? this.emergencySharing,
      shakeTrigger: shakeTrigger ?? this.shakeTrigger,
      alarmSound: alarmSound ?? this.alarmSound,
      autoRerouting: autoRerouting ?? this.autoRerouting,
      createdOn: createdOn ?? this.createdOn,
    );
  }
}
