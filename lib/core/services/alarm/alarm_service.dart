import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

@pragma('vm:keep')
class AlarmService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> triggerAlarm() async {
    final session = await AudioSession.instance;
    await session.configure(
      const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.duckOthers,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.movie,
          usage: AndroidAudioUsage.media,
        ),
        androidAudioFocusGainType:
            AndroidAudioFocusGainType.gainTransientMayDuck,
      ),
    );

    try {
      debugPrint('🔔 AlarmService: Attempting to trigger alarm...');
      // Ensure any previous playback is stopped
      await _player.stop();

      debugPrint(
        '🔔 AlarmService: Loading asset: assets/audio/alarm_default.mp3',
      );
      await _player.setAsset('assets/audio/alarm_default.mp3');
      await _player.setLoopMode(LoopMode.one);
      await _player.setVolume(1.0);

      debugPrint('🔔 AlarmService: Starting playback...');
      await _player.play();
      debugPrint('🔔 AlarmService: Playback started successfully');
    } catch (e, stackTrace) {
      debugPrint('⚠️ AlarmService: Failed to play alarm: $e');
      debugPrint('⚠️ AlarmService: StackTrace: $stackTrace');
    }
  }

  Future<void> stopAlarm() async {
    debugPrint('🔕 Stopping alarm');
    await _player.stop();
  }
}
