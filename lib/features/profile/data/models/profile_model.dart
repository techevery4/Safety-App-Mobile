import '../../domain/entities/profile_entity.dart';
class ProfileModel extends ProfileEntity {
  const ProfileModel({required super.id, required super.email, super.firstName, super.lastName, super.profilePictureUrl});
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(id: json['id'], email: json['email'], firstName: json['firstName'], lastName: json['lastName'], profilePictureUrl: json['profilePictureUrl']);
  }
}
