import 'package:foodora/core/utils/result.dart';
import 'package:foodora/features/auth/domain/entities/user_entity.dart';
import 'package:foodora/features/auth/domain/repositories/auth_repository.dart';

class UpdateProfileUseCase {
  final AuthRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Result<UserEntity>> call({required String name, required String phone}) async {
    return await repository.updateProfile(name: name, phone: phone);
  }
}
