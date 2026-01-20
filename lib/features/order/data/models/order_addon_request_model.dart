class OrderAddonRequestModel {
  final int addonId;
  final int quantity;

  OrderAddonRequestModel({
    required this.addonId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'addon_id': addonId,
      'quantity': quantity,
    };
  }
}
