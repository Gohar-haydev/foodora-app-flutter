
import 'package:foodora/core/network/api_service.dart';
import 'package:foodora/core/utils/result.dart';
import 'package:foodora/core/utils/token_storage.dart';

import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Result<UserModel>> login(String email, String password);
  Future<Result<UserModel>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  });
  Future<Result<UserModel>> refreshToken();
  Future<Result<UserModel>> getUser();
  Future<Result<UserModel>> updateProfile({required String name, required String phone});
  Future<Result<void>> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  });
  Future<Result<void>> forgotPassword(String email);
  Future<Result<void>> resetPassword({
    required String password,
    required String confirmPassword,
  });
  Future<Result<void>> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService apiService;

  AuthRemoteDataSourceImpl({required this.apiService});

  @override
  Future<Result<UserModel>> login(String email, String password) async {
    return await apiService.post<UserModel>(
      endpoint: '/auth/login',
      body: {
        'email': email,
        'password': password,
      },
      fromJson: (json) => UserModel.fromJson(json),
    );
  }

  @override
  Future<Result<UserModel>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    return await apiService.post<UserModel>(
      endpoint: '/auth/register',
      body: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password, // Add password confirmation
        'phone': phone,
      },
      fromJson: (json) => UserModel.fromJson(json),
    );
  }

  @override
  Future<Result<UserModel>> refreshToken() async {
    return await apiService.post<UserModel>(
      endpoint: '/auth/refresh',
      body: {},
      requireAuth: true,
      fromJson: (json) => UserModel.fromJson(json),
    );
  }

  @override
  Future<Result<UserModel>> getUser() async {
    return await apiService.get<UserModel>(
      endpoint: '/auth/user',
      requireAuth: true,
      fromJson: (json) {
         // The API response for /auth/user wraps the user object in 'data' key
         // Based on: "data": { "id": 5, ... }
         // ApiService handles 'data' key extraction automatically if using fromJson correctly?
         // Let's check ApiService logic again.
         // ApiService: "if (decoded.containsKey('data')) { return Result.success(fromJson(decoded)); }"
         // Wait, ApiService passes the WHOLE decoded map to fromJson if 'data' exists?
         // No: "return Result.success(fromJson(decoded));" -> it passes 'decoded', which contains 'data'.
         // So fromJson needs to handle extraction or ApiService should extract 'data'.
         // Let's re-read ApiService carefully.
         // Line 86: return Result.success(fromJson(decoded));
         // It passes the FULL response body to fromJson.
         // So here, json is { success: true, message: ..., data: {...} }
         // So we need to access json['data'].
         // The API response for /auth/user wraps the user object in 'data' key
         // and returns flat user data (no token, no nested 'user' key)
         return UserModel.fromProfileJson(json['data']);
      },
    );
  }

  @override
  Future<Result<UserModel>> updateProfile({required String name, required String phone}) async {
    return await apiService.put<UserModel>(
      endpoint: '/auth/profile',
      body: {
        'name': name,
        'phone': phone,
      },
      requireAuth: true,
      fromJson: (json) {
         // Similar to getUser, user data is wrapped in 'data'
         return UserModel.fromProfileJson(json['data']);
      },
    );
  }

  @override
  Future<Result<void>> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return await apiService.put<void>(
      endpoint: '/auth/password',
      body: {
        'current_password': currentPassword,
        'password': newPassword,
        'password_confirmation': confirmPassword,
      },
      requireAuth: true,
      fromJson: (json) {
        // Data is null, so we just return void (null)
        return;
      },
    );
  }

  @override
  Future<Result<void>> forgotPassword(String email) async {
    return await apiService.post<void>(
      endpoint: '/auth/forgot-password',
      body: {
        'email': email,
      },
      fromJson: (json) {
        return;
      },
    );
  }

  @override
  Future<Result<void>> resetPassword({
    // required String token,
    // required String email,
    required String password,
    required String confirmPassword,
  }) async {
    return await apiService.post<void>(
      endpoint: '/auth/reset-password',
      body: {
        // 'token': token,
        // 'email': email,
        'password': password,
        'password_confirmation': confirmPassword,
      },
      fromJson: (json) {
        return;
      },
    );
  }

  @override
  Future<Result<void>> logout() async {
    return await apiService.post<void>(
      endpoint: '/auth/logout',
      body: {},
      requireAuth: true,
      fromJson: (json) => null,
    );
  }
}
