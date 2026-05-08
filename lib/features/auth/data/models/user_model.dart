import 'dart:convert';
import '../../domain/entities/user_entity.dart';
import '../../../../features/settings/data/models/settings_model.dart';

class UserAlertModel extends UserAlertEntity {
  const UserAlertModel({
    super.id,
    super.userId,
    super.displayId,
    super.status,
    super.startTime,
    super.endTime,
    super.createdOn,
  });

  factory UserAlertModel.fromJson(Map<String, dynamic> json) {
    return UserAlertModel(
      id: json['id'],
      userId: json['userId'],
      displayId: json['displayId'],
      status: json['status'],
      startTime: json['startTime'] != null ? DateTime.tryParse(json['startTime']) : null,
      endTime: json['endTime'] != null ? DateTime.tryParse(json['endTime']) : null,
      createdOn: json['createdOn'] != null ? DateTime.tryParse(json['createdOn']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'displayId': displayId,
      'status': status,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'createdOn': createdOn?.toIso8601String(),
    };
  }
}

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.firstName,
    super.lastName,
    super.profilePictureId,
    super.profilePictureUrl,
    super.status,
    super.latitude,
    super.longitude,
    super.locationText,
    super.lastIp,
    super.lastLocationUpdate,
    super.lastLogin,
    super.settings,
    super.totalAlerts,
    super.alerts,
    super.createdOn,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'],
      lastName: json['lastName'],
      profilePictureId: json['profilePictureId'],
      profilePictureUrl: json['profilePictureUrl'],
      status: json['status'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      locationText: json['locationText'],
      lastIp: json['lastIp'],
      lastLocationUpdate: _parseDate(json['lastLocationUpdate']),
      lastLogin: json['lastLogin'] != null ? DateTime.tryParse(json['lastLogin']) : null,
      settings: json['settings'] != null ? SettingsModel.fromJson(json['settings']) : null,
      totalAlerts: json['totalAlerts'] ?? 0,
      alerts: (json['alerts'] as List?)?.map((e) => UserAlertModel.fromJson(e)).toList() ?? const [],
      createdOn: json['createdOn'] != null ? DateTime.tryParse(json['createdOn']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'profilePictureId': profilePictureId,
      'profilePictureUrl': profilePictureUrl,
      'status': status,
      'latitude': latitude,
      'longitude': longitude,
      'locationText': locationText,
      'lastIp': lastIp,
      'lastLocationUpdate': lastLocationUpdate?.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
      'settings': settings != null ? SettingsModel.fromEntity(settings!).toJson() : null,
      'totalAlerts': totalAlerts,
      'alerts': alerts.map((e) => (e as UserAlertModel).toJson()).toList(),
      'createdOn': createdOn?.toIso8601String(),
    };
  }

  static DateTime? _parseDate(dynamic date) {
    if (date == null) return null;
    if (date is String) return DateTime.tryParse(date);
    if (date is List && date.length >= 6) {
      return DateTime(
        date[0] as int,
        date[1] as int,
        date[2] as int,
        date[3] as int,
        date[4] as int,
        date[5] as int,
        (date.length > 6 ? (date[6] as int) ~/ 1000000 : 0),
      );
    }
    return null;
  }

  /// Serialize to a JSON string for local caching.
  String toJsonString() => jsonEncode(toJson());

  /// Deserialize from a JSON string (from local cache).
  factory UserModel.fromJsonString(String jsonString) {
    return UserModel.fromJson(jsonDecode(jsonString));
  }
}
