import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'package:foodora/features/order/domain/entities/order_entity.dart';
import 'package:foodora/features/order/presentation/widgets/widgets.dart';
import 'package:foodora/features/order/presentation/pages/order_tracking_screen.dart';
import 'package:intl/intl.dart';
import 'package:foodora/core/extensions/context_extensions.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderEntity order;

  const OrderDetailsScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: AppDimensions.responsiveIconSize(context, mobile: 24, tablet: 28),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          context.tr('order_details'),
          style: TextStyle(
            color: Colors.black,
            fontSize: AppDimensions.getH3Size(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: AppDimensions.getMaxContentWidth(context),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(
              AppDimensions.getResponsiveHorizontalPadding(context),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Info Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(
                    AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.responsiveSpacing(context, mobile: 12, tablet: 16),
                          vertical: AppDimensions.responsiveSpacing(context, mobile: 6, tablet: 8),
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(order.status).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _formatStatus(context, order.status),
                          style: TextStyle(
                            color: _getStatusColor(order.status),
                            fontWeight: FontWeight.w600,
                            fontSize: AppDimensions.getSmallSize(context),
                          ),
                        ),
                      ),
                      SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 12, tablet: 16)),
                      Text(
                        '${context.tr('order_number')} #${order.id}',
                        style: TextStyle(
                          fontSize: AppDimensions.getH3Size(context),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('MMM d, yyyy, h:mm a').format(order.createdAt),
                        style: TextStyle(
                          fontSize: AppDimensions.getSmallSize(context),
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 24, tablet: 32)),

                // Restaurant Branch Title
                Text(
                  context.tr('restaurant_branch'),
                  style: TextStyle(
                    fontSize: AppDimensions.getH3Size(context),
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 12, tablet: 16)),

                // Restaurant Branch Card
                Container(
                  padding: EdgeInsets.all(
                    AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: AppDimensions.responsive(context, mobile: 50, tablet: 60),
                        height: AppDimensions.responsive(context, mobile: 50, tablet: 60),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(12),
                          image: order.branchImageUrl != null && order.branchImageUrl!.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(order.branchImageUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: order.branchImageUrl != null && order.branchImageUrl!.isNotEmpty
                            ? null
                            : Icon(
                                Icons.restaurant,
                                color: const Color(0xFF4CAF50),
                                size: AppDimensions.responsiveIconSize(context, mobile: 24, tablet: 28),
                              ),
                      ),
                      SizedBox(width: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.branchName,
                              style: TextStyle(
                                fontSize: AppDimensions.getBodySize(context),
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              order.branchAddress ?? context.tr('no_address_available'),
                              style: TextStyle(
                                fontSize: AppDimensions.getSmallSize(context),
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 24, tablet: 32)),

                // Items Ordered Title
                Text(
                  context.tr('items_ordered'),
                  style: TextStyle(
                    fontSize: AppDimensions.getH3Size(context),
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 12, tablet: 16)),

                // Items List Container
                Container(
                  padding: EdgeInsets.all(
                    AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: order.items.map((item) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: AppDimensions.responsiveSpacing(context, mobile: 12, tablet: 16),
                        ),
                        child: OrderItemWidget(
                          name: item.itemName,
                          code: '${context.tr('qty')}: ${item.quantity}',
                          price: item.totalPrice,
                          imageUrl: item.branchImageUrl ?? '',
                        ),
                      );
                    }).toList(),
                  ),
                ),

                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 24, tablet: 32)),

                // Order Summary Title
                Text(
                  context.tr('order_summary'),
                  style: TextStyle(
                    fontSize: AppDimensions.getH3Size(context),
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 12, tablet: 16)),

                // Order Summary Card
                Container(
                  padding: EdgeInsets.all(
                    AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      PriceRowWidget(label: context.tr('delivery_fee'), amount: order.deliveryFee),
                      SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 12, tablet: 16)),
                      PriceRowWidget(label: context.tr('tax'), amount: order.taxAmount),
                      SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 12, tablet: 16)),
                      PriceRowWidget(label: context.tr('total'), amount: order.totalAmount, isBold: true),
                    ],
                  ),
                ),

                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 24, tablet: 32)),

                // Track Order Button
                SizedBox(
                  width: double.infinity,
                  height: AppDimensions.getButtonHeight(context),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderTrackingScreen(orderId: order.id),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF4CAF50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Color(0xFF4CAF50)),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      context.tr('track_order'),
                      style: TextStyle(
                        fontSize: AppDimensions.getBodySize(context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 24, tablet: 32)),

                // Total Paid Bar
                Container(
                  width: double.infinity,
                  height: AppDimensions.getButtonHeight(context),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.responsiveSpacing(context, mobile: 20, tablet: 28),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.tr('total_paid'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppDimensions.getBodySize(context),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '\$${order.totalAmount.toStringAsFixed(2)}', 
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppDimensions.getBodySize(context),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Bottom padding
                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 24, tablet: 32)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'preparing':
        return Colors.purple;
      case 'ready':
        return Colors.indigo;
      case 'out_for_delivery':
      case 'out for delivery':
        return Colors.teal;
      case 'delivered':
        return const Color(0xFF4CAF50);
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatStatus(BuildContext context, String status) {
    if (status.isEmpty) return 'Unknown';
    // Use localized string if available, otherwise fallback to formatted string
    final key = 'status_${status.toLowerCase().replaceAll(' ', '_')}';
    final localized = context.tr(key);
    
    // If translation key is returned (meaning no translation found), fallback to formatting
    if (localized == key) {
       return status
        .split('_')
        .map((word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '')
        .join(' ');
    }
    
    return localized;
  }
}
