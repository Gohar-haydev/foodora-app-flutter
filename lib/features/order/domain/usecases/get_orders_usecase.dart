import 'package:foodora/core/utils/result.dart';
import 'package:foodora/features/order/domain/entities/order_entity.dart';
import 'package:foodora/features/order/domain/repositories/order_repository.dart';

class GetOrdersUseCase {
  final OrderRepository repository;

  GetOrdersUseCase(this.repository);

  Future<Result<List<OrderEntity>>> call({int page = 1}) async {
    return await repository.getOrders(page: page);
  }
}
