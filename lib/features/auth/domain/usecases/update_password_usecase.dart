import 'package:foodora/core/utils/result.dart';
import 'package:foodora/features/auth/domain/repositories/auth_repository.dart';

class UpdatePasswordUseCase {
  final AuthRepository repository;

  UpdatePasswordUseCase(this.repository);

  Future<Result<void>> call({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return await repository.updatePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
  }
}
