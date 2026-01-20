import 'package:equatable/equatable.dart';
import 'order_addon_entity.dart';

class OrderItemEntity extends Equatable {
  final int id;
  final int orderId;
  final int branchId;
  final int menuItemId;
  final String itemName;
  final double unitPrice;
  final int quantity;
  final String? specialInstructions;
  final double subtotal;
  final double addonsTotal;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String branchName;
  final String? branchImageUrl;
  final List<OrderAddonEntity> addons;

  const OrderItemEntity({
    required this.id,
    required this.orderId,
    required this.branchId,
    required this.menuItemId,
    required this.itemName,
    required this.unitPrice,
    required this.quantity,
    this.specialInstructions,
    required this.subtotal,
    required this.addonsTotal,
    required this.createdAt,
    required this.updatedAt,
    required this.branchName,
    this.branchImageUrl,
    required this.addons,
  });

  double get totalPrice => subtotal + addonsTotal;

  @override
  List<Object?> get props => [
        id,
        orderId,
        branchId,
        menuItemId,
        itemName,
        unitPrice,
        quantity,
        specialInstructions,
        subtotal,
        addonsTotal,
        createdAt,
        updatedAt,
        branchName,
        branchImageUrl,
        addons,
      ];
}
