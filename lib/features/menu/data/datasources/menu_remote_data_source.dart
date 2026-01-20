import 'package:foodora/features/menu/data/models/branch_model.dart';
import 'package:foodora/features/menu/data/models/category_model.dart';
import 'package:foodora/features/menu/data/models/menu_item_model.dart';
import 'package:foodora/features/menu/data/models/favorite_response_model.dart';
import 'package:foodora/features/menu/data/models/remove_favorite_response_model.dart';
import 'package:foodora/features/menu/data/models/favorites_list_response_model.dart';
import 'package:foodora/features/menu/data/models/favorite_check_response_model.dart';

abstract class MenuRemoteDataSource {
  Future<List<BranchModel>> getBranches();
  Future<List<CategoryModel>> getCategories(int branchId);
  Future<List<MenuItemModel>> getMenuItems(int branchId);
  Future<List<MenuItemModel>> getMenuItemsByCategory(int categoryId);
  Future<FavoriteResponseModel> addToFavorites(int menuItemId);
  Future<RemoveFavoriteResponseModel> removeFromFavorites(int menuItemId);
  Future<FavoritesListResponseModel> getFavorites(int page, int perPage);
  Future<List<MenuItemModel>> searchMenuItems(String query);
  Future<List<MenuItemModel>> getMenuItemsByCategoryFilter(int categoryId);
  Future<MenuItemModel> getMenuItemDetails(int id);
  Future<FavoriteCheckResponseModel> checkFavoriteStatus(int menuItemId);
}
