import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'package:foodora/features/cart/presentation/viewmodels/cart_viewmodel.dart';
import 'package:foodora/features/cart/presentation/pages/checkout_screen.dart';
import 'package:foodora/features/cart/presentation/widgets/cart_item_widget.dart';
import 'package:foodora/features/cart/presentation/widgets/cart_price_row.dart';
import 'package:foodora/core/extensions/context_extensions.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          context.tr('cart'), 
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          )
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<CartViewModel>(
        builder: (context, viewModel, child) {
           if (viewModel.cartItems.isEmpty) {
             return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 64, color: AppColors.mutedText),
                  SizedBox(height: 16),
                  Text(
                    context.tr('empty_cart'),
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
                return CartItemWidget(
                  cartItem: cartItem,
                  onIncrement: () => viewModel.incrementItem(cartItem.id),
                  onDecrement: () => viewModel.decrementItem(cartItem.id),
                  onRemove: () => viewModel.removeFromCart(cartItem.id),
                );
              }).toList(),

              const SizedBox(height: 24),

              // Breakdown
              CartPriceRow(label: context.tr('subtotal'), amount: subtotal),
              const SizedBox(height: 12),
              CartPriceRow(label: context.tr('delivery_fee'), amount: deliveryFee),
              const SizedBox(height: 12),
              CartPriceRow(label: context.tr('tax'), amount: tax),
              const SizedBox(height: 12),
              CartPriceRow(
                label: context.tr('total'),
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
                  child: Text(
                    context.tr('checkout').toUpperCase(),
                    style: const TextStyle(
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


