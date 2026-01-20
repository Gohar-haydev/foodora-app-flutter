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
      id: json['id'] as int,
      orderId: json['order_id'] as int,
      branchId: json['branch_id'] as int,
      menuItemId: json['menu_item_id'] as int,
      itemName: json['item_name'] as String,
      unitPrice: json['unit_price'] as String,
      quantity: json['quantity'] as int,
      specialInstructions: json['special_instructions'] as String?,
      subtotal: json['subtotal'] as String,
      addonsTotal: json['addons_total'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
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
