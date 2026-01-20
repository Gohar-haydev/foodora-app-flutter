import 'package:foodora/core/errors/failure.dart';
import 'package:foodora/core/utils/result.dart';
import 'package:foodora/features/order/data/datasources/order_remote_data_source.dart';
import 'package:foodora/features/order/data/models/order_request_model.dart';
import 'package:foodora/features/order/domain/entities/order_entity.dart';
import 'package:foodora/features/order/domain/entities/order_tracking_entity.dart';
import 'package:foodora/features/order/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<OrderEntity>> createOrder(OrderRequestModel request) async {
    try {
      final orderModel = await remoteDataSource.createOrder(request);
      return Result.success(orderModel.toEntity());
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<OrderEntity>> getOrderById(int orderId) async {
    print('🟠 [Repository] getOrderById called with orderId: $orderId');
    try {
      print('🟠 [Repository] Calling remote data source...');
      final orderModel = await remoteDataSource.getOrderById(orderId);
      print('✅ [Repository] Remote data source returned order model');
      print('✅ [Repository] Order ID: ${orderModel.id}');
      print('✅ [Repository] Order Number: ${orderModel.orderNumber}');
      
      final entity = orderModel.toEntity();
      print('✅ [Repository] Converted to entity successfully');
      return Result.success(entity);
    } catch (e) {
      print('❌ [Repository] Exception caught: $e');
      print('❌ [Repository] Exception type: ${e.runtimeType}');
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<OrderEntity>>> getOrders({int page = 1}) async {
    try {
      final orderModels = await remoteDataSource.getOrders(page: page);
      final orderEntities = orderModels.map((model) => model.toEntity()).toList();
      return Result.success(orderEntities);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<OrderTrackingEntity>> trackOrder(int orderId) async {
    print('🟠 [Repository] trackOrder called with orderId: $orderId');
    try {
      final trackingModel = await remoteDataSource.trackOrder(orderId);
      print('✅ [Repository] Parsed tracking model successfully');
      return Result.success(trackingModel.toEntity());
    } catch (e) {
      print('❌ [Repository] Track order exception: $e');
      return Result.failure(ServerFailure(e.toString()));
    }
  }
}
