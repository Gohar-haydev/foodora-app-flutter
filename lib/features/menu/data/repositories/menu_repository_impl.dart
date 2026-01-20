import 'package:foodora/core/errors/failure.dart';
import 'package:foodora/core/utils/result.dart';
import 'package:foodora/features/menu/data/datasources/menu_remote_data_source.dart';
import 'package:foodora/features/menu/domain/entities/branch_entity.dart';
import 'package:foodora/features/menu/domain/entities/category_entity.dart';
import 'package:foodora/features/menu/domain/entities/menu_item_entity.dart';
import 'package:foodora/features/menu/domain/entities/favorite_entity.dart';
import 'package:foodora/features/menu/domain/entities/favorites_list_entity.dart';
import 'package:foodora/features/menu/domain/repositories/menu_repository.dart';

class MenuRepositoryImpl implements MenuRepository {
  final MenuRemoteDataSource remoteDataSource;

  MenuRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<List<BranchEntity>>> getBranches() async {
    try {
      final branches = await remoteDataSource.getBranches();
      return Result.success(branches);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<CategoryEntity>>> getCategories(int branchId) async {
    try {
      final categories = await remoteDataSource.getCategories(branchId);
      return Result.success(categories);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<MenuItemEntity>>> getMenuItems(int branchId) async {
    try {
      final menuItems = await remoteDataSource.getMenuItems(branchId);
      return Result.success(menuItems);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<MenuItemEntity>>> getMenuItemsByCategory(int categoryId) async {
    try {
      final menuItems = await remoteDataSource.getMenuItemsByCategory(categoryId);
      return Result.success(menuItems);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<FavoriteEntity>> addToFavorites(int menuItemId) async {
    try {
      final favorite = await remoteDataSource.addToFavorites(menuItemId);
      return Result.success(favorite);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<FavoriteEntity>> removeFromFavorites(int menuItemId) async {
    try {
      final favorite = await remoteDataSource.removeFromFavorites(menuItemId);
      return Result.success(favorite);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<FavoritesListEntity>> getFavorites(int page, int perPage) async {
    try {
      final favoritesList = await remoteDataSource.getFavorites(page, perPage);
      return Result.success(favoritesList);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<MenuItemEntity>>> searchMenuItems(String query) async {
    try {
      final menuItems = await remoteDataSource.searchMenuItems(query);
      return Result.success(menuItems);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<MenuItemEntity>>> getMenuItemsByCategoryFilter(int categoryId) async {
    try {
      final menuItems = await remoteDataSource.getMenuItemsByCategoryFilter(categoryId);
      return Result.success(menuItems);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<MenuItemEntity>> getMenuItemDetails(int id) async {
    try {
      final menuItem = await remoteDataSource.getMenuItemDetails(id);
      return Result.success(menuItem);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }
  @override
  Future<Result<bool>> checkFavoriteStatus(int menuItemId) async {
    try {
      final response = await remoteDataSource.checkFavoriteStatus(menuItemId);
      return Result.success(response.data.isFavorite);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }
}
