import 'package:foodora/core/utils/result.dart';
import 'package:foodora/features/menu/domain/entities/category_entity.dart';
import 'package:foodora/features/menu/domain/repositories/menu_repository.dart';

class GetCategoriesUseCase {
  final MenuRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<Result<List<CategoryEntity>>> call(int branchId) async {
    return await repository.getCategories(branchId);
  }
}
