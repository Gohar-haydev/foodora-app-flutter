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
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          context.tr('cart'), 
          style: const TextStyle(
            color: AppColors.primaryText,
            fontSize: AppDimensions.fontSize18,
            fontWeight: FontWeight.w600,
          )
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: Consumer<CartViewModel>(
        builder: (context, viewModel, child) {
           if (viewModel.cartItems.isEmpty) {
             return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_outlined, size: 64, color: AppColors.mutedText),
                  const SizedBox(height: AppDimensions.spacing16),
                  Text(
                    context.tr('empty_cart'),
                    style: const TextStyle(
                      color: AppColors.mutedText,
                      fontSize: AppDimensions.fontSize18,
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
            padding: const EdgeInsets.all(AppDimensions.spacing24),
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

              const SizedBox(height: AppDimensions.spacing24),

              // Breakdown
              CartPriceRow(label: context.tr('subtotal'), amount: subtotal),
              const SizedBox(height: AppDimensions.spacing12),
              CartPriceRow(label: context.tr('delivery_fee'), amount: deliveryFee),
              const SizedBox(height: AppDimensions.spacing12),
              CartPriceRow(label: context.tr('tax'), amount: tax),
              const SizedBox(height: AppDimensions.spacing12),
              CartPriceRow(
                label: context.tr('total'),
                amount: total,
                isTotal: true,
              ),
              const SizedBox(height: AppDimensions.spacing24),

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
                    backgroundColor: AppColors.primaryAccent,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    context.tr('checkout').toUpperCase(),
                    style: const TextStyle(
                      fontSize: AppDimensions.fontSize16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacing16),
            ],
          );
        },
      ),
    );
  }
}
