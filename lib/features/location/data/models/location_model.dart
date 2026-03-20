import '../../domain/entities/location_entity.dart';
class LocationModel extends LocationEntity {
  const LocationModel({required super.latitude, required super.longitude, super.timestamp});
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(latitude: json['latitude'], longitude: json['longitude'], timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null);
  }
}
