import 'package:foodora/core/utils/result.dart';
import 'package:foodora/features/menu/domain/entities/menu_item_entity.dart';
import 'package:foodora/features/menu/domain/repositories/menu_repository.dart';

class GetMenuItemDetailsUseCase {
  final MenuRepository repository;

  GetMenuItemDetailsUseCase(this.repository);

  Future<Result<MenuItemEntity>> call(int id) async {
    return await repository.getMenuItemDetails(id);
  }
}
