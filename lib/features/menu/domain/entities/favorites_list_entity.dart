import 'package:foodora/features/menu/domain/entities/favorite_item_entity.dart';
import 'package:foodora/features/menu/domain/entities/pagination_entity.dart';

class FavoritesListEntity {
  final List<FavoriteItemEntity> favorites;
  final PaginationEntity pagination;

  FavoritesListEntity({
    required this.favorites,
    required this.pagination,
  });
}
