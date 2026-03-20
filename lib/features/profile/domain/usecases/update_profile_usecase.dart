import '../repositories/profile_repository.dart';
import '../entities/profile_entity.dart';
class UpdateProfileUseCase {
  final ProfileRepository repository;
  UpdateProfileUseCase(this.repository);
  Future<ProfileEntity> call({String? firstName, String? lastName, String? photoUrl}) => repository.updateProfile(firstName: firstName, lastName: lastName, photoUrl: photoUrl);
}
