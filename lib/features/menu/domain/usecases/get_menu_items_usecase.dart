import 'package:foodora/core/utils/result.dart';
import 'package:foodora/features/menu/domain/entities/menu_item_entity.dart';
import 'package:foodora/features/menu/domain/repositories/menu_repository.dart';

class GetMenuItemsUseCase {
  final MenuRepository repository;

  GetMenuItemsUseCase(this.repository);

  Future<Result<List<MenuItemEntity>>> call(int branchId) async {
    return await repository.getMenuItems(branchId);
  }
}
