import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodora/features/menu/presentation/pages/order_details_screen.dart';
import 'package:foodora/features/order/presentation/viewmodels/order_viewmodel.dart';
import 'package:foodora/core/constants/app_strings.dart';
import 'package:foodora/features/order/presentation/widgets/past_order_card.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch orders when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderViewModel>().fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          AppStrings.orderHistory,
          style: TextStyle(
            color: Colors.black, // Dark text for title to match design
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black, // Back button color
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Past Orders',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A), // Dark text color
                ),
              ),
              const SizedBox(height: 16),
              // List of Orders
              Consumer<OrderViewModel>(
                builder: (context, viewModel, child) {
                  // Show loading indicator
                  if (viewModel.isLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(48.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  // Show error message
                  if (viewModel.errorMessage != null) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            const Icon(Icons.error_outline, size: 48, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(
                              viewModel.errorMessage!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => viewModel.fetchOrders(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Show empty state
                  if (viewModel.orders.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Text('No past orders found.'),
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(), 
                    itemCount: viewModel.orders.length,
                    itemBuilder: (context, index) {
                      final order = viewModel.orders[index];
                      final firstItem = order.items.first;
                      final title = order.items.length > 1 
                        ? '${firstItem.itemName} + ${order.items.length - 1} more'
                        : firstItem.itemName;
                      
                      return GestureDetector(
                        onTap: () async {
                          print('🔵 [ORDER_TAP] Order tapped - ID: ${order.id}');
                          print('🔵 [ORDER_TAP] Order Number: ${order.orderNumber}');
                          
                          // Check if context is mounted before starting
                          if (!context.mounted) {
                            print('⚠️ [ORDER_TAP] Context not mounted at start, aborting');
                            return;
                          }
                          
                          // Capture navigator and scaffold messenger before async call
                          final navigator = Navigator.of(context);
                          final scaffoldMessenger = ScaffoldMessenger.of(context);
                          
                          // Fetch fresh order details from API
                          print('🔵 [ORDER_TAP] Calling getOrderById(${order.id})...');
                          final orderDetails = await viewModel.getOrderById(order.id);
                          
                          print('🔵 [ORDER_TAP] API Response received');
                          print('🔵 [ORDER_TAP] orderDetails is null: ${orderDetails == null}');
                          print('🔵 [ORDER_TAP] errorMessage: ${viewModel.errorMessage}');
                          
                          if (orderDetails != null) {
                            print('✅ [ORDER_TAP] Navigating to OrderDetailsScreen');
                            print('✅ [ORDER_TAP] Order ID: ${orderDetails.id}');
                            print('✅ [ORDER_TAP] Order Number: ${orderDetails.orderNumber}');
                            print('✅ [ORDER_TAP] Items count: ${orderDetails.items.length}');
                            
                            // Navigate with fresh data using captured navigator
                            navigator.push(
                              MaterialPageRoute(
                                builder: (_) => OrderDetailsScreen(order: orderDetails),
                              ),
                            );
                            print('✅ [ORDER_TAP] Navigation push completed');
                          } else if (viewModel.errorMessage != null) {
                            print('❌ [ORDER_TAP] Error occurred: ${viewModel.errorMessage}');
                            // Show error if fetch failed using captured scaffold messenger
                            scaffoldMessenger.showSnackBar(
                              SnackBar(
                                content: Text(viewModel.errorMessage!),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: PastOrderCard(
                          title: title,
                          price: '\$${order.totalAmount.toStringAsFixed(2)}',
                          imageUrl: firstItem.branchImageUrl ?? '',
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
