import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'package:foodora/features/cart/presentation/viewmodels/cart_viewmodel.dart';
import 'package:foodora/features/cart/presentation/pages/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Cart', 
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          )
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.black),
            onPressed: () {
               context.read<CartViewModel>().clearCart();
            },
          )
        ],
      ),
      body: Consumer<CartViewModel>(
        builder: (context, viewModel, child) {
           if (viewModel.cartItems.isEmpty) {
             return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.shopping_cart_outlined, size: 64, color: AppColors.mutedText),
                  SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(
                      color: AppColors.mutedText,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            );
          }

          // Price Calculations
          final double subtotal = viewModel.totalAmount;
          final double deliveryFee = viewModel.deliveryFee;
          final double tax = viewModel.tax;
          final double total = viewModel.grandTotal;

          return ListView(
            padding: const EdgeInsets.all(25),
            children: [
              // Cart Items List
              ...viewModel.cartItems.map((cartItem) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Dismissible(
                    key: Key(cartItem.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) {
                      viewModel.removeFromCart(cartItem.id);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
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
                          // Item Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[300],
                              child: cartItem.menuItem.image != null
                                  ? Image.network(
                                      cartItem.menuItem.image!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (ctx, err, stack) => const Icon(Icons.fastfood, color: Colors.grey),
                                    )
                                  : const Icon(Icons.fastfood, color: Colors.grey),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Item Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cartItem.menuItem.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                if (cartItem.selectedAddons.isEmpty)
                                  Text(
                                    '01', // Variant or static label if no addons
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                  )
                                else
                                  Wrap(
                                    spacing: 4,
                                    children: cartItem.selectedAddons.map((adn) => Text(
                                      '+${adn.name}',
                                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                                    )).toList(),
                                  ),
                              ],
                            ),
                          ),

                          // Quantity Actions
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove, size: 18),
                                  onPressed: () => viewModel.decrementItem(cartItem.id),
                                  padding: const EdgeInsets.all(8),
                                  constraints: const BoxConstraints(),
                                  color: Colors.black,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(
                                    '${cartItem.quantity}'.padLeft(2, '0'),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add, size: 18),
                                  onPressed: () => viewModel.incrementItem(cartItem.id),
                                  padding: const EdgeInsets.all(8),
                                  constraints: const BoxConstraints(),
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),

              const SizedBox(height: 24),

              // Breakdown
              _PriceRow(label: 'Subtotal', amount: subtotal),
              const SizedBox(height: 12),
              _PriceRow(label: 'Delivery Fee', amount: deliveryFee),
              const SizedBox(height: 12),
              _PriceRow(label: 'Tax', amount: tax),
              const SizedBox(height: 12),
              _PriceRow(
                label: 'Total',
                amount: total,
                isTotal: true,
              ),
              const SizedBox(height: 24),

              // Checkout Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50), // Green
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'CHECKOUT',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isTotal;

  const _PriceRow({
    required this.label,
    required this.amount,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
