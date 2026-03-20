import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;
  VerifyOtpUseCase(this.repository);

  Future<UserEntity> call({required String email, required String otp}) {
    return repository.verifyOtp(email: email, otp: otp);
  }
}
