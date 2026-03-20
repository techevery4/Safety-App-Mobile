/// Alarm service — manages emergency alarm audio playback.
/// Uses just_audio to override silent mode and play at max volume.
class AlarmService {
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  /// Trigger the emergency alarm.
  /// Must activate within 2 seconds of trigger.
  /// Must override silent mode and use maximum volume.
  /// Must work when: screen locked, app backgrounded, phone idle.
  Future<void> triggerAlarm() async {
    // TODO: implement
    // 1. Configure audio session to override silent mode
    // 2. Set volume to maximum
    // 3. Load and play alarm audio in loop
    _isPlaying = true;
  }

  /// Stop the alarm. Only accessible by the user who triggered it.
  Future<void> stopAlarm() async {
    // TODO: implement
    // 1. Stop audio playback
    // 2. Restore audio session
    _isPlaying = false;
  }

  /// Dispose audio resources.
  Future<void> dispose() async {
    // TODO: implement
  }
}
