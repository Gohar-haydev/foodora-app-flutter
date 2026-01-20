import 'package:flutter/foundation.dart';
import 'package:foodora/features/order/domain/entities/order_entity.dart';
import 'package:foodora/features/order/domain/usecases/create_order_usecase.dart';
import 'package:foodora/features/order/domain/usecases/get_order_by_id_usecase.dart';
import 'package:foodora/features/order/domain/usecases/get_orders_usecase.dart';
import 'package:foodora/features/order/data/models/order_request_model.dart';

class OrderViewModel extends ChangeNotifier {
  final CreateOrderUseCase createOrderUseCase;
  final GetOrderByIdUseCase getOrderByIdUseCase;
  final GetOrdersUseCase getOrdersUseCase;
  
  OrderViewModel({
    required this.createOrderUseCase,
    required this.getOrderByIdUseCase,
    required this.getOrdersUseCase,
  });
  
  final List<OrderEntity> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;
  OrderEntity? _lastCreatedOrder;

  List<OrderEntity> get orders => List.unmodifiable(_orders);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  OrderEntity? get lastCreatedOrder => _lastCreatedOrder;

  void addOrder(OrderEntity order) {
    _orders.insert(0, order); // Add to top
    notifyListeners();
  }

  Future<bool> createOrder(OrderRequestModel request) async {
    _isLoading = true;
    _errorMessage = null;
    _lastCreatedOrder = null;
    notifyListeners();

    final result = await createOrderUseCase(request);

    return result.fold(
      (failure) {
        _isLoading = false;
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (order) {
        _isLoading = false;
        _lastCreatedOrder = order;
        addOrder(order);
        notifyListeners();
        return true;
      },
    );
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<OrderEntity?> getOrderById(int orderId) async {
    print('🟡 [ViewModel] getOrderById called with orderId: $orderId');
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    print('🟡 [ViewModel] Loading state set to true, notified listeners');

    final result = await getOrderByIdUseCase(orderId);
    print('🟡 [ViewModel] Use case returned result');

    return result.fold(
      (failure) {
        print('❌ [ViewModel] Failure occurred: ${failure.message}');
        _isLoading = false;
        _errorMessage = failure.message;
        notifyListeners();
        print('❌ [ViewModel] Error state set, notified listeners');
        return null;
      },
      (order) {
        print('✅ [ViewModel] Success! Order fetched');
        print('✅ [ViewModel] Order ID: ${order.id}');
        print('✅ [ViewModel] Order Number: ${order.orderNumber}');
        print('✅ [ViewModel] Status: ${order.status}');
        print('✅ [ViewModel] Total Amount: ${order.totalAmount}');
        print('✅ [ViewModel] Items count: ${order.items.length}');
        _isLoading = false;
        notifyListeners();
        print('✅ [ViewModel] Loading state set to false, notified listeners');
        return order;
      },
    );
  }

  Future<void> fetchOrders({int page = 1}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getOrdersUseCase(page: page);

    result.fold(
      (failure) {
        _isLoading = false;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (orders) {
        _isLoading = false;
        _orders.clear();
        _orders.addAll(orders);
        notifyListeners();
      },
    );
  }
}
