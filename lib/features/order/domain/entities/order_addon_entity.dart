import 'package:equatable/equatable.dart';

class OrderAddonEntity extends Equatable {
  final int id;
  final int orderItemId;
  final int addonId;
  final String addonName;
  final double addonPrice;
  final int quantity;
  final double subtotal;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderAddonEntity({
    required this.id,
    required this.orderItemId,
    required this.addonId,
    required this.addonName,
    required this.addonPrice,
    required this.quantity,
    required this.subtotal,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        orderItemId,
        addonId,
        addonName,
        addonPrice,
        quantity,
        subtotal,
        createdAt,
        updatedAt,
      ];
}
