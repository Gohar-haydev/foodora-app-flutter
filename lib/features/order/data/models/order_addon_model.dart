import 'package:equatable/equatable.dart';
import '../../domain/entities/order_addon_entity.dart';

class OrderAddonModel extends Equatable {
  final int id;
  final int orderItemId;
  final int addonId;
  final String addonName;
  final String addonPrice;
  final int quantity;
  final String subtotal;
  final String createdAt;
  final String updatedAt;

  const OrderAddonModel({
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

  factory OrderAddonModel.fromJson(Map<String, dynamic> json) {
    return OrderAddonModel(
      id: json['id'] as int,
      orderItemId: json['order_item_id'] as int,
      addonId: json['addon_id'] as int,
      addonName: json['addon_name'] as String,
      addonPrice: json['addon_price'] as String,
      quantity: json['quantity'] as int,
      subtotal: json['subtotal'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  OrderAddonEntity toEntity() {
    return OrderAddonEntity(
      id: id,
      orderItemId: orderItemId,
      addonId: addonId,
      addonName: addonName,
      addonPrice: double.tryParse(addonPrice) ?? 0.0,
      quantity: quantity,
      subtotal: double.tryParse(subtotal) ?? 0.0,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }

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
