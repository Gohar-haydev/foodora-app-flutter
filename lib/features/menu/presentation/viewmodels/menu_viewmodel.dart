import 'package:flutter/material.dart';
import 'package:foodora/features/menu/domain/entities/branch_entity.dart';
import 'package:foodora/features/menu/domain/entities/category_entity.dart';
import 'package:foodora/features/menu/domain/entities/menu_item_entity.dart';
import 'package:foodora/features/menu/domain/entities/favorite_item_entity.dart';
import 'package:foodora/features/menu/domain/usecases/get_branches_usecase.dart';
import 'package:foodora/features/menu/domain/usecases/get_categories_usecase.dart';
import 'package:foodora/features/menu/domain/usecases/get_menu_items_usecase.dart';
import 'package:foodora/features/menu/domain/usecases/get_menu_items_by_category_usecase.dart';
import 'package:foodora/features/menu/domain/usecases/add_to_favorites_usecase.dart';
import 'package:foodora/features/menu/domain/usecases/remove_from_favorites_usecase.dart';
import 'package:foodora/features/menu/domain/usecases/get_favorites_usecase.dart';
import 'package:foodora/features/menu/domain/usecases/search_menu_items_usecase.dart';
import 'package:foodora/features/menu/domain/usecases/get_menu_items_by_category_filter_usecase.dart';
import 'package:foodora/features/menu/domain/usecases/get_menu_item_details_usecase.dart';
import 'package:foodora/features/menu/domain/usecases/check_favorite_status_usecase.dart';

class MenuViewModel extends ChangeNotifier {
  final GetBranchesUseCase getBranchesUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetMenuItemsUseCase getMenuItemsUseCase;
  final GetMenuItemsByCategoryUseCase getMenuItemsByCategoryUseCase;
  final AddToFavoritesUseCase addToFavoritesUseCase;
  final RemoveFromFavoritesUseCase removeFromFavoritesUseCase;
  final GetFavoritesUseCase getFavoritesUseCase;
  final SearchMenuItemsUseCase searchMenuItemsUseCase;
  final GetMenuItemsByCategoryFilterUseCase getMenuItemsByCategoryFilterUseCase;
  final GetMenuItemDetailsUseCase getMenuItemDetailsUseCase;
  final CheckFavoriteStatusUseCase checkFavoriteStatusUseCase;

  MenuViewModel({
    required this.getBranchesUseCase,
    required this.getCategoriesUseCase,
    required this.getMenuItemsUseCase,
    required this.getMenuItemsByCategoryUseCase,
    required this.addToFavoritesUseCase,
    required this.removeFromFavoritesUseCase,
    required this.getFavoritesUseCase,
    required this.searchMenuItemsUseCase,
    required this.getMenuItemsByCategoryFilterUseCase,
    required this.getMenuItemDetailsUseCase,
    required this.checkFavoriteStatusUseCase,
  });

  List<BranchEntity> _branches = [];
  bool _isLoading = false;
  String? _error;

  List<CategoryEntity> _categories = [];
  bool _isCategoriesLoading = false;
  String? _categoriesError;

  List<MenuItemEntity> _menuItems = [];
  bool _isMenuItemsLoading = false;
  String? _menuItemsError;

  // Favorites state
  Set<int> _favoriteItemIds = {};
  bool _isAddingToFavorites = false;
  String? _favoritesError;

  // Favorites list state
  List<FavoriteItemEntity> _favoriteItems = [];
  bool _isFavoritesLoading = false;
  bool _isFavoritesLoadingMore = false;
  String? _favoritesListError;
  int _favoritesCurrentPage = 1;
  bool _hasFavoritesMore = true;

  List<MenuItemEntity> _searchResults = [];
  bool _isSearching = false;
  String? _searchError;

  // Single Item Details
  MenuItemEntity? _selectedMenuItem;
  bool _isMenuItemDetailsLoading = false;
  String? _menuItemDetailsError;

