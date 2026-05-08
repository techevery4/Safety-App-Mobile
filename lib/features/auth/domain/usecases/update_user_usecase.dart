import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';

class UpdateUserUseCase {
  final AuthRepository repository;

  UpdateUserUseCase(this.repository);

  Future<UserEntity> call(UserEntity user) {
    return repository.updateUser(user);
  }
}
