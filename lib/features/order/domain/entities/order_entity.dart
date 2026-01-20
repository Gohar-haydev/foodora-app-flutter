import 'package:equatable/equatable.dart';
import 'order_item_entity.dart';

class OrderEntity extends Equatable {
  final int id;
  final int userId;
  final int branchId;
  final double subtotal;
  final double taxAmount;
  final double deliveryFee;
  final double totalAmount;
  final String status;
  final String deliveryType;
  final String? deliveryAddress;
  final double? deliveryLat;
  final double? deliveryLng;
  final String paymentMethod;
  final String paymentStatus;
  final String customerName;
  final String customerPhone;
  final String? notes;
  final String orderNumber;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String branchName;
  final String? branchAddress;
  final String? branchPhone;
  final String? branchImageUrl;
  final List<OrderItemEntity> items;

  const OrderEntity({
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
    required this.branchName,
    this.branchAddress,
    this.branchPhone,
    this.branchImageUrl,
    required this.items,
  });

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
        branchName,
        branchAddress,
        branchPhone,
        branchImageUrl,
        items,
      ];
}
