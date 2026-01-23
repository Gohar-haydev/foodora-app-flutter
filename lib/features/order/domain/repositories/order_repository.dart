import 'package:foodora/core/utils/result.dart';
import '../entities/order_entity.dart';
import '../../data/models/order_request_model.dart';
import '../../domain/entities/order_tracking_entity.dart';

abstract class OrderRepository {
  Future<Result<OrderEntity>> createOrder(OrderRequestModel request);
  Future<Result<OrderEntity>> getOrderById(int orderId);
  Future<Result<List<OrderEntity>>> getOrders({int page = 1});
  Future<Result<OrderTrackingEntity>> trackOrder(int orderId);
  Future<Result<void>> cancelOrder(int orderId, String reason);
}
