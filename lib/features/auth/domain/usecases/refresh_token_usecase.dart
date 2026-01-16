
import 'package:foodora/core/utils/result.dart';

import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RefreshTokenUseCase {
  final AuthRepository repository;

  RefreshTokenUseCase(this.repository);

  Future<Result<UserEntity>> call() async {
    return await repository.refreshToken();
  }
}
