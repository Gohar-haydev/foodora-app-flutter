import 'package:flutter/material.dart';
import 'package:foodora/features/order/data/models/order_request_model.dart';
import 'package:foodora/features/order/data/models/order_item_request_model.dart';
import 'package:foodora/features/order/data/models/order_addon_request_model.dart';
import 'package:foodora/features/order/presentation/viewmodels/order_viewmodel.dart';

/// Example usage of the POST /orders API
/// 
/// This file demonstrates how to create an order using the OrderViewModel
class OrderApiExample {
  final OrderViewModel orderViewModel;

  OrderApiExample(this.orderViewModel);

  /// Example: Create an order with items and addons
  Future<void> createExampleOrder() async {
    // Build the order request
    final orderRequest = OrderRequestModel(
      deliveryType: "delivery",
      paymentMethod: "cash",
      deliveryAddress: "Country Homes",
      deliveryLat: 31.4985,
      deliveryLng: 74.2415,
      customerName: "Gohar Zafar",
      customerPhone: "+923081865705",
      notes: "Ring doorbell",
      items: [
        OrderItemRequestModel(
          menuItemId: 12,
          quantity: 2,
          specialInstructions: "No onions",
          addons: [
            OrderAddonRequestModel(
              addonId: 3,
              quantity: 1,
            ),
          ],
        ),
      ],
    );

    // Call the API
    final success = await orderViewModel.createOrder(orderRequest);

    if (success) {
      // Order created successfully
      final order = orderViewModel.lastCreatedOrder;
      debugPrint('✅ Order created successfully!');
      debugPrint('Order Number: ${order?.orderNumber}');
      debugPrint('Total Amount: \$${order?.totalAmount}');
      debugPrint('Status: ${order?.status}');
      debugPrint('Branch: ${order?.branchName}');
    } else {
      // Handle error
      debugPrint('❌ Order creation failed');
      debugPrint('Error: ${orderViewModel.errorMessage}');
    }
  }

  /// Example: Create an order from cart data
  Future<bool> createOrderFromCart({
    required String deliveryType,
    required String paymentMethod,
    required String customerName,
    required String customerPhone,
    String? deliveryAddress,
    double? deliveryLat,
    double? deliveryLng,
    String? notes,
    required List<OrderItemRequestModel> items,
  }) async {
    final orderRequest = OrderRequestModel(
      deliveryType: deliveryType,
      paymentMethod: paymentMethod,
      deliveryAddress: deliveryAddress,
      deliveryLat: deliveryLat,
      deliveryLng: deliveryLng,
      customerName: customerName,
      customerPhone: customerPhone,
      notes: notes,
      items: items,
    );

    return await orderViewModel.createOrder(orderRequest);
  }

  /// Example: Widget showing loading and error states
  Widget buildOrderButton(BuildContext context) {
    return ListenableBuilder(
      listenable: orderViewModel,
      builder: (context, child) {
        if (orderViewModel.isLoading) {
          return const CircularProgressIndicator();
        }

        return ElevatedButton(
          onPressed: () async {
            await createExampleOrder();
            
            if (orderViewModel.errorMessage != null) {
              // Show error snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(orderViewModel.errorMessage!),
                  backgroundColor: Colors.red,
                ),
              );
              orderViewModel.clearError();
            } else if (orderViewModel.lastCreatedOrder != null) {
              // Navigate to order confirmation
              // Navigator.push(...);
            }
          },
          child: const Text('Place Order'),
        );
      },
    );
  }

  /// Example: Fetch order details by ID
  /// 
  /// API Endpoint: GET /orders/{orderId}
  /// This demonstrates how to retrieve a specific order's details
  Future<void> fetchOrderDetails(int orderId) async {
    final order = await orderViewModel.getOrderById(orderId);

    if (order != null) {
      // Order fetched successfully
      debugPrint('✅ Order fetched successfully!');
      debugPrint('Order ID: ${order.id}');
      debugPrint('Order Number: ${order.orderNumber}');
      debugPrint('Status: ${order.status}');
      debugPrint('Total Amount: \$${order.totalAmount}');
      debugPrint('Customer: ${order.customerName}');
      debugPrint('Phone: ${order.customerPhone}');
      debugPrint('Delivery Type: ${order.deliveryType}');
      debugPrint('Delivery Address: ${order.deliveryAddress}');
      debugPrint('Payment Method: ${order.paymentMethod}');
      debugPrint('Payment Status: ${order.paymentStatus}');
      debugPrint('Branch: ${order.branchName}');
      debugPrint('Branch Address: ${order.branchAddress}');
      debugPrint('Number of Items: ${order.items.length}');
      
      // Print item details
      for (var item in order.items) {
        debugPrint('  - ${item.itemName} x${item.quantity} = \$${item.subtotal}');
        for (var addon in item.addons) {
          debugPrint('    + ${addon.addonName} x${addon.quantity} = \$${addon.subtotal}');
        }
      }
    } else {
      // Handle error
      debugPrint('❌ Failed to fetch order');
      debugPrint('Error: ${orderViewModel.errorMessage}');
    }
  }

  /// Example: Widget to display order details
  Widget buildOrderDetailsScreen(BuildContext context, int orderId) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: ListenableBuilder(
        listenable: orderViewModel,
        builder: (context, child) {
          if (orderViewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (orderViewModel.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    orderViewModel.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => fetchOrderDetails(orderId),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Display order details here
          return const Center(
            child: Text('Order details will be displayed here'),
          );
        },
      ),
    );
  }

  /// Example: Fetch and navigate to order details
  Future<void> viewOrderDetails(BuildContext context, int orderId) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    final order = await orderViewModel.getOrderById(orderId);

    // Close loading dialog
    Navigator.of(context).pop();

    if (order != null) {
      // Navigate to order details screen with the fetched order
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => OrderDetailsScreen(order: order),
      //   ),
      // );
      debugPrint('Navigate to order details screen');
    } else {
      // Show error dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(orderViewModel.errorMessage ?? 'Failed to fetch order'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
