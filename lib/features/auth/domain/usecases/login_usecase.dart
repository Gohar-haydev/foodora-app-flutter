
import 'package:foodora/core/utils/result.dart';

import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Result<UserEntity>> call(String email, String password) async {
    // You can add business logic validation here before calling repo
    if (email.isEmpty || password.isEmpty) {
      // Return validation failure...
    }
    return await repository.login(email, password);
  }
}
