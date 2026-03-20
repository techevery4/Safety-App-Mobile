abstract class SettingsLocalDataSource {
  Future<Map<String, dynamic>> getSettings();
  Future<void> saveSettings(Map<String, dynamic> settings);
}
class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  @override
  Future<Map<String, dynamic>> getSettings() async { return {}; }
  @override
  Future<void> saveSettings(Map<String, dynamic> settings) async {}
}
