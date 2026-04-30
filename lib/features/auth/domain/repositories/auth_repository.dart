import '../entities/user_entity.dart';
import '../../../../core/services/storage/onboarding_storage_service.dart';

abstract class AuthRepository {
  Future<UserEntity> register({
    required String email,
    required String password,
    required String confirmPassword,
  });
  Future<UserEntity> login({required String email, required String password});
  Future<UserEntity> verifyOtp({required String email, required String otp});
  Future<void> resendOtp({required String email});
  Future<UserEntity> setupProfile({
    required String id,
    required String firstName,
    required String lastName,
  });
  Future<void> logout();
  Future<UserEntity?> getCurrentUser();
  OnboardingStage getOnboardingStage();
  Future<UserEntity> changePassword({
    required String id,
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  });
}
