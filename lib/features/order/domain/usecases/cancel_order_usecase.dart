import 'package:foodora/core/utils/result.dart';
import '../repositories/order_repository.dart';

class CancelOrderUseCase {
  final OrderRepository repository;

  CancelOrderUseCase(this.repository);

  Future<Result<void>> call(int orderId, String reason) async {
    return await repository.cancelOrder(orderId, reason);
  }
}
