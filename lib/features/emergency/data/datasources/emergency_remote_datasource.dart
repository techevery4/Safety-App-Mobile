abstract class EmergencyRemoteDataSource {
  Future<Map<String, dynamic>> triggerEmergency({required double latitude, required double longitude});
  Future<void> cancelEmergency({required String emergencyId});
}
class EmergencyRemoteDataSourceImpl implements EmergencyRemoteDataSource {
  @override
  Future<Map<String, dynamic>> triggerEmergency({required double latitude, required double longitude}) async { throw UnimplementedError(); }
  @override
  Future<void> cancelEmergency({required String emergencyId}) async { throw UnimplementedError(); }
}
