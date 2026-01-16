import 'package:foodora/core/utils/result.dart';
import 'package:foodora/features/menu/domain/entities/favorites_list_entity.dart';
import 'package:foodora/features/menu/domain/repositories/menu_repository.dart';

class GetFavoritesUseCase {
  final MenuRepository repository;

  GetFavoritesUseCase(this.repository);

  Future<Result<FavoritesListEntity>> call({required int page, int perPage = 10}) {
    return repository.getFavorites(page, perPage);
  }
}
