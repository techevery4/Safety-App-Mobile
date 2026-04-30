import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';

class SetupProfileUseCase {
  final AuthRepository repository;
  SetupProfileUseCase(this.repository);

  Future<UserEntity> call({
    required String id,
    required String firstName,
    required String lastName,
  }) {
    return repository.setupProfile(
      id: id,
      firstName: firstName,
      lastName: lastName,
    );
  }
}
