import '../../domain/repositories/settings_repository.dart';
import '../../domain/entities/settings_entity.dart';
class SettingsRepositoryImpl implements SettingsRepository {
  @override
  Future<SettingsEntity> getSettings() async { throw UnimplementedError(); }
  @override
  Future<void> updateSettings(SettingsEntity settings) async {}
}
