import 'package:equatable/equatable.dart';
import 'package:foodora/features/cart/domain/entities/cart_item_entity.dart';

class OrderEntity extends Equatable {
  final String id;
  final List<CartItemEntity> items;
  final double totalAmount;
  final double deliveryFee;
  final double tax;
  final DateTime placedAt;
  final String status; // 'Completed', 'Pending', etc.

  const OrderEntity({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.deliveryFee,
    required this.tax,
    required this.placedAt,
    this.status = 'Pending',
  });

  @override
  List<Object?> get props => [id, items, totalAmount, deliveryFee, tax, placedAt, status];
}
