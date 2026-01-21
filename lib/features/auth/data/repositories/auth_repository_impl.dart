
import 'package:foodora/core/utils/result.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<UserEntity>> login(String email, String password) async {
    final result = await remoteDataSource.login(email, password);
    
    // Map UserModel to UserEntity (generic covariance handles this usually, but explicit result mapping is safer if types differ)
    return result.fold(
      (error) => Result.failure(error),
      (data) => Result.success(data),
    );
  }

  @override
  Future<Result<UserEntity>> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
  }) async {
    final result = await remoteDataSource.register(
      name: name,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      phone: phone,
    );
    
    return result.fold(
      (error) => Result.failure(error),
      (data) => Result.success(data),
    );
  }

  @override
  Future<Result<UserEntity>> refreshToken() async {
    final result = await remoteDataSource.refreshToken();
    
    return result.fold(
      (error) => Result.failure(error),
      (data) => Result.success(data),
    );
  }

  @override
  Future<Result<UserEntity>> getUser() async {
    final result = await remoteDataSource.getUser();
    
    return result.fold(
      (error) => Result.failure(error),
      (data) => Result.success(data),
    );

  }

  @override
  Future<Result<UserEntity>> updateProfile({required String name, required String phone}) async {
    final result = await remoteDataSource.updateProfile(name: name, phone: phone);
    
    return result.fold(
      (error) => Result.failure(error),
      (data) => Result.success(data),
    );

  }

  @override
  Future<Result<void>> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return await remoteDataSource.updatePassword(
      currentPassword: currentPassword, 
      newPassword: newPassword, 
      confirmPassword: confirmPassword
    );
  }

  @override
  Future<Result<void>> forgotPassword(String email) async {
    return await remoteDataSource.forgotPassword(email);
  }

  @override
  Future<Result<void>> resetPassword({
    required String otp,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    return await remoteDataSource.resetPassword(
      otp: otp,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
  }

  @override
  Future<Result<void>> logout() async {
    return await remoteDataSource.logout();
  }
}
