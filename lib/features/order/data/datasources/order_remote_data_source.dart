import '../models/order_model.dart';
import '../models/order_request_model.dart';
import '../models/order_tracking_model.dart';

abstract class OrderRemoteDataSource {
  Future<OrderModel> createOrder(OrderRequestModel request);
  Future<OrderModel> getOrderById(int orderId);
  Future<List<OrderModel>> getOrders({int page = 1});
  Future<OrderTrackingModel> trackOrder(int orderId);
  Future<void> cancelOrder(int orderId, String reason);
}
