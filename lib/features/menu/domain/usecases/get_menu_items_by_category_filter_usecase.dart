import 'package:foodora/core/utils/result.dart';
import 'package:foodora/features/menu/domain/entities/menu_item_entity.dart';
import 'package:foodora/features/menu/domain/repositories/menu_repository.dart';

class GetMenuItemsByCategoryFilterUseCase {
  final MenuRepository repository;

  GetMenuItemsByCategoryFilterUseCase(this.repository);

  Future<Result<List<MenuItemEntity>>> call(int categoryId) {
    return repository.getMenuItemsByCategoryFilter(categoryId);
  }
}
