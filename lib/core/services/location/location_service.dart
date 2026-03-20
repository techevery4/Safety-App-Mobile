/// Location service — wraps geolocator for GPS operations.
class LocationService {
  bool _isTracking = false;

  bool get isTracking => _isTracking;

  /// Get the current GPS location.
  Future<Map<String, double>> getCurrentLocation() async {
    // TODO: implement using geolocator
    // Returns {'latitude': x, 'longitude': y}
    return {'latitude': 0.0, 'longitude': 0.0};
  }

  /// Start continuous location tracking.
  /// Location sharing obeys user settings — OFF = no sharing even in emergency.
  void startTracking() {
    // TODO: implement
    _isTracking = true;
  }

  /// Stop location tracking.
  void stopTracking() {
    // TODO: implement
    _isTracking = false;
  }

  /// Dispose resources.
  void dispose() {
    // TODO: implement
  }
}
