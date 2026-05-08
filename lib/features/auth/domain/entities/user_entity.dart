import 'package:equatable/equatable.dart';
import '../../../../features/settings/domain/entities/settings_entity.dart';

class UserAlertEntity extends Equatable {
  final String? id;
  final String? userId;
  final String? displayId;
  final String? status;
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime? createdOn;

  const UserAlertEntity({
    this.id,
    this.userId,
    this.displayId,
    this.status,
    this.startTime,
    this.endTime,
    this.createdOn,
  });

  @override
  List<Object?> get props => [id, userId, displayId, status, startTime, endTime, createdOn];
}

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? profilePictureId;
  final String? profilePictureUrl;
  final String? status;
  final double? latitude;
  final double? longitude;
  final String? locationText;
  final String? lastIp;
  final DateTime? lastLocationUpdate;
  final DateTime? lastLogin;
  final SettingsEntity? settings;
  final int totalAlerts;
  final List<UserAlertEntity> alerts;
  final DateTime? createdOn;

  const UserEntity({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.profilePictureId,
    this.profilePictureUrl,
    this.status,
    this.latitude,
    this.longitude,
    this.locationText,
    this.lastIp,
    this.lastLocationUpdate,
    this.lastLogin,
    this.settings,
    this.totalAlerts = 0,
    this.alerts = const [],
    this.createdOn,
  });

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();

  @override
  List<Object?> get props => [
        id,
        email,
        firstName,
        lastName,
        profilePictureId,
        profilePictureUrl,
        status,
        latitude,
        longitude,
        locationText,
        lastIp,
        lastLocationUpdate,
        lastLogin,
        settings,
        totalAlerts,
        alerts,
        createdOn,
      ];

  UserEntity copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? profilePictureId,
    String? profilePictureUrl,
    String? status,
    double? latitude,
    double? longitude,
    String? locationText,
    String? lastIp,
    DateTime? lastLocationUpdate,
    DateTime? lastLogin,
    SettingsEntity? settings,
    int? totalAlerts,
    List<UserAlertEntity>? alerts,
    DateTime? createdOn,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profilePictureId: profilePictureId ?? this.profilePictureId,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      status: status ?? this.status,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationText: locationText ?? this.locationText,
      lastIp: lastIp ?? this.lastIp,
      lastLocationUpdate: lastLocationUpdate ?? this.lastLocationUpdate,
      lastLogin: lastLogin ?? this.lastLogin,
      settings: settings ?? this.settings,
      totalAlerts: totalAlerts ?? this.totalAlerts,
      alerts: alerts ?? this.alerts,
      createdOn: createdOn ?? this.createdOn,
    );
  }
}
