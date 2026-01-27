import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'package:foodora/features/menu/presentation/pages/order_details_screen.dart';
import 'package:foodora/features/order/domain/entities/order_entity.dart';
import 'package:foodora/core/extensions/context_extensions.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final OrderEntity order;

  const OrderConfirmationScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          context.tr('order_confirmation'), 
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: AppDimensions.getH3Size(context),
            fontWeight: FontWeight.w600,
          )
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.primaryText,
            size: AppDimensions.responsiveIconSize(context, mobile: 24, tablet: 28),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 40, tablet: 56)),
                // Success Image
                Image.asset(
                  'assets/images/success.png',
                  height: AppDimensions.responsive(context, mobile: 200, tablet: 260, desktop: 300), 
                  fit: BoxFit.contain,
                ),
                
                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 32, tablet: 40)),
                
                Text(
                  context.tr('order_placed_successfully'),
                  style: TextStyle(
                    fontSize: AppDimensions.getH2Size(context),
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
                Text(
                  context.tr('order_placed_subtitle'),
                  style: TextStyle(
                    fontSize: AppDimensions.getBodySize(context),
                    color: AppColors.grey,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 48, tablet: 64)),
                
                // Order Details Header
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    context.tr('order_details'),
                    style: TextStyle(
                      fontSize: AppDimensions.getH3Size(context),
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
                  ),
                ),
                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 24, tablet: 32)),
                
                // Details Rows
                _DetailRow(label: context.tr('order_number'), value: '#${order.id}'),
                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
                _DetailRow(label: context.tr('estimated_time'), value: '30 ${context.tr('min')}'),
                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
                _DetailRow(label: context.tr('payment_method'), value: context.tr('cash')),

                
                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 48, tablet: 64)),
                
                // View Order Button
                SizedBox(
                  width: double.infinity,
                  height: AppDimensions.getButtonHeight(context),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to Order Details
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => OrderDetailsScreen(order: order),
                        ),
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
                      context.tr('view_order'),
                      style: TextStyle(
                        fontSize: AppDimensions.getBodySize(context),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppDimensions.getBodySize(context),
            color: AppColors.darkText,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: AppDimensions.getBodySize(context),
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }
}
