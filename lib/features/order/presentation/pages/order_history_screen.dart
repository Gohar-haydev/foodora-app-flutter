import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'package:foodora/features/menu/presentation/pages/order_details_screen.dart';
import 'package:foodora/features/order/presentation/viewmodels/order_viewmodel.dart';
import 'package:foodora/core/constants/app_strings.dart';
import 'package:foodora/features/order/presentation/widgets/past_order_card.dart';
import 'package:foodora/core/extensions/context_extensions.dart';
import 'package:foodora/core/providers/currency_provider.dart';

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
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          context.tr('order_history'),
          style: TextStyle(
            color: AppColors.primaryText,
            fontWeight: FontWeight.w600,
            fontSize: AppDimensions.getH3Size(context),
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primaryText,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: AppDimensions.getMaxContentWidth(context),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.getResponsiveHorizontalPadding(context),
                vertical: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('past_orders'),
                    style: TextStyle(
                      fontSize: AppDimensions.getH3Size(context),
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
                  ),
                  SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
                  // List of Orders
                  Consumer<OrderViewModel>(
                    builder: (context, viewModel, child) {
                      // Show loading indicator
                      if (viewModel.isLoading) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(
                              AppDimensions.responsiveSpacing(context, mobile: 48, tablet: 60),
                            ),
                            child: const CircularProgressIndicator(),
                          ),
                        );
                      }

                      // Show error message
                      if (viewModel.errorMessage != null) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(
                              AppDimensions.getResponsiveHorizontalPadding(context),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: AppDimensions.responsiveIconSize(context, mobile: 48, tablet: 60),
                                  color: AppColors.error,
                                ),
                                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
                                Text(
                                  viewModel.errorMessage!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.error,
                                    fontSize: AppDimensions.getBodySize(context),
                                  ),
                                ),
                                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
                                ElevatedButton(
                                  onPressed: () => viewModel.fetchOrders(),
                                  child: Text(context.tr('retry')),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      // Show empty state
                      if (viewModel.orders.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(
                              AppDimensions.getResponsiveHorizontalPadding(context),
                            ),
                            child: Text(
                              context.tr('no_past_orders_found'),
                              style: TextStyle(
                                fontSize: AppDimensions.getBodySize(context),
                              ),
                            ),
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
                            ? '${firstItem.itemName} + ${order.items.length - 1} ${context.tr('more')}'
                            : firstItem.itemName;
                          
                          return GestureDetector(
                            onTap: () async {
                              // Check if context is mounted before starting
                              if (!context.mounted) {
                                return;
                              }
                              
                              // Capture navigator and scaffold messenger before async call
                              final navigator = Navigator.of(context);
                              final scaffoldMessenger = ScaffoldMessenger.of(context);
                              
                              // Fetch fresh order details from API
                              final orderDetails = await viewModel.getOrderById(order.id);
                              
                              if (orderDetails != null) {
                                // Navigate with fresh data using captured navigator
                                navigator.push(
                                  MaterialPageRoute(
                                    builder: (_) => OrderDetailsScreen(order: orderDetails),
                                  ),
                                );
                              } else if (viewModel.errorMessage != null) {
                                // Show error if fetch failed using captured scaffold messenger
                                scaffoldMessenger.showSnackBar(
                                  SnackBar(
                                    content: Text(viewModel.errorMessage!),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                              }
                             },
                            child: Consumer<CurrencyProvider>(
                               builder: (context, currencyProvider, child) {
                                  return PastOrderCard(
                                    title: title,
                                    price: currencyProvider.formatPrice(order.totalAmount),
                                    imageUrl: firstItem.branchImageUrl ?? '',
                                    onCancel: (order.status.trim().toLowerCase() == 'pending') 
                                        ? () => _showCancelDialog(context, viewModel, order.id) 
                                        : null,
                                  );
                               }
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
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context, OrderViewModel viewModel, int orderId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          context.tr('cancel_order'),
          style: TextStyle(
            fontSize: AppDimensions.getH3Size(context),
          ),
        ),
        content: Text(
          context.tr('cancel_order_confirm_message'),
          style: TextStyle(
            fontSize: AppDimensions.getBodySize(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(context.tr('no')),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              
              // Use the viewModel passed to the method
              final success = await viewModel.cancelOrder(orderId, 'Changed my mind');
              
              if (context.mounted) {
                if (success) {
                   ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(context.tr('order_cancelled_desc')), backgroundColor: AppColors.success),
                   );
                } else if (viewModel.errorMessage != null) {
                   ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(viewModel.errorMessage!), backgroundColor: AppColors.error),
                   );
                }
              }
            },
            child: Text(context.tr('yes'), style: const TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
