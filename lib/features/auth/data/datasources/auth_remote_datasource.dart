import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../../../../core/network/api_endpoints.dart';

/// Remote data source for authentication API calls.
abstract class AuthRemoteDataSource {
  Future<UserModel> register({
    required String email,
    required String password,
    required String confirmPassword,
  });
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> setupProfile({
    required String id,
    required String firstName,
    required String lastName,
  });
  Future<UserModel> changePassword({
    required String id,
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  });
  Future<UserModel> updateUser(UserModel user);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.register,
      data: {
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
      },
    );
    return UserModel.fromJson(response.data);
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );
    return UserModel.fromJson(response.data);
  }

  @override
  Future<UserModel> setupProfile({
    required String id,
    required String firstName,
    required String lastName,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.setupProfile,
      data: {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
      },
    );
    return UserModel.fromJson(response.data);
  }

  @override
  Future<UserModel> changePassword({
    required String id,
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.changePassword.replaceFirst('{id}', id),
      data: {
        'id': id,
        'oldPassword': oldPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      },
    );
    return UserModel.fromJson(response.data);
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    final response = await _dio.put(
      ApiEndpoints.updateUser,
      data: user.toJson(),
    );
    return UserModel.fromJson(response.data);
  }
}
