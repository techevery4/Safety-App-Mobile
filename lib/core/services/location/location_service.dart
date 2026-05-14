import 'dart:async';
import 'package:geolocator/geolocator.dart';

/// Location service — wraps geolocator for GPS operations.
@pragma('vm:keep')
class LocationService {
  StreamSubscription<Position>? _positionSubscription;
  final _positionController = StreamController<Position>.broadcast();

  Stream<Position> get positionStream => _positionController.stream;
  Position? _lastPosition;
  Position? get lastPosition => _lastPosition;

  /// Call once on app start to check/request permissions
  Future<bool> requestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }
    if (permission == LocationPermission.deniedForever) return false;
    return true;
  }

  /// Get a single current position
  Future<Position?> getCurrentPosition() async {
    final hasPermission = await requestPermission();
    if (!hasPermission) return null;
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    _lastPosition = position;
    return position;
  }

  /// Start streaming position updates
  /// Emits a new position every time user moves more than [distanceFilter] metres
  void startTracking({double distanceFilter = 10.0}) {
    _positionSubscription?.cancel();
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilter.toInt(), // metres
      ),
    ).listen((position) {
      _lastPosition = position;
      _positionController.add(position);
    });
  }

  void stopTracking() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  /// Format position for display
  static String formatCoordinates(Position position) {
    final lat = position.latitude.toStringAsFixed(4);
    final lng = position.longitude.toStringAsFixed(4);
    final latDir = position.latitude >= 0 ? 'N' : 'S';
    final lngDir = position.longitude >= 0 ? 'E' : 'W';
    return 'LAT:$lat$latDir | LONG:$lng$lngDir';
  }

  void dispose() {
    _positionSubscription?.cancel();
    _positionController.close();
  }
}
