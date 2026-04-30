import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';

class ShakeDetectionService {
  StreamSubscription? _subscription;
  final _shakeController = StreamController<void>.broadcast();
  Stream<void> get onShakeDetected => _shakeController.stream;

  static const double _shakeThreshold = 15.0; // configurable
  static const int _minShakeCount = 3;
  int _shakeCount = 0;
  DateTime? _lastShakeTime;

  void startListening() {
    _subscription = accelerometerEventStream().listen((event) {
      final magnitude = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      if (magnitude > _shakeThreshold) {
        final now = DateTime.now();
        if (_lastShakeTime == null || now.difference(_lastShakeTime!).inMilliseconds > 500) {
          _shakeCount++;
          _lastShakeTime = now;
          if (_shakeCount >= _minShakeCount) {
            _shakeController.add(null);
            _shakeCount = 0;
          }
        }
      }
    });
  }

  void stopListening() {
    _subscription?.cancel();
    _shakeCount = 0;
  }

  void dispose() {
    _subscription?.cancel();
    _shakeController.close();
  }
}
