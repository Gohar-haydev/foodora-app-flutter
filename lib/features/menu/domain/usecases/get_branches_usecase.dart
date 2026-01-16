import 'package:foodora/core/utils/result.dart';
import 'package:foodora/features/menu/domain/entities/branch_entity.dart';
import 'package:foodora/features/menu/domain/repositories/menu_repository.dart';

class GetBranchesUseCase {
  final MenuRepository repository;

  GetBranchesUseCase(this.repository);

  Future<Result<List<BranchEntity>>> call() async {
    return await repository.getBranches();
  }
}
