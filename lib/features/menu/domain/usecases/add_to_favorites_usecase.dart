import 'package:foodora/core/utils/result.dart';
import 'package:foodora/features/menu/domain/entities/favorite_entity.dart';
import 'package:foodora/features/menu/domain/repositories/menu_repository.dart';

class AddToFavoritesUseCase {
  final MenuRepository repository;

  AddToFavoritesUseCase(this.repository);

  Future<Result<FavoriteEntity>> call(int menuItemId) {
    return repository.addToFavorites(menuItemId);
  }
}
