import 'package:foodora/core/network/api_service.dart';
import 'package:foodora/features/menu/data/models/branch_model.dart';
import 'package:foodora/features/menu/data/models/category_model.dart';
import 'package:foodora/features/menu/data/models/menu_item_model.dart';
import 'package:foodora/features/menu/data/models/favorite_request_model.dart';
import 'package:foodora/features/menu/data/models/favorite_response_model.dart';
import 'package:foodora/features/menu/data/models/remove_favorite_response_model.dart';
import 'package:foodora/features/menu/data/models/favorites_list_response_model.dart';
import 'package:foodora/features/menu/data/models/favorite_check_response_model.dart';
import 'package:foodora/features/menu/data/datasources/menu_remote_data_source.dart';

class MenuRemoteDataSourceImpl implements MenuRemoteDataSource {
  final ApiService apiService;

  MenuRemoteDataSourceImpl(this.apiService);

  @override
  Future<List<BranchModel>> getBranches() async {
    final result = await apiService.get<List<BranchModel>>(
      endpoint: '/branches',
      fromJson: (json) {
        final List<dynamic> data = json['data'];
        return data.map((e) => BranchModel.fromJson(e)).toList();
      },
    );
    
    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) => data,
    );
  }

  @override
  Future<List<CategoryModel>> getCategories(int branchId) async {
    final result = await apiService.get<List<CategoryModel>>(
      endpoint: '/branches/$branchId/categories',
      requireAuth: true,
      fromJson: (json) {
        final List<dynamic> data = json['data'];
        return data.map((e) => CategoryModel.fromJson(e)).toList();
      },
    );
    
    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) => data,
    );
  }

  @override
  Future<List<MenuItemModel>> getMenuItems(int branchId) async {
    final result = await apiService.get<List<MenuItemModel>>(
      endpoint: '/branches/$branchId/menu',
      requireAuth: true,
      fromJson: (json) {
        final List<dynamic> data = json['data'];
        return data.map((e) => MenuItemModel.fromJson(e)).toList();
      },
    );
    
    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) => data,
    );
  }

  @override
  Future<List<MenuItemModel>> getMenuItemsByCategory(int categoryId) async {
    final result = await apiService.get<List<MenuItemModel>>(
      endpoint: '/categories/$categoryId/menu-items',
      requireAuth: true,
      fromJson: (json) {
        final List<dynamic> data = json['data'];
        return data.map((e) => MenuItemModel.fromJson(e)).toList();
      },
    );
    
    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) => data,
    );
  }

  @override
  Future<FavoriteResponseModel> addToFavorites(int menuItemId) async {
    final request = FavoriteRequestModel(menuItemId: menuItemId);
    
    final result = await apiService.post<FavoriteResponseModel>(
      endpoint: '/favorites',
      body: request.toJson(),
      requireAuth: true,
      fromJson: (json) => FavoriteResponseModel.fromJson(json),
    );
    
    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) => data,
    );
  }

  @override
  Future<RemoveFavoriteResponseModel> removeFromFavorites(int menuItemId) async {
    final result = await apiService.delete<RemoveFavoriteResponseModel>(
      endpoint: '/favorites/$menuItemId',
      requireAuth: true,
      fromJson: (json) => RemoveFavoriteResponseModel.fromJson(json),
    );
    
    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) => data,
    );
  }

  @override
  Future<FavoritesListResponseModel> getFavorites(int page, int perPage) async {
    final result = await apiService.get<FavoritesListResponseModel>(
      endpoint: '/favorites?page=$page&per_page=$perPage',
      requireAuth: true,
      fromJson: (json) => FavoritesListResponseModel.fromJson(json),
    );
    
    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) => data,
    );
  }

  @override
  Future<List<MenuItemModel>> searchMenuItems(String query) async {
    final result = await apiService.get<List<MenuItemModel>>(
      endpoint: '/menu?search=$query',
      requireAuth: true,
      fromJson: (json) {
        final List<dynamic> data = json['data'];
        return data.map((e) => MenuItemModel.fromJson(e)).toList();
      },
    );
    
    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) => data,
    );
  }

  @override
  Future<List<MenuItemModel>> getMenuItemsByCategoryFilter(int categoryId) async {
    final result = await apiService.get<List<MenuItemModel>>(
      endpoint: '/menu?category_id=$categoryId',
      requireAuth: true,
      fromJson: (json) {
        final List<dynamic> data = json['data'];
        return data.map((e) => MenuItemModel.fromJson(e)).toList();
      },
    );
    
    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) => data,
    );
  }
  @override
  Future<MenuItemModel> getMenuItemDetails(int id) async {
    final result = await apiService.get<MenuItemModel>(
      endpoint: '/menu-items/$id',
      requireAuth: true,
      fromJson: (json) {
        return MenuItemModel.fromJson(json['data']);
      },
    );
    
    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) => data,
    );
  }
  @override
  Future<FavoriteCheckResponseModel> checkFavoriteStatus(int menuItemId) async {
    final result = await apiService.get<FavoriteCheckResponseModel>(
      endpoint: '/favorites/check/$menuItemId',
      requireAuth: true,
      fromJson: (json) => FavoriteCheckResponseModel.fromJson(json),
    );
    
    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) => data,
    );
  }
}

