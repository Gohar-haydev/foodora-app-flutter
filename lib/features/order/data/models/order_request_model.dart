import 'order_item_request_model.dart';

class OrderRequestModel {
  final String deliveryType;
  final String paymentMethod;
  final String? deliveryAddress;
  final double? deliveryLat;
  final double? deliveryLng;
  final String customerName;
  final String customerPhone;
  final String? notes;
  final List<OrderItemRequestModel> items;

  OrderRequestModel({
    required this.deliveryType,
    required this.paymentMethod,
    this.deliveryAddress,
    this.deliveryLat,
    this.deliveryLng,
    required this.customerName,
    required this.customerPhone,
    this.notes,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'delivery_type': deliveryType,
      'payment_method': paymentMethod,
      if (deliveryAddress != null) 'delivery_address': deliveryAddress,
      if (deliveryLat != null) 'delivery_lat': deliveryLat,
      if (deliveryLng != null) 'delivery_lng': deliveryLng,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      if (notes != null) 'notes': notes,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
