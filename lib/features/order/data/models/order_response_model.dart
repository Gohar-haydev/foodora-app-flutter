import 'order_model.dart';

class OrderResponseModel {
  final bool success;
  final String message;
  final OrderResponseData data;

  OrderResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: OrderResponseData.fromJson(
          json['data'] != null ? json['data'] as Map<String, dynamic> : {}),
    );
  }
}

class OrderResponseData { 
  final OrderModel order;

  OrderResponseData({
    required this.order,
  });

  factory OrderResponseData.fromJson(Map<String, dynamic> json) {
    if (json['order'] != null) {
      return OrderResponseData(
        order: OrderModel.fromJson(json['order'] as Map<String, dynamic>),
      );
    }
    return OrderResponseData(
      order: OrderModel.fromJson(json['data'] != null ? json['data'] as Map<String, dynamic> : json),
    );
  }
}
