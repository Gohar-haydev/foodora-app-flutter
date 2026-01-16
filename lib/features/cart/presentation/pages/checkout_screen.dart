import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'package:foodora/features/cart/presentation/viewmodels/cart_viewmodel.dart';
import 'package:foodora/features/cart/presentation/pages/order_confirmation_screen.dart';
import 'package:foodora/features/order/presentation/viewmodels/order_viewmodel.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(AppStrings.checkout),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primaryText,
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer<CartViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.cartItems.isEmpty) {
             return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.remove_shopping_cart, size: 64, color: AppColors.mutedText),
                  SizedBox(height: 16),
                  Text('Your cart is empty', style: TextStyle(color: AppColors.mutedText, fontSize: 18)),
                ],
              ),
            );
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Delivery Address Section (Static for now)
                _SectionHeader(title: 'Delivery Address'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on_outlined, color: AppColors.primaryAccent),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Home',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '123 Main Street, New York, USA',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      TextButton(onPressed: () {}, child: const Text('Change')),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Payment Method Section (Static for now)
                _SectionHeader(title: 'Payment Method'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.credit_card, color: AppColors.primaryAccent),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          '**** **** **** 1234',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ),
                      TextButton(onPressed: () {}, child: const Text('Change')),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Order Summary
                _SectionHeader(title: 'Order Summary'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // List Items roughly (or just total count?)
                      // Let's show list of items briefly
                      ...viewModel.cartItems.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${item.quantity}x ${item.menuItem.name}', style: const TextStyle(fontSize: 14)),
                            Text('\$${item.totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      )).toList(),
                      const Divider(height: 24),
                      _SummaryRow(label: 'Subtotal', amount: viewModel.totalAmount),
                      const SizedBox(height: 8),
                      _SummaryRow(label: 'Delivery Fee', amount: viewModel.deliveryFee),
                      const SizedBox(height: 8),
                      _SummaryRow(label: 'Tax', amount: viewModel.tax),
                      const Divider(height: 24),
                      _SummaryRow(label: 'Total', amount: viewModel.grandTotal, isTotal: true),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Place Order Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      final order = viewModel.placeOrder();
                      if (order != null) {
                        // Add to Order History
                        context.read<OrderViewModel>().addOrder(order);
                        
                        // Navigate to Confirmation with Order Data
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => OrderConfirmationScreen(order: order),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 5,
                    ),
                    child: const Text('PLACE ORDER', style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    )),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isTotal;

  const _SummaryRow({required this.label, required this.amount, this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black : Colors.grey[600],
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
