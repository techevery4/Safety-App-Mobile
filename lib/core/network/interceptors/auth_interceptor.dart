import 'package:dio/dio.dart';

/// Interceptor that attaches Bearer token to outgoing requests.
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // TODO: implement — retrieve token from secure storage and attach
    // final token = await secureStorage.read(key: 'auth_token');
    // if (token != null) {
    //   options.headers['Authorization'] = 'Bearer $token';
    // }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // TODO: implement — handle 401 (token refresh logic)
    handler.next(err);
  }
}
