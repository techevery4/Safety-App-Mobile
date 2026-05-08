import '../../domain/entities/settings_entity.dart';

class SettingsModel extends SettingsEntity {
  const SettingsModel({
    super.id,
    super.userId,
    super.emergencySharing,
    super.shakeTrigger,
    super.alarmSound,
    super.autoRerouting,
    super.createdOn,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      id: json['id'],
      userId: json['userId'],
      emergencySharing: json['emergencySharing'] ?? true,
      shakeTrigger: json['shakeTrigger'] ?? true,
      alarmSound: json['alarmSound'] ?? true,
      autoRerouting: json['autoRerouting'] ?? true,
      createdOn: json['createdOn'] != null ? DateTime.tryParse(json['createdOn']) : null,
    );
  }

  factory SettingsModel.fromEntity(SettingsEntity entity) {
    return SettingsModel(
      id: entity.id,
      userId: entity.userId,
      emergencySharing: entity.emergencySharing,
      shakeTrigger: entity.shakeTrigger,
      alarmSound: entity.alarmSound,
      autoRerouting: entity.autoRerouting,
      createdOn: entity.createdOn,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'emergencySharing': emergencySharing,
      'shakeTrigger': shakeTrigger,
      'alarmSound': alarmSound,
      'autoRerouting': autoRerouting,
      'createdOn': createdOn?.toIso8601String(),
    };
  }
}
