import 'package:foodora/core/utils/result.dart';
import 'package:foodora/features/menu/domain/entities/branch_entity.dart';
import 'package:foodora/features/menu/domain/entities/category_entity.dart';
import 'package:foodora/features/menu/domain/entities/menu_item_entity.dart';
import 'package:foodora/features/menu/domain/entities/favorite_entity.dart';
import 'package:foodora/features/menu/domain/entities/favorites_list_entity.dart';

abstract class MenuRepository {
  Future<Result<List<BranchEntity>>> getBranches();
  Future<Result<List<CategoryEntity>>> getCategories(int branchId);
  Future<Result<List<MenuItemEntity>>> getMenuItems(int branchId);
  Future<Result<List<MenuItemEntity>>> getMenuItemsByCategory(int categoryId);
  Future<Result<FavoriteEntity>> addToFavorites(int menuItemId);
  Future<Result<FavoriteEntity>> removeFromFavorites(int menuItemId);
  Future<Result<FavoritesListEntity>> getFavorites(int page, int perPage);
  Future<Result<List<MenuItemEntity>>> searchMenuItems(String query);
  Future<Result<List<MenuItemEntity>>> getMenuItemsByCategoryFilter(int categoryId);
  Future<Result<MenuItemEntity>> getMenuItemDetails(int id);
}
