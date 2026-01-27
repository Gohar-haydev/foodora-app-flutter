import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'package:foodora/features/cart/presentation/viewmodels/cart_viewmodel.dart';
import 'package:foodora/features/cart/presentation/pages/checkout_screen.dart';
import 'package:foodora/features/cart/presentation/widgets/cart_item_widget.dart';
import 'package:foodora/features/cart/presentation/widgets/cart_price_row.dart';
import 'package:foodora/core/extensions/context_extensions.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          context.tr('cart'), 
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: AppDimensions.getH3Size(context),
            fontWeight: FontWeight.w600,
          )
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: AppDimensions.getMaxContentWidth(context),
          ),
          child: Consumer<CartViewModel>(
            builder: (context, viewModel, child) {
               if (viewModel.cartItems.isEmpty) {
                 return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: AppDimensions.responsiveIconSize(context, mobile: 64, tablet: 80),
                        color: AppColors.mutedText,
                      ),
                      SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 24)),
                      Text(
                        context.tr('empty_cart'),
                        style: TextStyle(
                          color: AppColors.mutedText,
                          fontSize: AppDimensions.getH3Size(context),
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
                padding: EdgeInsets.all(
                  AppDimensions.getResponsiveHorizontalPadding(context),
                ),
                children: [
                  // Cart Items List
                  ...viewModel.cartItems.map((cartItem) {
                    return CartItemWidget(
                      cartItem: cartItem,
                      onIncrement: () => viewModel.incrementItem(cartItem.id),
                      onDecrement: () => viewModel.decrementItem(cartItem.id),
                      onRemove: () => viewModel.removeFromCart(cartItem.id),
                    );
                  }),

                  SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 24, tablet: 32)),

                  // Breakdown
                  CartPriceRow(label: context.tr('subtotal'), amount: subtotal),
                  SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 12, tablet: 16)),
                  CartPriceRow(label: context.tr('delivery_fee'), amount: deliveryFee),
                  SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 12, tablet: 16)),
                  CartPriceRow(label: context.tr('tax'), amount: tax),
                  SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 12, tablet: 16)),
                  CartPriceRow(
                    label: context.tr('total'),
                    amount: total,
                    isTotal: true,
                  ),
                  SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 24, tablet: 32)),

                  // Checkout Button
                  SizedBox(
                    width: double.infinity,
                    height: AppDimensions.getButtonHeight(context),
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
                        style: TextStyle(
                          fontSize: AppDimensions.getBodySize(context),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 24)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
