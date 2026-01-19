import '../entities/cart_item_entity.dart';

abstract class CartRepository {
  Future<void> saveCartItems(int userId, List<CartItemEntity> items);
  Future<List<CartItemEntity>> loadCartItems(int userId);
  Future<void> clearCartItems(int userId);
  Future<bool> hasCartItems(int userId);
}