  List<BranchEntity> get branches => _branches;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<CategoryEntity> get categories => _categories;
  bool get isCategoriesLoading => _isCategoriesLoading;
  String? get categoriesError => _categoriesError;

  List<MenuItemEntity> get menuItems => _menuItems;
  bool get isMenuItemsLoading => _isMenuItemsLoading;
  String? get menuItemsError => _menuItemsError;

  bool get isAddingToFavorites => _isAddingToFavorites;
  String? get favoritesError => _favoritesError;

  List<FavoriteItemEntity> get favoriteItems => _favoriteItems;
  bool get isFavoritesLoading => _isFavoritesLoading;
  bool get isFavoritesLoadingMore => _isFavoritesLoadingMore;
  String? get favoritesListError => _favoritesListError;
  bool get hasFavoritesMore => _hasFavoritesMore;

  List<MenuItemEntity> get searchResults => _searchResults;
  bool get isSearching => _isSearching;
  String? get searchError => _searchError;

  MenuItemEntity? get selectedMenuItem => _selectedMenuItem;
  bool get isMenuItemDetailsLoading => _isMenuItemDetailsLoading;
  String? get menuItemDetailsError => _menuItemDetailsError;

  Future<void> fetchBranches() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await getBranchesUseCase();

    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
      },
      (branches) {
        _branches = branches;
        _isLoading = false;
      },
    );
    notifyListeners();
  }

  Future<void> fetchCategories(int branchId) async {
    _isCategoriesLoading = true;
    _categoriesError = null;
    notifyListeners();

    final result = await getCategoriesUseCase(branchId);

    result.fold(
      (failure) {
        _categoriesError = failure.message;
        _isCategoriesLoading = false;
      },
      (categories) {
        _categories = categories;
        _isCategoriesLoading = false;
      },
    );
    notifyListeners();
  }

  Future<void> fetchMenuItems(int branchId) async {
    _isMenuItemsLoading = true;
    _menuItemsError = null;
    notifyListeners();

    final result = await getMenuItemsUseCase(branchId);

    result.fold(
      (failure) {
        _menuItemsError = failure.message;
        _isMenuItemsLoading = false;
      },
      (menuItems) {
        _menuItems = menuItems;
        _isMenuItemsLoading = false;
      },
    );
    notifyListeners();
  }

  Future<void> fetchMenuItemsByCategory(int categoryId) async {
    _isMenuItemsLoading = true;
    _menuItemsError = null;
    notifyListeners();

    final result = await getMenuItemsByCategoryUseCase(categoryId);

    result.fold(
      (failure) {
        _menuItemsError = failure.message;
        _isMenuItemsLoading = false;
      },
      (menuItems) {
        _menuItems = menuItems;
        _isMenuItemsLoading = false;
      },
    );
    notifyListeners();
  }

  // Toggle favorite (add or remove based on current state)
  Future<String?> toggleFavorite(int menuItemId) async {
    if (isFavorite(menuItemId)) {
      return await removeFromFavorites(menuItemId);
    } else {
      return await addToFavorites(menuItemId);
    }
  }

  // Add item to favorites
  Future<String?> addToFavorites(int menuItemId) async {
    _isAddingToFavorites = true;
    _favoritesError = null;
    notifyListeners();

    final result = await addToFavoritesUseCase(menuItemId);

    String? message;
    result.fold(
      (failure) {
        _favoritesError = failure.message;
        message = failure.message;
        _isAddingToFavorites = false;
      },
      (favorite) {
        _favoriteItemIds.add(menuItemId);
        message = favorite.message;
        _isAddingToFavorites = false;
      },
    );
    
    notifyListeners();
    return message;
  }

  // Remove item from favorites
  Future<String?> removeFromFavorites(int menuItemId) async {
    _isAddingToFavorites = true;
    _favoritesError = null;
    notifyListeners();

    final result = await removeFromFavoritesUseCase(menuItemId);

    String? message;
    result.fold(
      (failure) {
        _favoritesError = failure.message;
        message = failure.message;
        _isAddingToFavorites = false;
      },
      (favorite) {
        _favoriteItemIds.remove(menuItemId);
        message = favorite.message;
        _isAddingToFavorites = false;
      },
    );
    
    notifyListeners();
    return message;
  }

  // Check if item is favorited
  bool isFavorite(int menuItemId) {
    return _favoriteItemIds.contains(menuItemId);
  }

  // Fetch favorites list with pagination
  Future<void> fetchFavoritesList({required int page}) async {
    if (page == 1) {
      _isFavoritesLoading = true;
      _favoriteItems = [];
    }
    _favoritesListError = null;
    notifyListeners();

    final result = await getFavoritesUseCase(page: page, perPage: 10);

    result.fold(
      (failure) {
        _favoritesListError = failure.message;
        _isFavoritesLoading = false;
        _isFavoritesLoadingMore = false;
      },
      (favoritesList) {
        if (page == 1) {
          _favoriteItems = favoritesList.favorites;
        } else {
          _favoriteItems.addAll(favoritesList.favorites);
        }
        _favoritesCurrentPage = favoritesList.pagination.currentPage;
        _hasFavoritesMore = favoritesList.pagination.hasMore;
        _isFavoritesLoading = false;
        _isFavoritesLoadingMore = false;
      },
    );
    notifyListeners();
  }

  // Load more favorites (for pagination)
  Future<void> loadMoreFavorites() async {
    if (!_hasFavoritesMore || _isFavoritesLoadingMore) return;

    _isFavoritesLoadingMore = true;
    notifyListeners();

    await fetchFavoritesList(page: _favoritesCurrentPage + 1);
  }

  // Search menu items
  Future<void> searchMenuItems(String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      _searchError = null;
      notifyListeners();
      return;
    }

    _isSearching = true;
    _searchError = null;
    notifyListeners();

    final result = await searchMenuItemsUseCase(query);

    result.fold(
      (failure) {
        _searchError = failure.message;
        _isSearching = false;
      },
      (items) {
        _searchResults = items;
        _isSearching = false;
      },
    );
    notifyListeners();
  }

  // Get menu items by category filter
  Future<void> filterByCategory(int categoryId) async {
    _isSearching = true;
    _searchError = null;
    notifyListeners();

    final result = await getMenuItemsByCategoryFilterUseCase(categoryId);

    result.fold(
      (failure) {
        _searchError = failure.message;
        _isSearching = false;
      },
      (items) {
        _searchResults = items;
        _isSearching = false;
      },
    );
    notifyListeners();
  }

  // Clear search
  void clearSearch() {
    _searchResults = [];
    _searchError = null;
    _isSearching = false;
    notifyListeners();
  }

  // Fetch single menu item details
  Future<void> fetchMenuItemDetails(int id) async {
    _isMenuItemDetailsLoading = true;
    _menuItemDetailsError = null;
    // Don't clear selectedMenuItem immediately to allow keeping previous data while loading if needed,
    // or clear it if we want fresh state. Let's clear it to avoid showing old data.
    _selectedMenuItem = null; 
    notifyListeners();

    final result = await getMenuItemDetailsUseCase(id);

    result.fold(
      (failure) {
        _menuItemDetailsError = failure.message;
        _isMenuItemDetailsLoading = false;
      },
      (item) {
        _selectedMenuItem = item;
        _isMenuItemDetailsLoading = false;
      },
    );
    notifyListeners();
  }

  // Check specific item favorite status from server
  Future<void> checkFavoriteStatus(int menuItemId) async {
    final result = await checkFavoriteStatusUseCase(menuItemId);

    result.fold(
      (failure) {
        // Log failure but don't disrupt UI flow significantly as this is often a background check
        print('Check favorite status failed: ${failure.message}');
      },
      (isFavorite) {
        if (isFavorite) {
          _favoriteItemIds.add(menuItemId);
        } else {
          _favoriteItemIds.remove(menuItemId);
        }
        notifyListeners();
      },
    );
  }
}
