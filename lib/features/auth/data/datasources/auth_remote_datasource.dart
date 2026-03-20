/// Remote data source for authentication API calls.
abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> register({required String email, required String password});
  Future<Map<String, dynamic>> login({required String email, required String password});
  Future<Map<String, dynamic>> verifyOtp({required String email, required String otp});
  Future<void> resendOtp({required String email});
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // TODO: inject Dio/ApiClient
  @override
  Future<Map<String, dynamic>> register({required String email, required String password}) async {
    // TODO: implement API call
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> login({required String email, required String password}) async {
    // TODO: implement
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> verifyOtp({required String email, required String otp}) async {
    // TODO: implement
    throw UnimplementedError();
  }

  @override
  Future<void> resendOtp({required String email}) async {
    // TODO: implement
  }

  @override
  Future<void> logout() async {
    // TODO: implement
  }
}
