import 'package:foodora/core/utils/result.dart';
import 'package:foodora/features/order/domain/entities/order_entity.dart';
import 'package:foodora/features/order/domain/repositories/order_repository.dart';

class GetOrderByIdUseCase {
  final OrderRepository repository;

  GetOrderByIdUseCase(this.repository);

  Future<Result<OrderEntity>> call(int orderId) async {
    return await repository.getOrderById(orderId);
  }
}
