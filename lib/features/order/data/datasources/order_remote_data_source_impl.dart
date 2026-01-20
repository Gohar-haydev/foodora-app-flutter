import '../../../../core/network/api_service.dart';
import '../models/order_model.dart';
import '../models/order_request_model.dart';
import '../models/order_response_model.dart';
import '../models/order_list_response_model.dart';
import 'order_remote_data_source.dart';

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final ApiService apiService;

  OrderRemoteDataSourceImpl(this.apiService);

  @override
  Future<OrderModel> createOrder(OrderRequestModel request) async {
    final result = await apiService.post<OrderResponseModel>(
      endpoint: '/orders',
      body: request.toJson(),
      requireAuth: true,
      fromJson: (json) => OrderResponseModel.fromJson(json),
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (response) => response.data.order,
    );
  }

  @override
  Future<OrderModel> getOrderById(int orderId) async {
    print('🟣 [DataSource] getOrderById called with orderId: $orderId');
    print('🟣 [DataSource] Endpoint: /orders/$orderId');
    
    final result = await apiService.get<OrderResponseModel>(
      endpoint: '/orders/$orderId',
      requireAuth: true,
      fromJson: (json) => OrderResponseModel.fromJson(json),
    );

    print('🟣 [DataSource] API service returned result');
    
    return result.fold(
      (failure) {
        print('❌ [DataSource] API failure: ${failure.message}');
        throw Exception(failure.message);
      },
      (response) {
        print('✅ [DataSource] API success!');
        print('✅ [DataSource] Response success: ${response.success}');
        print('✅ [DataSource] Response message: ${response.message}');
        print('✅ [DataSource] Order ID: ${response.data.order.id}');
        print('✅ [DataSource] Order Number: ${response.data.order.orderNumber}');
        return response.data.order;
      },
    );
  }

  @override
  Future<List<OrderModel>> getOrders({int page = 1}) async {
    final result = await apiService.get<OrderListResponseModel>(
      endpoint: '/orders?page=$page',
      requireAuth: true,
      fromJson: (json) => OrderListResponseModel.fromJson(json),
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (response) => response.data,
    );
  }
}
