import 'package:foodora/features/menu/data/models/favorite_item_model.dart';
import 'package:foodora/features/menu/data/models/pagination_model.dart';
import 'package:foodora/features/menu/domain/entities/favorites_list_entity.dart';

class FavoritesListResponseModel extends FavoritesListEntity {
  FavoritesListResponseModel({
    required List<FavoriteItemModel> favorites,
    required PaginationModel pagination,
  }) : super(
          favorites: favorites,
          pagination: pagination,
        );

  factory FavoritesListResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final favoritesList = data['favorites'] as List<dynamic>;
    final paginationJson = data['pagination'] as Map<String, dynamic>;

    return FavoritesListResponseModel(
      favorites: favoritesList
          .map((item) => FavoriteItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      pagination: PaginationModel.fromJson(paginationJson),
    );
  }
}
