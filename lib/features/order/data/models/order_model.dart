import 'package:equatable/equatable.dart';
import '../../domain/entities/order_entity.dart';
import 'order_item_model.dart';
import 'branch_info_model.dart';

class OrderModel extends Equatable {
  final int id;
  final int userId;
  final int branchId;
  final String subtotal;
  final String taxAmount;
  final String deliveryFee;
  final String totalAmount;
  final String status;
  final String deliveryType;
  final String? deliveryAddress;
  final String? deliveryLat;
  final String? deliveryLng;
  final String paymentMethod;
  final String paymentStatus;
  final String customerName;
  final String customerPhone;
  final String? notes;
  final String orderNumber;
  final String createdAt;
  final String updatedAt;
  final BranchInfoModel branch;
  final List<OrderItemModel> items;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.branchId,
    required this.subtotal,
    required this.taxAmount,
    required this.deliveryFee,
    required this.totalAmount,
    required this.status,
    required this.deliveryType,
    this.deliveryAddress,
    this.deliveryLat,
    this.deliveryLng,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.customerName,
    required this.customerPhone,
    this.notes,
    required this.orderNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.branch,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      userId: (json['user_id'] as num?)?.toInt() ?? 0,
      branchId: (json['branch_id'] as num?)?.toInt() ?? 0,
      subtotal: json['subtotal']?.toString() ?? '0.00',
      taxAmount: json['tax_amount']?.toString() ?? '0.00',
      deliveryFee: json['delivery_fee']?.toString() ?? '0.00',
      totalAmount: json['total_amount']?.toString() ?? '0.00',
      status: json['status']?.toString() ?? 'Unknown',
      deliveryType: json['delivery_type']?.toString() ?? 'Unknown',
      deliveryAddress: json['delivery_address']?.toString(),
      deliveryLat: json['delivery_lat']?.toString(),
      deliveryLng: json['delivery_lng']?.toString(),
      paymentMethod: json['payment_method']?.toString() ?? 'Unknown',
      paymentStatus: json['payment_status']?.toString() ?? 'Unknown',
      customerName: json['customer_name']?.toString() ?? 'Unknown',
      customerPhone: json['customer_phone']?.toString() ?? '',
      notes: json['notes']?.toString(),
      orderNumber: json['order_number']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? DateTime.now().toIso8601String(),
      updatedAt: json['updated_at']?.toString() ?? DateTime.now().toIso8601String(),
      branch: json['branch'] != null 
          ? BranchInfoModel.fromJson(json['branch'] as Map<String, dynamic>)
          : const BranchInfoModel(id: 0, name: 'Unknown'),
      items: json['items'] != null
          ? (json['items'] as List<dynamic>)
              .map((item) => OrderItemModel.fromJson(item as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      userId: userId,
      branchId: branchId,
      subtotal: double.tryParse(subtotal) ?? 0.0,
      taxAmount: double.tryParse(taxAmount) ?? 0.0,
      deliveryFee: double.tryParse(deliveryFee) ?? 0.0,
      totalAmount: double.tryParse(totalAmount) ?? 0.0,
      status: status,
      deliveryType: deliveryType,
      deliveryAddress: deliveryAddress,
      deliveryLat: deliveryLat != null ? double.tryParse(deliveryLat!) : null,
      deliveryLng: deliveryLng != null ? double.tryParse(deliveryLng!) : null,
      paymentMethod: paymentMethod,
      paymentStatus: paymentStatus,
      customerName: customerName,
      customerPhone: customerPhone,
      notes: notes,
      orderNumber: orderNumber,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
      branchName: branch.name,
      branchAddress: branch.address,
      branchPhone: branch.phone,
      branchImageUrl: branch.imageUrl,
      items: items.map((item) => item.toEntity()).toList(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        branchId,
        subtotal,
        taxAmount,
        deliveryFee,
        totalAmount,
        status,
        deliveryType,
        deliveryAddress,
        deliveryLat,
        deliveryLng,
        paymentMethod,
        paymentStatus,
        customerName,
        customerPhone,
        notes,
        orderNumber,
        createdAt,
        updatedAt,
        branch,
        items,
      ];
}
