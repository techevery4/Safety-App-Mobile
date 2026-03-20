import '../repositories/settings_repository.dart';
import '../entities/settings_entity.dart';
class GetSettingsUseCase {
  final SettingsRepository repository;
  GetSettingsUseCase(this.repository);
  Future<SettingsEntity> call() => repository.getSettings();
}
