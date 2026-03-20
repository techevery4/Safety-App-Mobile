import '../entities/profile_entity.dart';
abstract class ProfileRepository {
  Future<ProfileEntity> getProfile();
  Future<ProfileEntity> updateProfile({String? firstName, String? lastName, String? photoUrl});
}
