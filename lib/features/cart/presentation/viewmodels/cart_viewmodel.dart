import 'package:flutter/foundation.dart';

import '../../domain/entities/cart_item_entity.dart';
import '../../../menu/domain/entities/menu_item_entity.dart';
import '../../../menu/domain/entities/addon_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../../../core/utils/token_storage.dart';

class CartViewModel extends ChangeNotifier {
  final CartRepository cartRepository;
  
  CartViewModel({required this.cartRepository}) {
    _loadCartFromStorage();
  }

  final List<CartItemEntity> _cartItems = [];
  bool _isLoading = false;
  
  // simple ID generator (timestamp + random)
  String _generateId() => '${DateTime.now().millisecondsSinceEpoch}_${(DateTime.now().microsecond)}';

  List<CartItemEntity> get cartItems => List.unmodifiable(_cartItems);
  bool get isLoading => _isLoading;

  double get totalAmount {
    return _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get deliveryFee => 2.00;
  double get tax => 1.50;
  
  double get grandTotal => totalAmount + deliveryFee + tax;

  // Load cart from storage on initialization
  Future<void> _loadCartFromStorage() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userId = await TokenStorage.getUserId();
      if (userId != null) {
        final items = await cartRepository.loadCartItems(userId);
        _cartItems.clear();
        _cartItems.addAll(items);
      }
    } catch (e) {
        print('Error loading cart from storage: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save cart to storage
  Future<void> _saveCartToStorage() async {
    try {
      final userId = await TokenStorage.getUserId();
      if (userId != null) {
        await cartRepository.saveCartItems(userId, _cartItems);
      }
    } catch (e) {
        print('Error saving cart to storage: $e');
    }
  }

  void addToCart(MenuItemEntity menuItem, int quantity, List<AddonEntity> selectedAddons) async {
    // Calculate price for this specific item configuration
    double basePrice = double.tryParse(menuItem.price) ?? 0.0;
    double addonsPrice = selectedAddons.fold(0.0, (sum, addon) {
      double price = double.tryParse(addon.price.toString()) ?? 0.0;
      return sum + price;
    });
    
    // Total unit price * quantity
    double totalItemPrice = (basePrice + addonsPrice) * quantity;

    final cartItem = CartItemEntity(
      id: _generateId(),
      menuItem: menuItem,
      quantity: quantity,
      selectedAddons: selectedAddons,
      totalPrice: totalItemPrice,
    );

    _cartItems.add(cartItem);
    notifyListeners();
    
    // Save to storage
    await _saveCartToStorage();
  }

  void removeFromCart(String cartItemId) async {
    _cartItems.removeWhere((item) => item.id == cartItemId);
    notifyListeners();
    
    // Save to storage
    await _saveCartToStorage();
  }

  void clearCart() async {
    _cartItems.clear();
    notifyListeners();
    
    // Clear from storage
    try {
      final userId = await TokenStorage.getUserId();
      if (userId != null) {
        await cartRepository.clearCartItems(userId);
      }
    } catch (e) {
        print('Error clearing cart from storage: $e');
    }
  }

  void incrementItem(String cartItemId) async {
    final index = _cartItems.indexWhere((item) => item.id == cartItemId);
    if (index != -1) {
      final currentItem = _cartItems[index];
      // Calculate unit price from current total / current quantity
      // Or safer: recalculate from base + addons
      double basePrice = double.tryParse(currentItem.menuItem.price) ?? 0.0;
      double addonsPrice = currentItem.selectedAddons.fold(0.0, (sum, addon) {
        double price = double.tryParse(addon.price.toString()) ?? 0.0;
        return sum + price;
      });
      double unitPrice = basePrice + addonsPrice;

      final newQuantity = currentItem.quantity + 1;
      final newTotal = unitPrice * newQuantity;

      _cartItems[index] = currentItem.copyWith(
        quantity: newQuantity,
        totalPrice: newTotal,
      );
      notifyListeners();
      
      // Save to storage
      await _saveCartToStorage();
    }
  }

  void decrementItem(String cartItemId) async {
    final index = _cartItems.indexWhere((item) => item.id == cartItemId);
    if (index != -1) {
      final currentItem = _cartItems[index];
      if (currentItem.quantity > 1) {
        double basePrice = double.tryParse(currentItem.menuItem.price) ?? 0.0;
        double addonsPrice = currentItem.selectedAddons.fold(0.0, (sum, addon) {
          double price = double.tryParse(addon.price.toString()) ?? 0.0;
          return sum + price;
        });
        double unitPrice = basePrice + addonsPrice;

        final newQuantity = currentItem.quantity - 1;
        final newTotal = unitPrice * newQuantity;

        _cartItems[index] = currentItem.copyWith(
          quantity: newQuantity,
          totalPrice: newTotal,
        );
        notifyListeners();
        
        // Save to storage
        await _saveCartToStorage();
      } else {
        // Option: remove if quantity goes to 0? Or just stay at 1?
        // Usually decrementing at 1 does nothing or removes. 
        // Let's keep it at 1 for now, they can use delete button for removal
      }
    }
  }

}
