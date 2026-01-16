import 'package:foodora/core/utils/result.dart';
import 'package:foodora/features/auth/domain/entities/user_entity.dart';
import 'package:foodora/features/auth/domain/repositories/auth_repository.dart';

class GetUserUseCase {
  final AuthRepository repository;

  GetUserUseCase(this.repository);

  Future<Result<UserEntity>> call() async {
    return await repository.getUser();
  }
}
