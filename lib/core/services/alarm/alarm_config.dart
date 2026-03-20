/// Configuration for the alarm sound.
class AlarmConfig {
  final String audioAssetPath;
  final bool overrideSilentMode;
  final double volume; // 0.0 to 1.0
  final bool loop;

  const AlarmConfig({
    this.audioAssetPath = 'assets/audio/alarm_default.mp3',
    this.overrideSilentMode = true,
    this.volume = 1.0,
    this.loop = true,
  });
}
