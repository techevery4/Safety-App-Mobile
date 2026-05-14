import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';

@pragma('vm:keep')
class ShakeDetectionService {
  StreamSubscription? _subscription;
  final _shakeController = StreamController<void>.broadcast();
  Stream<void> get onShakeDetected => _shakeController.stream;

  static const double _shakeThreshold = 10.0;
  static const int _minShakeCount = 1;
  static const int _shakeWindowMs = 2000;
  static const int _minMsBetweenShakes = 300;

  int _shakeCount = 0;
  DateTime? _firstShakeTime;
  DateTime? _lastShakeTime;
  Timer? _resetTimer;

  double _lastX = 0;
  double _lastY = 0;
  double _lastZ = 0;

  void startListening() {
    _subscription = userAccelerometerEventStream().listen((event) {
      final magnitude = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );

      if (magnitude > 5.0) {
        debugPrint('🫨 Shake magnitude: ${magnitude.toStringAsFixed(2)}');
      }

      if (magnitude > _shakeThreshold) {
        // A real shake reverses direction on at least one axis.
        // Lifting the phone or a single jerk does not — it's one-directional.
        final reversedX =
            (_lastX > 0 && event.x < 0) || (_lastX < 0 && event.x > 0);
        final reversedY =
            (_lastY > 0 && event.y < 0) || (_lastY < 0 && event.y > 0);
        final isReversal = reversedX || reversedY;

        // Update tracked direction regardless
        _lastX = event.x;
        _lastY = event.y;
        _lastZ = event.z;

        // Ignore spikes with no direction reversal
        if (!isReversal) {
          debugPrint('🫨 High magnitude but no reversal — ignored');
          return;
        }

        final now = DateTime.now();

        if (_firstShakeTime == null ||
            now.difference(_firstShakeTime!).inMilliseconds > _shakeWindowMs) {
          // Start a fresh shake window
          debugPrint('🫨 First shake detected — window started');
          _shakeCount = 1;
          _firstShakeTime = now;
          _lastShakeTime = now;
          _startResetTimer();
        } else if (now.difference(_lastShakeTime!).inMilliseconds >
            _minMsBetweenShakes) {
          // Count as a new shake only if enough time has passed since the last one
          _shakeCount++;
          _lastShakeTime = now;
          debugPrint('🫨 Shake count: $_shakeCount');
        }

        if (_shakeCount >= _minShakeCount) {
          debugPrint('🚨 SOS TRIGGERED BY SHAKE!');
          _shakeController.add(null);
          _shakeCount = 0;
          _firstShakeTime = null;
          _lastShakeTime = null;
          _resetTimer?.cancel();
        }
      } else {
        // Track direction even on sub-threshold readings so the first
        // above-threshold reading has a valid previous direction to compare against
        _lastX = event.x;
        _lastY = event.y;
        _lastZ = event.z;
      }
    });
  }

  void _startResetTimer() {
    _resetTimer?.cancel();
    _resetTimer = Timer(const Duration(milliseconds: _shakeWindowMs), () {
      debugPrint('🫨 Shake window expired — resetting count');
      _shakeCount = 0;
      _firstShakeTime = null;
      _lastShakeTime = null;
    });
  }

  void stopListening() {
    _subscription?.cancel();
    _resetTimer?.cancel();
    _shakeCount = 0;
    _firstShakeTime = null;
    _lastShakeTime = null;
    _lastX = 0;
    _lastY = 0;
    _lastZ = 0;
  }

  void dispose() {
    _subscription?.cancel();
    _resetTimer?.cancel();
    _shakeCount = 0;
    _firstShakeTime = null;
    _lastShakeTime = null;
    _lastX = 0;
    _lastY = 0;
    _lastZ = 0;
    _shakeController.close();
  }
}
