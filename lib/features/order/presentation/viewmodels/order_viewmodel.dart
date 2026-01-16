import 'package:flutter/foundation.dart';
import 'package:foodora/features/order/domain/entities/order_entity.dart';

class OrderViewModel extends ChangeNotifier {
  final List<OrderEntity> _orders = [];

  List<OrderEntity> get orders => List.unmodifiable(_orders);

  void addOrder(OrderEntity order) {
    _orders.insert(0, order); // Add to top
    notifyListeners();
  }
}
