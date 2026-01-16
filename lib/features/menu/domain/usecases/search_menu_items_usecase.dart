import 'package:foodora/core/utils/result.dart';
import 'package:foodora/features/menu/domain/entities/menu_item_entity.dart';
import 'package:foodora/features/menu/domain/repositories/menu_repository.dart';

class SearchMenuItemsUseCase {
  final MenuRepository repository;

  SearchMenuItemsUseCase(this.repository);

  Future<Result<List<MenuItemEntity>>> call(String query) {
    return repository.searchMenuItems(query);
  }
}
