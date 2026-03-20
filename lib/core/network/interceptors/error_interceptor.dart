import 'package:dio/dio.dart';
import '../../errors/exceptions.dart';

/// Interceptor that maps HTTP errors to app-specific exceptions.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw NetworkException('Connection timeout. Please try again.');
      case DioExceptionType.badResponse:
        _handleBadResponse(err);
        break;
      case DioExceptionType.connectionError:
        throw NetworkException('No internet connection.');
      default:
        break;
    }
    handler.next(err);
  }

  void _handleBadResponse(DioException err) {
    final statusCode = err.response?.statusCode;
    switch (statusCode) {
      case 400:
        throw BadRequestException(err.response?.data?['message'] ?? 'Bad request');
      case 401:
        throw UnauthorizedException('Session expired. Please log in again.');
      case 403:
        throw ForbiddenException('You do not have permission.');
      case 404:
        throw NotFoundException('Resource not found.');
      case 500:
        throw ServerException('Server error. Please try again later.');
      default:
        throw ServerException('An unexpected error occurred.');
    }
  }
}
