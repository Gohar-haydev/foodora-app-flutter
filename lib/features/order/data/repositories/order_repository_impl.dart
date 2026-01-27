import 'package:flutter/foundation.dart';
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
    debugPrint('🟠 [Repository] getOrderById called with orderId: $orderId');
    try {
      debugPrint('🟠 [Repository] Calling remote data source...');
      final orderModel = await remoteDataSource.getOrderById(orderId);
      debugPrint('✅ [Repository] Remote data source returned order model');
      debugPrint('✅ [Repository] Order ID: ${orderModel.id}');
      debugPrint('✅ [Repository] Order Number: ${orderModel.orderNumber}');
      
      final entity = orderModel.toEntity();
      debugPrint('✅ [Repository] Converted to entity successfully');
      return Result.success(entity);
    } catch (e) {
      debugPrint('❌ [Repository] Exception caught: $e');
      debugPrint('❌ [Repository] Exception type: ${e.runtimeType}');
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
    debugPrint('🟠 [Repository] trackOrder called with orderId: $orderId');
    try {
      final trackingModel = await remoteDataSource.trackOrder(orderId);
      debugPrint('✅ [Repository] Parsed tracking model successfully');
      return Result.success(trackingModel.toEntity());
    } catch (e) {
      debugPrint('❌ [Repository] Track order exception: $e');
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> cancelOrder(int orderId, String reason) async {
    debugPrint('🟠 [Repository] cancelOrder called: $orderId, reason: $reason');
    try {
      await remoteDataSource.cancelOrder(orderId, reason);
      debugPrint('✅ [Repository] Cancel successful');
      return Result.success(null);
    } catch (e) {
      debugPrint('❌ [Repository] Cancel exception: $e');
      return Result.failure(ServerFailure(e.toString()));
    }
  }
}
