import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'package:foodora/features/menu/presentation/pages/order_details_screen.dart';
import 'package:foodora/features/order/domain/entities/order_entity.dart';
import 'package:foodora/core/extensions/context_extensions.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final OrderEntity order;

  const OrderConfirmationScreen({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          context.tr('order_confirmation'), 
          style: const TextStyle(
            color: AppColors.primaryText,
            fontSize: AppDimensions.fontSize18,
            fontWeight: FontWeight.w600,
          )
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            // Success Image
            Image.asset(
              'assets/images/success.png',
              height: 200, 
              fit: BoxFit.contain,
            ),
            
            const SizedBox(height: AppDimensions.spacing32),
            
            Text(
              context.tr('order_placed_successfully'),
              style: const TextStyle(
                fontSize: AppDimensions.spacing24,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacing16),
            Text(
              context.tr('order_placed_subtitle'),
              style: const TextStyle(
                fontSize: AppDimensions.fontSize16,
                color: AppColors.grey,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: AppDimensions.spacing48),
            
            // Order Details Header
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                context.tr('order_details'),
                style: const TextStyle(
                  fontSize: AppDimensions.fontSize18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spacing24),
            
            // Details Rows
            _DetailRow(label: context.tr('order_number'), value: '#${order.id}'),
            const SizedBox(height: AppDimensions.spacing16),
            _DetailRow(label: context.tr('estimated_time'), value: '30 ${context.tr('min')}'),
            const SizedBox(height: AppDimensions.spacing16),
            _DetailRow(label: context.tr('payment_method'), value: context.tr('cash')),

            
            const SizedBox(height: AppDimensions.spacing48),
            
            // View Order Button
            SizedBox(
              width: double.infinity,
              height: 56,
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
                  style: const TextStyle(
                    fontSize: AppDimensions.fontSize16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ],
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
          style: const TextStyle(
            fontSize: AppDimensions.fontSize16,
            color: AppColors.darkText,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: AppDimensions.fontSize16,
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }
}
