
import 'package:foodora/core/errors/failure.dart';
import 'package:foodora/core/utils/result.dart';

import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Result<UserEntity>> call({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
  }) async {
    // Validation logic
    if (name.isEmpty) {
      return Result.failure(const ValidationFailure('Name is required'));
    }
    
    if (email.isEmpty || !_isValidEmail(email)) {
      return Result.failure(const ValidationFailure('Valid email is required'));
    }
    
    if (password.isEmpty || password.length < 6) {
      return Result.failure(const ValidationFailure('Password must be at least 6 characters'));
    }
    
    if (password != confirmPassword) {
      return Result.failure(const ValidationFailure('Passwords do not match'));
    }
    
    if (phone.isEmpty) {
      return Result.failure(const ValidationFailure('Phone number is required'));
    }
    
    return await repository.register(
      name: name,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      phone: phone,
    );
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}
