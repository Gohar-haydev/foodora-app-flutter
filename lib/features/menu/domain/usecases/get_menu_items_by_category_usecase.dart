import 'package:foodora/core/utils/result.dart';
import 'package:foodora/features/menu/domain/entities/menu_item_entity.dart';
import 'package:foodora/features/menu/domain/repositories/menu_repository.dart';

class GetMenuItemsByCategoryUseCase {
  final MenuRepository repository;

  GetMenuItemsByCategoryUseCase(this.repository);

  Future<Result<List<MenuItemEntity>>> call(int categoryId) async {
    return await repository.getMenuItemsByCategory(categoryId);
  }
}
