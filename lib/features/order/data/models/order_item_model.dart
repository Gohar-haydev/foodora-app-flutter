import 'package:equatable/equatable.dart';
import '../../domain/entities/order_item_entity.dart';
import 'order_addon_model.dart';
import 'branch_info_model.dart';

class OrderItemModel extends Equatable {
  final int id;
  final int orderId;
  final int branchId;
  final int menuItemId;
  final String itemName;
  final String unitPrice;
  final int quantity;
  final String? specialInstructions;
  final String subtotal;
  final String addonsTotal;
  final String createdAt;
  final String updatedAt;
  final BranchInfoModel? branch;
  final List<OrderAddonModel> addons;

  const OrderItemModel({
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
    required this.branch,
    required this.addons,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      orderId: (json['order_id'] as num?)?.toInt() ?? 0,
      branchId: (json['branch_id'] as num?)?.toInt() ?? 0,
      menuItemId: (json['menu_item_id'] as num?)?.toInt() ?? 0,
      itemName: json['item_name']?.toString() ?? 'Unknown Item',
      unitPrice: json['unit_price']?.toString() ?? '0.00',
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      specialInstructions: json['special_instructions']?.toString(),
      subtotal: json['subtotal']?.toString() ?? '0.00',
      addonsTotal: json['addons_total']?.toString() ?? '0.00',
      createdAt: json['created_at']?.toString() ?? DateTime.now().toIso8601String(),
      updatedAt: json['updated_at']?.toString() ?? DateTime.now().toIso8601String(),
      branch: json['branch'] != null 
          ? BranchInfoModel.fromJson(json['branch'] as Map<String, dynamic>)
          : null,
      addons: (json['addons'] as List<dynamic>)
          .map((addon) => OrderAddonModel.fromJson(addon as Map<String, dynamic>))
          .toList(),
    );
  }

  OrderItemEntity toEntity() {
    return OrderItemEntity(
      id: id,
      orderId: orderId,
      branchId: branchId,
      menuItemId: menuItemId,
      itemName: itemName,
      unitPrice: double.tryParse(unitPrice) ?? 0.0,
      quantity: quantity,
      specialInstructions: specialInstructions,
      subtotal: double.tryParse(subtotal) ?? 0.0,
      addonsTotal: double.tryParse(addonsTotal) ?? 0.0,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
      branchName: branch?.name ?? '',
      branchImageUrl: branch?.imageUrl,
      addons: addons.map((addon) => addon.toEntity()).toList(),
    );
  }

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
        branch,
        addons,
      ];
}
