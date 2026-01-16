import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodora/features/menu/presentation/pages/order_details_screen.dart';
import 'package:foodora/features/order/presentation/viewmodels/order_viewmodel.dart';
import 'package:foodora/core/constants/app_strings.dart';
import 'package:foodora/features/order/presentation/widgets/past_order_card.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

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
                        ? '${firstItem.menuItem.name} + ${order.items.length - 1} more'
                        : firstItem.menuItem.name;
                      
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => OrderDetailsScreen(order: order),
                            ),
                          );
                        },
                        child: PastOrderCard(
                          title: title,
                          price: '\$${order.totalAmount.toStringAsFixed(2)}',
                          imageUrl: firstItem.menuItem.image != null 
                            ? firstItem.menuItem.image! 
                            : '',
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
