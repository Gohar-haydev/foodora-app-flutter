import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'package:foodora/features/menu/presentation/pages/order_details_screen.dart';
import 'package:foodora/features/order/domain/entities/order_entity.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final OrderEntity order;

  const OrderConfirmationScreen({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Order Confirmation', 
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          )
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            // Success Icon
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryAccent, 
              ),
              padding: const EdgeInsets.all(24),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 64,
              ),
            ),
             // A more specific "Badge" shape could be used if strict adherence to image is needed, 
             // but a circle with check is standard and close. 
             // The image shows a wavy circle. Simple circle is usually acceptable unless SVG is provided.
            
            const SizedBox(height: 32),
            
            const Text(
              'Order Placed Successfully!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Your order has been received and is being prepared. You will receive a notification when it\'s ready for pickup.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 48),
            
            // Order Details Header
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Order Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Details Rows
            _DetailRow(label: 'Order Number', value: '#${order.id}'),
            const SizedBox(height: 16),
            const _DetailRow(label: 'Estimated Time', value: '30 minutes'),
            const SizedBox(height: 16),
            const _DetailRow(label: 'Payment Method', value: 'Cash'),

            
            const SizedBox(height: 48),
            
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
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'VIEW ORDER',
                  style: TextStyle(
                    fontSize: 16,
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
            fontSize: 16,
            color: Color(0xFF1F2937), // Dark text
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey, // Lighter text for value as per typical design, or swap if needed
             // Looking at image: Label is standard, Value might be gray. 
             // Actually image shows: Label dark, Value gray.
          ),
        ),
      ],
    );
  }
}
