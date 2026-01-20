import 'package:foodora/core/utils/result.dart';
import 'package:foodora/features/menu/domain/repositories/menu_repository.dart';

class CheckFavoriteStatusUseCase {
  final MenuRepository repository;

  CheckFavoriteStatusUseCase(this.repository);

  Future<Result<bool>> call(int menuItemId) async {
    return await repository.checkFavoriteStatus(menuItemId);
  }
}
