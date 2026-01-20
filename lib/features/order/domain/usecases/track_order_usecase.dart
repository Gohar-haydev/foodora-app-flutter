import 'package:foodora/core/utils/result.dart';
import '../entities/order_tracking_entity.dart';
import '../repositories/order_repository.dart';

class TrackOrderUseCase {
  final OrderRepository repository;

  TrackOrderUseCase(this.repository);

  Future<Result<OrderTrackingEntity>> call(int orderId) async {
    return await repository.trackOrder(orderId);
  }
}
