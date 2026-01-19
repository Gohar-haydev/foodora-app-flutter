import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_datasource.dart';
import '../models/cart_item_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;

  CartRepositoryImpl({required this.localDataSource});

  @override
  Future<void> saveCartItems(int userId, List<CartItemEntity> items) async {
    final models = items.map((item) => CartItemModel.fromEntity(item)).toList();
    await localDataSource.saveCartItems(userId, models);
  }

  @override
  Future<List<CartItemEntity>> loadCartItems(int userId) async {
    final models = await localDataSource.loadCartItems(userId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> clearCartItems(int userId) async {
    await localDataSource.clearCartItems(userId);
  }

  @override
  Future<bool> hasCartItems(int userId) async {
    return await localDataSource.hasCartItems(userId);
  }
}
