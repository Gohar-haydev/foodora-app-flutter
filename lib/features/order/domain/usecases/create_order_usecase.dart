import 'package:foodora/core/utils/result.dart';
import 'package:foodora/features/order/data/models/order_request_model.dart';
import 'package:foodora/features/order/domain/entities/order_entity.dart';
import 'package:foodora/features/order/domain/repositories/order_repository.dart';

class CreateOrderUseCase {
  final OrderRepository repository;

  CreateOrderUseCase(this.repository);

  Future<Result<OrderEntity>> call(OrderRequestModel request) async {
    return await repository.createOrder(request);
  }
}
