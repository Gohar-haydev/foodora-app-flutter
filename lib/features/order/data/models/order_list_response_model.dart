import 'order_model.dart';

class OrderListResponseModel {
  final bool success;
  final String message;
  final List<OrderModel> data;
  final PaginationMeta meta;
  final OrderStats stats;

  OrderListResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
    required this.stats,
  });

  factory OrderListResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderListResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((order) => OrderModel.fromJson(order as Map<String, dynamic>))
          .toList(),
      meta: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
      stats: OrderStats.fromJson(json['stats'] as Map<String, dynamic>),
    );
  }
}

class PaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final int from;
  final int to;

  PaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.from,
    required this.to,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['current_page'] as int,
      lastPage: json['last_page'] as int,
      perPage: json['per_page'] as int,
      total: json['total'] as int,
      from: json['from'] as int,
      to: json['to'] as int,
    );
  }
}

class OrderStats {
  final int totalOrders;
  final double totalSpent;
  final int pendingOrders;
  final int completedOrders;

  OrderStats({
    required this.totalOrders,
    required this.totalSpent,
    required this.pendingOrders,
    required this.completedOrders,
  });

  factory OrderStats.fromJson(Map<String, dynamic> json) {
    return OrderStats(
      totalOrders: json['total_orders'] as int,
      totalSpent: (json['total_spent'] as num).toDouble(),
      pendingOrders: json['pending_orders'] as int,
      completedOrders: json['completed_orders'] as int,
    );
  }
}
