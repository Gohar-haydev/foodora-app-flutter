import 'package:foodora/core/utils/result.dart';
import '../repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<Result<void>> call({
    required String otp,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    return await repository.resetPassword(
      otp: otp,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
  }
}
