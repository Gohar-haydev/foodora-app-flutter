import 'order_addon_request_model.dart';

class OrderItemRequestModel {
  final int menuItemId;
  final int quantity;
  final String? specialInstructions;
  final List<OrderAddonRequestModel> addons;

  OrderItemRequestModel({
    required this.menuItemId,
    required this.quantity,
    this.specialInstructions,
    this.addons = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'menu_item_id': menuItemId,
      'quantity': quantity,
      if (specialInstructions != null) 'special_instructions': specialInstructions,
      'addons': addons.map((addon) => addon.toJson()).toList(),
    };
  }
}
