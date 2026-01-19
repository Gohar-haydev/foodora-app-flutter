import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item_model.dart';

class CartLocalDataSource {
  static const String _cartKeyPrefix = 'cart_user_';

  // Get the storage key for a specific user
  String _getCartKey(int userId) => '$_cartKeyPrefix$userId';

  // Save cart items for a specific user
  Future<void> saveCartItems(int userId, List<CartItemModel> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartKey = _getCartKey(userId);
      
      // Convert items to JSON
      final jsonList = items.map((item) => item.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      
      await prefs.setString(cartKey, jsonString);
    } catch (e) {
      throw Exception('Failed to save cart items: $e');
    }
  }

  // Load cart items for a specific user
  Future<List<CartItemModel>> loadCartItems(int userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartKey = _getCartKey(userId);
      
      final jsonString = prefs.getString(cartKey);
      
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }
      
      // Parse JSON
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => CartItemModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // If there's an error parsing, return empty list and clear corrupted data
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_getCartKey(userId));
      return [];
    }
  }

  // Clear cart items for a specific user
  Future<void> clearCartItems(int userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartKey = _getCartKey(userId);
      await prefs.remove(cartKey);
    } catch (e) {
      throw Exception('Failed to clear cart items: $e');
    }
  }

  // Check if cart exists for a user
  Future<bool> hasCartItems(int userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartKey = _getCartKey(userId);
      return prefs.containsKey(cartKey);
    } catch (e) {
      return false;
    }
  }
}
