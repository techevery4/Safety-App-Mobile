import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../../../features/auth/domain/repositories/auth_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final AuthRepository authRepository;

  SettingsRepositoryImpl(this.authRepository);

  @override
  Future<SettingsEntity> getSettings() async {
    final user = await authRepository.getCurrentUser();
    return user?.settings ?? const SettingsEntity();
  }

  @override
  Future<void> updateSettings(SettingsEntity settings) async {
    final user = await authRepository.getCurrentUser();
    if (user != null) {
      final updatedUser = user.copyWith(settings: settings);
      await authRepository.updateUser(updatedUser);
    }
  }
}
