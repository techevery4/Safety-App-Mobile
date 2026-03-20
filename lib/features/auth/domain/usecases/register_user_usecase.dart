import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';

class RegisterUserUseCase {
  final AuthRepository repository;
  RegisterUserUseCase(this.repository);

  Future<UserEntity> call({required String email, required String password}) {
    return repository.register(email: email, password: password);
  }
}
