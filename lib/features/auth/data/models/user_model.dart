import 'dart:convert';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  final String? profilePictureId;
  final DateTime? lastLogin;
  final DateTime? createdOn;

  const UserModel({
    required super.id,
    required super.email,
    super.firstName,
    super.lastName,
    super.profilePictureUrl,
    this.profilePictureId,
    this.lastLogin,
    this.createdOn,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'],
      lastName: json['lastName'],
      profilePictureUrl: json['profilePictureUrl'],
      profilePictureId: json['profilePictureId'],
      lastLogin: json['lastLogin'] != null
          ? DateTime.tryParse(json['lastLogin'])
          : null,
      createdOn: json['createdOn'] != null
          ? DateTime.tryParse(json['createdOn'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'profilePictureUrl': profilePictureUrl,
      'profilePictureId': profilePictureId,
      'lastLogin': lastLogin?.toIso8601String(),
      'createdOn': createdOn?.toIso8601String(),
    };
  }

  /// Serialize to a JSON string for local caching.
  String toJsonString() => jsonEncode(toJson());

  /// Deserialize from a JSON string (from local cache).
  factory UserModel.fromJsonString(String jsonString) {
    return UserModel.fromJson(jsonDecode(jsonString));
  }
}
