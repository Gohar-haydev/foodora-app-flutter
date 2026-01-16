import 'package:foodora/core/utils/result.dart';
import '../repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  Future<Result<void>> call(String email) async {
    return await repository.forgotPassword(email);
  }
}
