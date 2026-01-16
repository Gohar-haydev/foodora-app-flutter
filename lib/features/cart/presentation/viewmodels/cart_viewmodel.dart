import 'package:flutter/foundation.dart';

import '../../domain/entities/cart_item_entity.dart';
import '../../../menu/domain/entities/menu_item_entity.dart';
import '../../../menu/domain/entities/addon_entity.dart';
import '../../../order/domain/entities/order_entity.dart';

class CartViewModel extends ChangeNotifier {
  final List<CartItemEntity> _cartItems = [];
  // simple ID generator (timestamp + random)
  String _generateId() => '${DateTime.now().millisecondsSinceEpoch}_${(DateTime.now().microsecond)}';


  List<CartItemEntity> get cartItems => List.unmodifiable(_cartItems);

  double get totalAmount {
    return _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get deliveryFee => 2.00;
  double get tax => 1.50;
  
  double get grandTotal => totalAmount + deliveryFee + tax;

  void addToCart(MenuItemEntity menuItem, int quantity, List<AddonEntity> selectedAddons) {
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
  }

  void removeFromCart(String cartItemId) {
    _cartItems.removeWhere((item) => item.id == cartItemId);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  void incrementItem(String cartItemId) {
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
    }
  }

  void decrementItem(String cartItemId) {
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
      } else {
        // Option: remove if quantity goes to 0? Or just stay at 1?
        // Usually decrementing at 1 does nothing or removes. 
        // Let's remove for better UX or just keep at 1. 
        // User asked "adjust price with increment or decrement".
        // Let's keeping it at 1 for now, they can use delete button for removal, 
        // OR we can make decrement at 1 remove the item.
        // The static design had a delete button AND +/-. 
        // Screenshot shows +/-. 
        // I'll keep it min 1 to avoid accidental deletion.
      }
    }
  }

  OrderEntity? placeOrder() {
     if (_cartItems.isEmpty) return null;

     final order = OrderEntity(
       id: _generateId(),
       items: List.from(_cartItems),
       totalAmount: grandTotal,
       deliveryFee: deliveryFee,
       tax: tax,
       placedAt: DateTime.now(),
       status: 'Preparing',
     );

     clearCart();
     return order;
  }
}
