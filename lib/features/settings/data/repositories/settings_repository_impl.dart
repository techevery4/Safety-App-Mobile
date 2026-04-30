import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SharedPreferences prefs;

  SettingsRepositoryImpl(this.prefs);

  @override
  Future<SettingsEntity> getSettings() async {
    return SettingsEntity(
      locationSharingEnabled: prefs.getBool('location_sharing_enabled') ?? true,
      shakeTriggerEnabled: prefs.getBool('shake_trigger_enabled') ?? true,
      alarmSoundEnabled: prefs.getBool('alarm_sound_enabled') ?? true,
      autoReroutingEnabled: prefs.getBool('auto_rerouting_enabled') ?? true,
    );
  }

  @override
  Future<void> updateSettings(SettingsEntity settings) async {
    await prefs.setBool('location_sharing_enabled', settings.locationSharingEnabled);
    await prefs.setBool('shake_trigger_enabled', settings.shakeTriggerEnabled);
    await prefs.setBool('alarm_sound_enabled', settings.alarmSoundEnabled);
    await prefs.setBool('auto_rerouting_enabled', settings.autoReroutingEnabled);
  }
}
