
import 'package:foodora/core/utils/result.dart';

import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Result<UserEntity>> login(String email, String password);
  Future<Result<UserEntity>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  });
  Future<Result<UserEntity>> refreshToken();
  Future<Result<UserEntity>> getUser();
  Future<Result<UserEntity>> updateProfile({required String name, required String phone});
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
