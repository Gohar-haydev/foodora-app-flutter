import 'package:foodora/core/utils/result.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<Result<void>> call() async {
    return await repository.logout();
  }
}
