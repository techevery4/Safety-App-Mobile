import '../../domain/repositories/profile_repository.dart';
import '../../domain/entities/profile_entity.dart';
import '../../../auth/domain/repositories/auth_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final AuthRepository authRepository;

  ProfileRepositoryImpl(this.authRepository);

  @override
  Future<ProfileEntity> getProfile() async {
    final user = await authRepository.getCurrentUser();
    if (user == null) throw Exception('No user found');
    return ProfileEntity(
      id: user.id,
      email: user.email,
      firstName: user.firstName ?? '',
      lastName: user.lastName ?? '',
      profilePictureUrl: user.profilePictureUrl,
    );
  }

  @override
  Future<ProfileEntity> updateProfile({
    String? firstName,
    String? lastName,
    String? photoUrl,
  }) async {
    final user = await authRepository.getCurrentUser();
    if (user == null) throw Exception('No user found');

    final updatedUser = await authRepository.updateUser(user.copyWith(
      firstName: firstName,
      lastName: lastName,
      profilePictureUrl: photoUrl,
    ));

    return ProfileEntity(
      id: updatedUser.id,
      email: updatedUser.email,
      firstName: updatedUser.firstName ?? '',
      lastName: updatedUser.lastName ?? '',
      profilePictureUrl: updatedUser.profilePictureUrl,
    );
  }
}
