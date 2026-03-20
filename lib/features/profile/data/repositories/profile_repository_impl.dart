import '../../domain/repositories/profile_repository.dart';
import '../../domain/entities/profile_entity.dart';
class ProfileRepositoryImpl implements ProfileRepository {
  @override
  Future<ProfileEntity> getProfile() async { throw UnimplementedError(); }
  @override
  Future<ProfileEntity> updateProfile({String? firstName, String? lastName, String? photoUrl}) async { throw UnimplementedError(); }
}
