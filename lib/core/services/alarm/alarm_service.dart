import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

class AlarmService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> triggerAlarm() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playback,
      avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.duckOthers,
      androidAudioAttributes: AndroidAudioAttributes(
        contentType: AndroidAudioContentType.sonification,
        usage: AndroidAudioUsage.alarm,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gainTransientMayDuck,
    ));

    // Try to play alarm asset. Use try-catch if asset is missing.
    try {
      debugPrint('🔔 Triggering alarm...');
      await _player.setAsset('assets/audio/alarm_default.mp3');
      await _player.setLoopMode(LoopMode.one);
      await _player.setVolume(1.0);
      await _player.play();
    } catch (e) {
      debugPrint('⚠️ Failed to play alarm: $e');
      debugPrint('Please ensure assets/audio/alarm_default.mp3 exists.');
    }
  }

  Future<void> stopAlarm() async {
    debugPrint('🔕 Stopping alarm');
    await _player.stop();
  }
}
